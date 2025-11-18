# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Lib functions used mainly in checks mainly for testing a file."""

import copy
import logging
import sys
from typing import TYPE_CHECKING

from lxml import etree

if TYPE_CHECKING:
    from collections.abc import Iterable
    from pathlib import Path

logger = logging.getLogger(__name__)


def compare_files(
    file1: Path,
    file2: Path,
    xpaths_to_ignore: Iterable[str] | None = None,
    _path: str = "",
) -> list[str]:
    """Compare two xml files, passes as paths."""
    try:
        parser = etree.XMLParser(remove_comments=True)
        t1, t2 = etree.parse(file1, parser), etree.parse(file2, parser)
    except etree.XMLSyntaxError as e:
        logger.critical("XML parse error: %s", e)
        sys.exit(1)

    return compare_elements(t1.getroot(), t2.getroot(), xpaths_to_ignore)


def _delete_by_xpaths(root: etree.Element, xpaths: Iterable[str]) -> None:
    """Remove every element/attribute that matches any of the xpaths."""
    for xpath in xpaths:
        # Distinguish attribute XPaths (ending with /@attr) from element XPaths
        if xpath.endswith(("/@*", "/@x")):  # attribute path
            parent_xpath = xpath.rsplit("/@", 1)[0] or "."  # default to root
            for parent in root.xpath(parent_xpath):
                if isinstance(parent, etree.Element):
                    attr = xpath.rsplit("/", 1)[1].lstrip("@")
                    if attr == "*":
                        parent.attrib.clear()
                    else:
                        parent.attrib.pop(attr, None)
        else:  # element path
            for el in root.xpath(xpath):
                if isinstance(el, etree.Element):
                    parent = el.getparent()
                    if parent is not None:
                        parent.remove(el)


def compare_elements(
    elem_input1: etree.Element,
    elem_input2: etree.Element,
    xpaths_to_ignore: Iterable[str] | None = None,
    _path: str = "",
) -> list[str]:
    """Recursively compare two XML elements.

    Returns a list of short, informative error strings.
    """
    if xpaths_to_ignore is None:
        xpaths_to_ignore = ()

    # make a copy to prevent modifying parent scope
    elem1 = copy.deepcopy(elem_input1)
    elem2 = copy.deepcopy(elem_input2)

    # Prune ignored parts
    _delete_by_xpaths(elem1, xpaths_to_ignore)
    _delete_by_xpaths(elem2, xpaths_to_ignore)

    errors: list[str] = []
    tag_path = f"{_path}/{elem1.tag}" if _path else elem1.tag

    # tag mismatch
    if elem1.tag != elem2.tag:
        errors.append(f"Tag mismatch at {tag_path}: {elem1.tag} ≠ {elem2.tag}")
        return errors  # if tags differ, stop descending

    # attribute deltas
    attributes_of_elem1 = dict(elem1.attrib.items())
    attributes_of_elem2 = dict(elem2.attrib.items())

    only_in_elem1 = sorted(set(attributes_of_elem1) - set(attributes_of_elem2))
    only_in_elem2 = sorted(set(attributes_of_elem2) - set(attributes_of_elem1))
    common = sorted(set(attributes_of_elem1) & set(attributes_of_elem2))

    if only_in_elem1 or only_in_elem2:
        errors.append(
            f"Attribute delta at <{elem1.tag}>"
            f"  only 1: {only_in_elem1}  only 2: {only_in_elem2}"
        )
    for key in common:
        if attributes_of_elem1[key] != attributes_of_elem2[key]:
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
            compare_elements(
                child1, child2, xpaths_to_ignore=(), _path=f"{tag_path}[{idx}]"
            )
        )

    # this should be stable from the sorts above, so no need to sort it here
    return errors
