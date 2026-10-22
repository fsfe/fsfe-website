# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
#
"""Remove empty paragraphs from the passed files."""

from pathlib import Path

from lxml import etree

ALLOWED_EXTENSIONS = {".xhtml", ".xml"}


def fix(files: list[Path]) -> None:
    """Remove <p> elements with only whitespace content."""
    transform = etree.XSLT(etree.parse(Path(__file__).with_suffix(".xsl")))
    for file in files:
        transform(etree.parse(file)).write_output(file)
