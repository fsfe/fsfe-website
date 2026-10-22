# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
#
"""Remove empty paragraphs from the passed files."""

import logging
from pathlib import Path

from lxml import etree

logger = logging.getLogger(__name__)

ALLOWED_EXTENSIONS = {".xhtml", ".xml"}


def fix(files: list[Path]) -> None:
    """Remove <p> elements with only whitespace content."""
    transform = etree.XSLT(etree.parse(Path(__file__).with_suffix(".xsl")))
    for file in files:
        try:
            result = transform(etree.parse(file))
        except etree.XMLSyntaxError, OSError:
            logger.warning("%s is not well-formed, skipping", file)
            continue
        result.write_output(file)
