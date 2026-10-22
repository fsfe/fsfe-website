# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
#
"""Convert the passed files to UTF-8, from the encoding they declare."""

import codecs
import logging
import re
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from pathlib import Path

logger = logging.getLogger(__name__)

ALLOWED_EXTENSIONS = {".xhtml", ".xml", ".xsl"}

DECLARED_ENCODING = re.compile(rb"""(<\?xml[^>]*?\sencoding\s*=\s*["'])([^"']+)""")


def _is_utf8(content: bytes) -> bool:
    try:
        content.decode("utf-8")
    except UnicodeDecodeError:
        return False
    return True


def _declared_encoding(content: bytes) -> str | None:
    if content.startswith((codecs.BOM_UTF16_LE, codecs.BOM_UTF16_BE)):
        return "utf-16"
    match = DECLARED_ENCODING.match(content)
    return match[2].decode("ascii") if match else None


def fix(files: list[Path]) -> None:
    """Re-encode files that are not UTF-8 and update their XML declaration."""
    for file in files:
        content = file.read_bytes()
        if _is_utf8(content):
            continue
        encoding = _declared_encoding(content)
        if encoding is None:
            logger.warning("%s is not UTF-8 and declares no encoding", file)
            continue
        try:
            converted = content.decode(encoding).encode("utf-8")
        except LookupError, UnicodeDecodeError:
            logger.warning("%s does not match its declared encoding %s", file, encoding)
            continue
        file.write_bytes(DECLARED_ENCODING.sub(rb"\1utf-8", converted, count=1))
        logger.info("Converted %s from %s to utf-8", file, encoding)
