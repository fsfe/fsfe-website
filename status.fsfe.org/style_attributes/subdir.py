# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Show what files have improper style attributes."""

import logging
import multiprocessing
from collections import defaultdict
from pathlib import Path

from fsfe_website_build.lib.misc import (
    get_basepath,
    lang_from_filename,
    run_command,
    update_if_changed,
)
from lxml import etree

logger = logging.getLogger(__name__)


def _worker(path: Path) -> tuple[str, Path, Path, list[tuple[str, str]]] | None:
    doc = etree.parse(path)

    # all elements that carry a style attribute
    results = [
        (element.tag, element.get("style")) for element in doc.xpath("//*[@style]")
    ]
    if not results:
        return None

    suffix = path.suffix
    base = get_basepath(path) if suffix in (".xml", ".xhtml") else path
    return suffix.lstrip("."), base, path, results


def run(source: Path, languages: list[str], processes: int, working_dir: Path) -> None:  # noqa: ARG001
    """Generate an XML index of files with styles.

    This contains every tracked file which has
    at least one element carrying a style attribute.
    """
    target_dir = working_dir / "data"
    target_dir.mkdir(parents=True, exist_ok=True)
    out_file = target_dir / "style-attribute-status.en.xml"

    # every tracked file we are interested in
    git_files = run_command(["git", "ls-files", "-z"])
    candidates = [
        path
        for path in (Path(line) for line in git_files.split("\x00"))
        if (
            path.suffix == ".xsl"
            or (
                path.suffix in {".xhtml", ".xml"}
                and len(path.suffixes) >= 2  # noqa: PLR2004
                and lang_from_filename(path) in languages
            )
        )
    ]

    # concurrent filtering
    with multiprocessing.Pool(processes) as pool:
        filtered = [
            result for result in pool.map(_worker, candidates) if result is not None
        ]

    # dict to sort values by type, basepath, finalpath
    data: defaultdict[str, defaultdict[Path, dict[Path, list[tuple[str, str]]]]] = (
        defaultdict(lambda: defaultdict(dict))
    )
    for file_type, base, path, styles in filtered:
        data[file_type][base][path] = styles

    root = etree.Element("style-attribute-status")
    etree.SubElement(root, "version").text = "1"

    for file_type, bases in data.items():
        type_element = etree.SubElement(root, "filetype", name=file_type)
        for base, paths in bases.items():
            base_element = etree.SubElement(type_element, "basepath", name=str(base))
            for path, styles in paths.items():
                file_element = etree.SubElement(
                    base_element, "localised", path=str(path)
                )
                for tag, style in styles:
                    etree.SubElement(file_element, "style", element=tag, value=style)

    xml_bytes = etree.tostring(root, xml_declaration=True, encoding="utf-8")
    update_if_changed(out_file, xml_bytes.decode("utf-8"))
    logger.debug("Wrote style-attribute index to %s", out_file)
