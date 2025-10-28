# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
import logging
import sys
from pathlib import Path

from lxml import etree

logger = logging.getLogger(__name__)


def compare_files(
    file1: Path,
    file2: Path,
    attr_whitelist: set[str] | None = None,
    _path: str = "",
) -> list[str]:
    try:
        t1, t2 = etree.parse(file1), etree.parse(file2)
    except etree.XMLSyntaxError as e:
        logger.critical("XML parse error: %s", e)
        sys.exit(1)

    return compare_elements(t1.getroot(), t2.getroot(), attr_whitelist)


def compare_elements(
    elem1: etree.Element,
    elem2: etree.Element,
    attr_whitelist: set[str] | None = None,
    _path: str = "",
) -> list[str]:
    """
    Recursively compare two XML elements.
    Returns a list of short, informative error strings.
    """
    if attr_whitelist is None:
        attr_whitelist = set()

    errors: list[str] = []
    tag_path = f"{_path}/{elem1.tag}" if _path else elem1.tag

    # tag mismatch
    if elem1.tag != elem2.tag:
        errors.append(f"Tag mismatch at {tag_path}: {elem1.tag} ≠ {elem2.tag}")
        return errors  # if tags differ, stop descending

    # attribute deltas
    attributes_of_elem1 = dict(elem1.attrib.items())
    attributes_of_elem2 = dict(elem2.attrib.items())

    only_in_elem1 = set(attributes_of_elem1) - set(attributes_of_elem2)
    only_in_elem2 = set(attributes_of_elem2) - set(attributes_of_elem1)
    common = set(attributes_of_elem1) & set(attributes_of_elem2)

    if only_in_elem1 or only_in_elem2:
        errors.append(
            f"Attribute delta at <{elem1.tag}>"
            f"  only 1: {list(only_in_elem1)}  only 2: {list(only_in_elem2)}"
        )
    for key in common:
        if (
            attributes_of_elem1[key] != attributes_of_elem2[key]
            and key not in attr_whitelist
        ):
            error_msg = (
                f"Attribute value diff at <{elem1.tag} {key}>:"
                f" {attributes_of_elem1[key]!r} ≠ {attributes_of_elem2[key]!r}"
            )
            errors.append(error_msg)

    # child count
    kids1 = list(elem1)
    kids2 = list(elem2)
    if len(kids1) != len(kids2):
        errors.append(f"Child count at <{elem1.tag}>: {len(kids1)} ≠ {len(kids2)}")
        return errors  # if counts differ, stop descending

    # and then recurse into children
    for idx, (child1, child2) in enumerate(zip(kids1, kids2, strict=False), start=1):
        errors.extend(
            compare_elements(child1, child2, attr_whitelist, _path=f"{tag_path}[{idx}]")
        )

    return errors
