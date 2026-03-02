# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
#
"""Check that the passed files have alt text for images."""

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
    """Check for images having alt text."""
    failed_files: list[str] = [
        f"{file} has an image without alt text"
        for file in files
        if (parsedFile := etree.parse(file)).xpath(
            "//img[not(@alt) or string-length(normalize-space(@alt))=0]"
        )
        or (
            parsedFile.xpath(
                "//image[not(@alt) or string-length(normalize-space(@alt))=0]"
            )
        )
    ]

    return len(failed_files) == 0, (
        "\n".join(failed_files)
        + textwrap.dedent("""
          This attribute is important if the image cannot be displayed, and for visually
          impaired people. You should describe the image so that it makes sense even if
          you cannot see it.

          More information on alternative text for images:
          https://docs.fsfe.org/en/techdocs/mainpage/editing/bestpractices#alternative-text-for-images""")
    )
