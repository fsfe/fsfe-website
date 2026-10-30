# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
#
"""Remove empty paragraphs from the passed files."""

from pathlib import Path

from lxml import etree

from fsfe_website_hooks.lib.misc import FixError

ALLOWED_EXTENSIONS = {".xhtml", ".xml"}


def fix(files: list[Path]) -> None:
    """Remove <p> elements with only whitespace content.

    Parses every file before writing any, so malformed XML changes nothing.
    """
    transform = etree.XSLT(etree.parse(Path(__file__).with_suffix(".xsl")))
    try:
        trees = [etree.parse(file) for file in files]
    except etree.XMLSyntaxError as error:
        message = f"{error.filename} is not well-formed XML: {error}"
        raise FixError(message) from error
    for file, tree in zip(files, trees, strict=True):
        transform(tree).write_output(file)
