# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
#
"""Check that the passed files do not use style elements."""

import logging
import textwrap
from typing import TYPE_CHECKING

from lxml import etree

if TYPE_CHECKING:
    import multiprocessing.pool
    from pathlib import Path

logger = logging.getLogger(__name__)

CHECK_TYPE = "informational"
ALLOWED_EXTENSIONS = {".xhtml", ".xml"}


def check(files: list[Path], pool: multiprocessing.pool.Pool) -> tuple[bool, str]:  # noqa: ARG001
    """Check for style elements."""
    failed_files: list[str] = [
        f"{file} contains a style element"
        for file in files
        if etree.parse(file).xpath("//*[@style]")
    ]

    return len(failed_files) == 0, (
        "\n".join(failed_files)
        + textwrap.dedent("""
              Please do not use style attributes to design an element. So instead of:

                <p style="color: red;">text</p>

              use CSS classes instead, or create them if necessary.

              More information why this is bad style, and what to do instead:
              https://docs.fsfe.org/en/techdocs/mainpage/editing/bestpractices#no-in-line-css""")
    )
