# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
#
"""Convert the passed files to UTF-8, from the encoding they declare."""

import codecs
import logging
import re
from typing import TYPE_CHECKING

from fsfe_website_hooks.lib.misc import FixError, is_utf8

if TYPE_CHECKING:
    from pathlib import Path

logger = logging.getLogger(__name__)

ALLOWED_EXTENSIONS = {".xhtml", ".xml", ".xsl"}

DECLARED_ENCODING = re.compile(rb"""(<\?xml[^>]*?\sencoding\s*=\s*["'])([^"']+)""")


def _declared_encoding(content: bytes) -> str | None:
    if content.startswith((codecs.BOM_UTF16_LE, codecs.BOM_UTF16_BE)):
        return "utf-16"
    match = DECLARED_ENCODING.match(content)
    return match[2].decode("ascii", "replace") if match else None


def fix(files: list[Path]) -> None:
    """Re-encode files that are not UTF-8 and update their XML declaration."""
    for file in files:
        content = file.read_bytes()
        if is_utf8(content):
            continue
        # XML without a declaration is UTF-8.
        encoding = _declared_encoding(content) or "utf-8"
        try:
            text = content.decode(encoding)
        except (LookupError, UnicodeDecodeError) as error:
            message = (
                f"{file} is not in its declared encoding {encoding}, save it as UTF-8"
            )
            raise FixError(message) from error
        file.write_bytes(
            DECLARED_ENCODING.sub(rb"\1utf-8", text.encode("utf-8"), count=1)
        )
        logger.info("Converted %s from %s to utf-8", file, encoding)
