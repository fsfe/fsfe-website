#!/usr/bin/env python3

# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Generate po4a configs and run po4a.

All po4a operations needed in the repo should be done through this script.
"""

import argparse
import logging
import multiprocessing
import multiprocessing.pool
import shutil
import subprocess
import sys
import tempfile
from collections import defaultdict
from functools import partial
from pathlib import Path

from fsfe_website_build.lib.checks import compare_elements
from fsfe_website_build.lib.misc import (
    delete_file,
    get_basepath,
    lang_from_filename,
    run_command,
    update_if_changed,
)
from fsfe_website_build.lib.translation_priorities import PRIORITIES_AND_SEARCHES
from lxml import etree

log = logging.getLogger(__name__)

CONFIG_FOLDER = Path("po4a_configs")
LANGUAGES_FOLDER = Path("global/languages")
SITE = "fsfe.org"
TRANSLATION_OUTPUT_FOLDER = Path("translations") / SITE
SOURCE_LANG = "en"

IGNORE_ALL_ATTRS_XPATHS = ("//*/@*",)


def _detect_target_languages() -> list[str]:
    """List the languages we translate into."""
    if not LANGUAGES_FOLDER.is_dir():
        log.error("Languages folder %s not found", LANGUAGES_FOLDER)
        sys.exit(1)
    langs = sorted(
        f.name
        for f in LANGUAGES_FOLDER.iterdir()
        if f.is_file() and f.name != SOURCE_LANG
    )
    if not langs:
        log.error("No target languages found in %s", LANGUAGES_FOLDER)
        sys.exit(1)
    return langs


def _collect_files_by_priority() -> dict[str, list[Path]]:
    """Bucket every translatable, git-tracked English master into its priority.

    The patterns in PRIORITIES_AND_SEARCHES are required to only match
    English masters. Anything not git-tracked or not matched by a
    priority's patterns gets silently dropped, so generated files don't
    end up in our POs.
    """
    git_output = run_command(["git", "ls-files", "-z"])
    all_translatable = sorted(
        path
        for path in (Path(line.strip()) for line in git_output.split("\x00"))
        if path.suffix in {".xhtml", ".xml"} and path.name
    )

    files_by_priority: dict[str, list[Path]] = defaultdict(list)
    for file in all_translatable:
        for priority, searches in PRIORITIES_AND_SEARCHES.items():
            if any(file.full_match(search) for search in searches):
                files_by_priority[priority].append(file)
                break
    return files_by_priority


def _po_path(po_dir: Path, prio: str, lang: str) -> Path:
    return po_dir / f"priority-{prio}.{lang}.po"


def _pot_path(po_dir: Path, prio: str) -> Path:
    return po_dir / f"priority-{prio}.pot"


def _localized_for(master: Path, lang: str) -> Path | None:
    """Map an .en.xhtml/.en.xml master to its localized sibling."""
    if lang_from_filename(master) != SOURCE_LANG:
        return None
    return get_basepath(master).with_suffix(f".{lang}{master.suffix}")


def _parse_xml(path: Path) -> etree._Element | None:
    """Parse an xml/xhtml file, or warn and skip if it doesn't parse."""
    parser = etree.XMLParser(remove_comments=True)
    try:
        return etree.parse(str(path), parser).getroot()
    except etree.XMLSyntaxError:
        log.exception("XML parse error in %s", path)
        return None


def _structures_match(master: Path, localized: Path) -> bool:
    """Check master and localized have the same xml structure.

    po4a-gettextize needs the two trees to line up exactly. We ignore
    all attributes because translators legitimately change things like
    xml:lang or href targets.
    """
    root1 = _parse_xml(master)
    if root1 is None:
        return False
    root2 = _parse_xml(localized)
    if root2 is None:
        return False
    errors = compare_elements(root1, root2, xpaths_to_ignore=IGNORE_ALL_ATTRS_XPATHS)
    if errors:
        log.warning(
            "Different xml structure, skipping: %s <-> %s (%d differences)",
            master,
            localized,
            len(errors),
        )
        return False
    return True


def _check_writable(job: tuple[Path, str]) -> tuple[Path, str, bool]:
    """Decide whether po4a may write this (master, lang) output.

    A (master, lang) is writable when the localized file is absent
    (po4a will create it), or it exists and matches the master's
    structure.

    Files with different xml structure need manual fixing before they can be handled.
    We have to make sure to ignore them, or po4a deletes them.
    """
    master, lang = job
    localized = _localized_for(master, lang)
    if localized is None:
        return master, lang, False
    if not localized.exists():
        return master, lang, True
    return master, lang, _structures_match(master, localized)


def _compute_writable(
    matches: list[Path],
    languages: list[str],
    pool: multiprocessing.pool.Pool,
) -> dict[Path, list[str]]:
    """Map each master to the langs whose output po4a is allowed to touch."""
    jobs = [(master, lang) for master in matches for lang in languages]
    writable: dict[Path, list[str]] = {m: [] for m in matches}
    for master, lang, ok in pool.map(_check_writable, jobs):
        if ok:
            writable[master].append(lang)
    return writable


def _gettextize_worker(job: tuple[Path, Path, Path, str]) -> Path | None:
    """Salvage one master/localized pair into a temp PO."""
    master, localized, temp_po, file_type = job

    cmd = [
        "po4a-gettextize",
        "-f",
        file_type,
        "-M",
        "UTF-8",
        "-L",
        "UTF-8",
        "-m",
        str(master),
        "-l",
        str(localized),
        "-p",
        str(temp_po),
    ]
    result = subprocess.run(cmd, capture_output=True, text=True, check=False)
    if result.returncode != 0 or not temp_po.exists():
        last_err = (
            result.stderr.strip().splitlines()[-1]
            if result.stderr.strip()
            else "no stderr"
        )
        log.warning(
            "po4a-gettextize couldn't salvage %s <-> %s: %s",
            master,
            localized,
            last_err,
        )
        return None
    return temp_po


def _po4a_worker(cfg: Path, no_translations: bool) -> None:
    """Run po4a on a single config."""
    cmd = ["po4a", "--keep=1"]
    if no_translations:
        cmd.append("--no-translations")
    cmd.append(str(cfg))
    run_command(cmd)


def _msgcat(target_po: Path, temp_pos: list[Path]) -> None:
    """Merge per-file temp POs into one priority-level PO."""
    run_command(["msgcat", "-o", str(target_po), *map(str, sorted(temp_pos))])


def _salvage_priority(
    prio: str,
    matches: list[Path],
    languages: list[str],
    writable: dict[Path, list[str]],
    pool: multiprocessing.pool.Pool,
) -> None:
    """Rebuild every per-language PO for one priority from localized files.

    POs are pure derivatives of the xhtml: we destroy and rebuild them on
    every update-po run, so anything not represented by a writable
    localized file on disk vanishes from the PO.
    """
    po_dir = TRANSLATION_OUTPUT_FOLDER / prio
    po_dir.mkdir(parents=True, exist_ok=True)

    temp_dir = Path(tempfile.mkdtemp(prefix="salvage_", dir=po_dir))

    try:
        jobs: list[tuple[Path, Path, Path, str]] = []
        job_langs: list[str] = []
        per_lang: dict[str, list[Path]] = {lang: [] for lang in languages}

        for master in matches:
            for lang in writable.get(master, []):
                localized = _localized_for(master, lang)
                if localized is None or not localized.exists():
                    continue
                ext = master.suffix.lstrip(".")
                key = str(master).replace("/", "_")
                temp_po = temp_dir / f"{key}.{lang}.po"
                jobs.append((master, localized, temp_po, ext))
                job_langs.append(lang)

        if jobs:
            results = pool.map(_gettextize_worker, jobs)
            for lang, result in zip(job_langs, results, strict=True):
                if result is not None:
                    per_lang[lang].append(result)

        for lang in languages:
            target_po = _po_path(po_dir, prio, lang)
            temp_pos = per_lang[lang]
            if not temp_pos:
                if target_po.exists():
                    delete_file(target_po)
                continue
            log.info("Priority %s / %s: salvaging %d files", prio, lang, len(temp_pos))
            _msgcat(target_po, temp_pos)
    finally:
        shutil.rmtree(temp_dir, ignore_errors=True)


def _gen_config(
    prio: str,
    matches: list[Path],
    languages: list[str],
    writable: dict[Path, list[str]],
) -> Path | None:
    """Write the po4a config for one priority.

    Only emit per-file lang targets for langs whose existing localized
    file is absent or structurally matches the master. Drifted outputs
    are omitted so po4a never rewrites or deletes them.
    """
    po_dir = TRANSLATION_OUTPUT_FOLDER / prio
    po_dir.mkdir(parents=True, exist_ok=True)

    lines = [
        "[po4a_alias:xhtml] xhtml",
        "[po4a_alias:xml] xml",
        "",
    ]

    pot = _pot_path(po_dir, prio)
    po_targets = " ".join(
        f"{lang}:{_po_path(po_dir, prio, lang)}" for lang in languages
    )
    lines.append(f"[po4a_paths] {pot} {po_targets}")
    lines.append("")

    file_lines = 0
    for f in matches:
        langs = writable.get(f, [])
        if not langs:
            continue
        ext = f.suffix.lstrip(".")
        basepath = get_basepath(f)
        targets = " ".join(f"{lang}:{basepath}.{lang}{f.suffix}" for lang in langs)
        lines.append(f"[type: {ext}] {f} {targets}")
        file_lines += 1

    if file_lines == 0:
        log.warning(
            "Priority %s: no writable (master, lang) pairs, skipping config", prio
        )
        return None

    cfg = CONFIG_FOLDER / f"priority-{prio}.cfg"
    update_if_changed(cfg, "\n".join(lines) + "\n")
    log.info("Wrote %s (%d files)", cfg, file_lines)
    return cfg


def _prepare(
    pool: multiprocessing.pool.Pool,
    salvage: bool,
) -> list[Path]:
    """Compute writable pairs, optionally salvage, then emit the configs."""
    languages = _detect_target_languages()
    TRANSLATION_OUTPUT_FOLDER.mkdir(parents=True, exist_ok=True)
    CONFIG_FOLDER.mkdir(parents=True, exist_ok=True)

    files_by_priority = _collect_files_by_priority()

    cfgs: list[Path] = []
    for prio in PRIORITIES_AND_SEARCHES:
        matches = files_by_priority.get(prio, [])
        if not matches:
            log.warning("Priority %s: no files matched, skipping", prio)
            continue
        writable = _compute_writable(matches, languages, pool)
        if salvage:
            _salvage_priority(prio, matches, languages, writable, pool)
        cfg = _gen_config(prio, matches, languages, writable)
        if cfg is not None:
            cfgs.append(cfg)
    return cfgs


def _run_po4a(
    pool: multiprocessing.pool.Pool,
    cfgs: list[Path],
    no_translations: bool,
) -> None:
    """Run po4a across every priority config in parallel."""
    pool.map(partial(_po4a_worker, no_translations=no_translations), cfgs)


def _cmd_update_po(pool: multiprocessing.pool.Pool) -> None:
    """Rebuild POT/PO files from the current xhtml sources."""
    cfgs = _prepare(pool, salvage=True)
    if not cfgs:
        log.error("No configs generated")
        sys.exit(1)
    _run_po4a(pool, cfgs, no_translations=True)


def _cmd_update_source(pool: multiprocessing.pool.Pool) -> None:
    """Write translations from PO files back into localized xhtml."""
    cfgs = _prepare(pool, salvage=False)
    if not cfgs:
        log.error("No configs generated")
        sys.exit(1)
    _run_po4a(pool, cfgs, no_translations=False)


def main() -> None:
    """Handle XHTML->po and po->XHTML."""
    parser = argparse.ArgumentParser(
        description="Manage po4a translation workflow.",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    parser.add_argument(
        "--log-level",
        default="INFO",
        choices=["DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"],
    )
    parser.add_argument(
        "--processes",
        type=int,
        default=multiprocessing.cpu_count(),
        help="Number of processes to use when building the website.",
    )
    subs = parser.add_subparsers(dest="cmd", required=True)

    p_po = subs.add_parser(
        "update-po",
        help="Regenerate POT/PO from XHTML|XML (salvages existing localized files).",
    )
    p_po.set_defaults(func=_cmd_update_po)

    p_src = subs.add_parser(
        "update-source",
        help="Write translated XHTML|XML from PO files.",
    )
    p_src.set_defaults(func=_cmd_update_source)

    args = parser.parse_args()
    logging.basicConfig(
        format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S",
        level=args.log_level,
    )

    try:
        with multiprocessing.Pool(processes=args.processes) as pool:
            args.func(pool)
    except subprocess.CalledProcessError as exc:
        log.exception("Subprocess failed (exit %s): %s", exc.returncode, exc.cmd)
        sys.exit(exc.returncode or 1)


if __name__ == "__main__":
    main()
