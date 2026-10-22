# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
#
"""Check that the passed files have the proper encoding."""

import logging
import textwrap
from typing import TYPE_CHECKING

from fsfe_website_hooks.fixes.convert_encoding import is_utf8

if TYPE_CHECKING:
    import multiprocessing.pool
    from pathlib import Path

logger = logging.getLogger(__name__)

ALLOWED_EXTENSIONS = {".xhtml", ".xml", ".xsl"}


def check(files: list[Path], pool: multiprocessing.pool.Pool) -> tuple[bool, str]:  # noqa: ARG001
    """Check correct encoding."""
    failed_files = [
        f"{file} is not UTF-8" for file in files if not is_utf8(file.read_bytes())
    ]
    return len(failed_files) == 0, (
        "\n".join(failed_files)
        + textwrap.dedent("""
                  For the FSFE website, we strongly prefer UTF-8 encoded files.
                  Everything else creates problems. Please change the file encoding in
                  your text editor or with a special tool.""")
    )
