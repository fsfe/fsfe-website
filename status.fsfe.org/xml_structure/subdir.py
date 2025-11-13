# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Show what files have mismatched xml structures across languages."""

import logging
import multiprocessing
from collections import defaultdict
from pathlib import Path

from fsfe_website_build.lib.checks import compare_files
from fsfe_website_build.lib.misc import (
    get_basepath,
    get_version,
    lang_from_filename,
    run_command,
    update_if_changed,
)
from lxml import etree

logger = logging.getLogger(__name__)


def _job(
    master: Path, other: Path, whitelist: set[str]
) -> tuple[Path, Path, str] | None:
    """Return a one-line result string for starmap."""
    if get_version(master) != get_version(other):
        return None
    errs = compare_files(master, other, whitelist)
    return (master, other, f"{'; '.join(errs)}") if errs else None


def run(source: Path, languages: list[str], processes: int, working_dir: Path) -> None:  # noqa: ARG001
    """Build xml-structure log for displaying on a status page.

    Xmls are placed in target_dir, and only passed languages are processed.
    """
    target_dir = working_dir.joinpath("data/")
    logger.debug("Building index of status of xml structure into dir %s", target_dir)
    all_git_tracked_files = run_command(
        ["git", "ls-files", "-z"],
    )

    all_files = sorted(
        {
            # Split on null bytes, strip and then parse into path
            path
            for path in (
                Path(line.strip()) for line in all_git_tracked_files.split("\x00")
            )
            if path.suffix in [".xhtml", ".xml"]
            and len(path.suffixes) >= 2  # noqa: PLR2004
            and lang_from_filename(path) in languages
        }
    )
    whitelist = {"alt"}
    groups: defaultdict[Path, list[Path]] = defaultdict(list)
    for file in all_files:
        path = Path(file)
        groups[get_basepath(path)].append(path)

    tasks: list[tuple[Path, Path, set[str]]] = []
    for basepath, paths in groups.items():
        master = next(
            (path for path in paths if lang_from_filename(path) == "en"),
            None,
        )
        if not master:
            logger.debug("No english translation  of %s - skipped", basepath)
            continue
        tasks.extend((master, path, whitelist) for path in paths if path != master)

    with multiprocessing.Pool(processes) as pool:
        filtered_results = [
            result for result in pool.starmap(_job, tasks) if result is not None
        ]

    # Build dict: master: list of (other, message)
    tree: dict[Path, list[tuple[Path, str]]] = defaultdict(list)
    for master, other, message in filtered_results:
        tree[master].append((other, message))

    # Generate XML
    work_file = target_dir.joinpath("xml-structure-status.en.xml")
    target_dir.mkdir(parents=True, exist_ok=True)

    root = etree.Element("xml-structure-status")
    version_el = etree.SubElement(root, "version")
    version_el.text = "1"

    for master, details in sorted(tree.items()):
        master_el = etree.SubElement(root, "master", name=str(master))
        for other, msg in sorted(details):
            etree.SubElement(master_el, "detail", name=str(other), error=msg)

    xml_bytes = etree.tostring(root, xml_declaration=True, encoding="utf-8")
    update_if_changed(work_file, xml_bytes.decode("utf-8"))
