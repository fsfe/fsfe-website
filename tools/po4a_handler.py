#!/usr/bin/env python3

# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Generate po4a configs and run po4a.

All po4a operations needed in the repo should be done through this script.
"""

import argparse
import copy
import logging
import multiprocessing
import multiprocessing.pool
import os
import subprocess
import sys
from collections import defaultdict
from functools import partial
from pathlib import Path

import polib
from fsfe_website_build.lib.checks import compare_elements
from fsfe_website_build.lib.misc import (
    get_basepath,
    get_version,
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

UNTRANSLATED_OPT = 'opt:"-o untranslated=\\"<version> <html><translator>\\""'

# Higher value = offered to translators earlier. Bucket 6 inherits
# Weblate's default of 100, so we don't stamp it.
PRIORITY_VALUES = {"1": 600, "2": 500, "3": 400, "4": 300, "5": 200}

# Language attributes that legitimately differ between language variants.
_LANG_ATTRS = (
    "lang",
    "xml:lang",
    "{http://www.w3.org/XML/1998/namespace}lang",
)

# Locale used when invoking po4a/gettext tools. Avoids msginit failures in
# minimal Nix shells where the host locale is unavailable.
_GETTEXT_ENV = {"LC_ALL": "C.UTF-8", "LANG": "C.UTF-8", "LANGUAGE": "C.UTF-8"}


def _gettext_env() -> dict[str, str]:
    """Return environment with a safe C.UTF-8 locale for gettext tools."""
    env = os.environ.copy()
    env.update(_GETTEXT_ENV)
    return env


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
    """Bucket every translatable, git-tracked English master into its priority."""
    git_output = run_command(["git", "ls-files", "-z"])
    all_masters = sorted(
        path
        for path in (Path(line) for line in git_output.split("\x00") if line)
        if path.suffix in {".xhtml", ".xml"}
        and len(path.suffixes) >= 2  # noqa: PLR2004
        and lang_from_filename(path) == SOURCE_LANG
    )

    files_by_priority: dict[str, list[Path]] = defaultdict(list)
    for file in all_masters:
        for priority, searches in PRIORITIES_AND_SEARCHES.items():
            if any(file.full_match(search) for search in searches):
                files_by_priority[priority].append(file)
                break
    return files_by_priority


def _master_stem(master: Path) -> str:
    """Repo-relative POSIX path of master with the .<lang>.<ext> suffix stripped."""
    return get_basepath(master).as_posix()


def _po_dir(prio: str) -> Path:
    return TRANSLATION_OUTPUT_FOLDER / prio


def _po_path(master: Path, lang: str, prio: str) -> Path:
    return _po_dir(prio) / f"{_master_stem(master)}.{lang}.po"


def _localized_for(master: Path, lang: str) -> Path | None:
    """Map an .en.xhtml/.en.xml master to its localized sibling."""
    if lang_from_filename(master) != SOURCE_LANG:
        return None
    return get_basepath(master).with_suffix(f".{lang}{master.suffix}")


def _strip_lang_attrs(root: etree.Element) -> None:
    """Remove language attributes from the whole tree."""
    for el in root.iter():
        for attr in _LANG_ATTRS:
            el.attrib.pop(attr, None)


def _structurally_compatible(master: Path, localized: Path) -> bool:
    """Return True if localized has the same XML structure as master.

    Language attributes are ignored because they legitimately differ.
    """
    parser = etree.XMLParser(remove_comments=True)
    try:
        master_tree = etree.parse(master, parser)
        localized_tree = etree.parse(localized, parser)
    except (etree.ParseError, OSError) as exc:
        log.warning(
            "Could not parse %s or %s for structural comparison: %s",
            master,
            localized,
            exc,
        )
        return False

    master_root = copy.deepcopy(master_tree.getroot())
    localized_root = copy.deepcopy(localized_tree.getroot())
    _strip_lang_attrs(master_root)
    _strip_lang_attrs(localized_root)

    errors = compare_elements(master_root, localized_root)
    if errors:
        log.warning(
            "Skipping %s: structural mismatch with %s (%s)",
            localized,
            master,
            errors[0],
        )
        return False
    return True


def _unfuzzy(po_path: Path, unfuzzy: bool) -> None:
    """Normalize trailing newlines; optionally clear fuzzy on real translations."""
    po = polib.pofile(str(po_path))
    changed = False
    for entry in po:
        msgstr = entry.msgstr
        if msgstr:
            id_nl = entry.msgid.endswith("\n")
            str_nl = msgstr.endswith("\n")
            if id_nl and not str_nl:
                msgstr = msgstr + "\n"
            elif str_nl and not id_nl:
                msgstr = msgstr.rstrip("\n")
            if msgstr != entry.msgstr:
                entry.msgstr = msgstr
                changed = True
        if unfuzzy and entry.msgstr and "fuzzy" in entry.flags:
            entry.flags.remove("fuzzy")
            changed = True
    if changed:
        po.save(str(po_path))


def _stamp_priority(po_path: Path, prio: str) -> None:
    """Stamp ``priority:N`` on every entry, replacing any prior priority flag."""
    value = PRIORITY_VALUES.get(prio)
    if value is None or not po_path.exists():
        return
    po = polib.pofile(str(po_path))
    flag = f"priority:{value}"
    changed = False
    for entry in po:
        cleaned = [f for f in entry.flags if not f.startswith("priority:")]
        cleaned.append(flag)
        if cleaned != entry.flags:
            entry.flags = cleaned
            changed = True
    if changed:
        po.save(str(po_path))


def _po_is_valid(po_path: Path) -> bool:
    """Return True if polib can read the file."""
    try:
        polib.pofile(str(po_path))
    except Exception as exc:
        log.warning("PO file %s is invalid: %s", po_path, exc)
        return False
    return True


def _read_version_safe(path: Path) -> int:
    """Return version, treating parse errors or missing tag as 0."""
    try:
        return get_version(path)
    except Exception as exc:
        log.warning("Could not read version from %s: %s", path, exc)
        return 0


def _gettextize_worker(
    job: tuple[Path, Path, Path, str, str],
) -> None:
    """Salvage one (master, lang) pair into its on-disk PO."""
    master, localized, po_path, file_type, prio = job
    po_path.parent.mkdir(parents=True, exist_ok=True)
    cmd = [
        "po4a-gettextize",
        "-f",
        file_type,
        "-M",
        "UTF-8",
        "-L",
        "UTF-8",
        "-m",
        str(master.resolve()),
        "-l",
        str(localized.resolve()),
        "-p",
        str(po_path),
    ]
    result = subprocess.run(
        cmd,
        capture_output=True,
        text=True,
        encoding="utf-8",
        errors="replace",
        env=_gettext_env(),
        check=False,
    )
    if result.returncode != 0 or not po_path.exists():
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
        if po_path.exists():
            po_path.unlink()
        return

    if not _po_is_valid(po_path):
        po_path.unlink()
        return

    master_v = _read_version_safe(master)
    local_v = _read_version_safe(localized)
    if master_v and local_v and local_v > master_v:
        log.warning(
            "Localized %s version (%d) ahead of master %s (%d)",
            localized,
            local_v,
            master,
            master_v,
        )
    versions_equal = master_v != 0 and local_v != 0 and master_v == local_v
    _unfuzzy(po_path, unfuzzy=versions_equal)
    _stamp_priority(po_path, prio)


def _po4a_worker(cfg: Path, no_translations: bool) -> str | None:
    """Run po4a on a single config. Return an error string on failure."""
    cmd = ["po4a", "--keep", "1"]
    if no_translations:
        cmd.append("--no-translations")
    cmd.append(str(cfg))
    result = subprocess.run(
        cmd,
        capture_output=True,
        text=True,
        encoding="utf-8",
        errors="replace",
        env=_gettext_env(),
        check=False,
    )
    if result.stderr:
        for line in result.stderr.splitlines():
            log.info("po4a[%s]: %s", cfg.name, line)
    if result.returncode != 0:
        return (
            f"po4a failed on {cfg} (exit {result.returncode})\n"
            f"stdout:\n{result.stdout}\n"
            f"stderr:\n{result.stderr}"
        )
    return None


def _build_writable(
    prio: str,
    masters: list[Path],
    languages: list[str],
) -> dict[Path, list[str]]:
    """Check if a (master, lang) is writable.

    True if and only if its PO already exists on disk, is valid, and the
    localized file is structurally compatible with the master.
    """
    return {
        m: [
            lang
            for lang in languages
            if (po := _po_path(m, lang, prio)).exists()
            and _po_is_valid(po)
            and (localized := _localized_for(m, lang)) is not None
            and _structurally_compatible(m, localized)
        ]
        for m in masters
    }


def _salvage_priority(
    prio: str,
    masters: list[Path],
    languages: list[str],
    pool: multiprocessing.pool.Pool,
) -> None:
    """Regenerate every per-(master, lang) PO from localized files."""
    jobs: list[tuple[Path, Path, Path, str, str]] = []
    for master in masters:
        for lang in languages:
            localized = _localized_for(master, lang)
            if localized is None or not localized.exists():
                continue
            if not _structurally_compatible(master, localized):
                continue
            jobs.append(
                (
                    master,
                    localized,
                    _po_path(master, lang, prio),
                    master.suffix.lstrip("."),
                    prio,
                )
            )
    if not jobs:
        return
    log.info("Priority %s: salvaging %d (master, lang) pairs", prio, len(jobs))
    pool.map(_gettextize_worker, jobs)


def _gen_config(prio: str, writable: dict[Path, list[str]]) -> Path | None:
    """Write the po4a config for one priority bucket."""
    po_dir = _po_dir(prio)
    po_dir.mkdir(parents=True, exist_ok=True)

    # Get unique set of all languages used across all masters in this bucket
    all_langs = sorted({lang for langs in writable.values() for lang in langs})
    if not all_langs:
        log.warning("Priority %s: no writable (master, lang) pairs, skipping", prio)
        return None

    pot_template = f"{po_dir.as_posix()}/$master.pot"
    po_template = f"$lang:{po_dir.as_posix()}/$master.$lang.po"

    lines = [
        "[po4a_langs] " + " ".join(all_langs),
        "",
        "[po4a_alias:xhtml] xhtml",
        "[po4a_alias:xml] xml",
        "",
        f"[po4a_paths] {pot_template} {po_template}",
        "",
    ]

    n = 0
    for master in sorted(writable):
        langs = writable[master]
        if not langs:
            continue
        ext = master.suffix.lstrip(".")
        basepath = get_basepath(master)
        targets = " ".join(
            f"{lang}:{basepath}.{lang}{master.suffix}" for lang in sorted(langs)
        )
        lines.append(
            f"[type: {ext}] {master} {targets} "
            f"pot={_master_stem(master)} {UNTRANSLATED_OPT}"
        )
        n += 1

    cfg = CONFIG_FOLDER / f"priority-{prio}.cfg"
    update_if_changed(cfg, "\n".join(lines) + "\n")
    log.info("Wrote %s (%d masters)", cfg, n)
    return cfg


def _restamp_bucket(prio: str, writable: dict[Path, list[str]]) -> None:
    """Re-apply priority flag after po4a's msgmerge may have added entries."""
    if prio not in PRIORITY_VALUES:
        return
    for master, langs in writable.items():
        for lang in langs:
            _stamp_priority(_po_path(master, lang, prio), prio)


def _prepare(
    pool: multiprocessing.pool.Pool,
    salvage: bool,
) -> list[tuple[str, Path, dict[Path, list[str]]]]:
    """Build per-bucket configs; optionally salvage POs from xhtml first."""
    languages = _detect_target_languages()
    TRANSLATION_OUTPUT_FOLDER.mkdir(parents=True, exist_ok=True)
    CONFIG_FOLDER.mkdir(parents=True, exist_ok=True)

    files_by_priority = _collect_files_by_priority()

    result: list[tuple[str, Path, dict[Path, list[str]]]] = []
    for prio in PRIORITIES_AND_SEARCHES:
        masters = files_by_priority.get(prio, [])
        if not masters:
            log.warning("Priority %s: no files matched, skipping", prio)
            continue
        if salvage:
            _salvage_priority(prio, masters, languages, pool)
        writable = _build_writable(prio, masters, languages)
        cfg = _gen_config(prio, writable)
        if cfg is not None:
            result.append((prio, cfg, writable))
    return result


def _run_po4a(
    pool: multiprocessing.pool.Pool,
    cfgs: list[Path],
    no_translations: bool,
) -> None:
    """Run po4a across every priority config in parallel."""
    errors = [
        err
        for err in pool.map(
            partial(_po4a_worker, no_translations=no_translations), cfgs
        )
        if err
    ]
    if errors:
        for err in errors:
            log.error(err)
        sys.exit(1)


def _cmd_update_po(pool: multiprocessing.pool.Pool) -> None:
    """Rebuild POT/PO files from the current xhtml sources."""
    prepared = _prepare(pool, salvage=True)
    if not prepared:
        log.error("No configs generated")
        sys.exit(1)
    _run_po4a(pool, [cfg for _, cfg, _ in prepared], no_translations=True)
    for prio, _, writable in prepared:
        _restamp_bucket(prio, writable)


def _cmd_update_source(pool: multiprocessing.pool.Pool) -> None:
    """Write translations from PO files back into localized xhtml."""
    prepared = _prepare(pool, salvage=False)
    if not prepared:
        log.error("No configs generated")
        sys.exit(1)
    _run_po4a(pool, [cfg for _, cfg, _ in prepared], no_translations=False)


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

    with multiprocessing.Pool(processes=args.processes) as pool:
        args.func(pool)


if __name__ == "__main__":
    main()
