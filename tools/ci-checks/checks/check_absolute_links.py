# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
#
"""Check that the passed files do not use absolute links to fsfe.org."""

import logging
import re
import textwrap
from typing import TYPE_CHECKING

from lxml import etree

if TYPE_CHECKING:
    import multiprocessing.pool
    from pathlib import Path

logger = logging.getLogger(__name__)

CHECK_TYPE = "critical"
ALLOWED_EXTENSIONS = {".xhtml", ".xml"}


def check(files: list[Path], pool: multiprocessing.pool.Pool) -> tuple[bool, str]:  # noqa: ARG001
    """Check for absolute links."""
    absolute_regex = re.compile("https?://fsfe(urope)?.org")
    failed_files_links: list[str] = []
    for file in files:
        failed_files_links.extend(
            f"{file} has absolute link {href}"
            for href in etree.parse(file).xpath("//*/@href")
            if absolute_regex.match(href)
        )

    return len(failed_files_links) == 0, (
        "\n".join(failed_files_links)
        + textwrap.dedent("""
                  Please do not use links containing "https://fsfe.org". So instead of

                    <a href="https://fsfe.org/freesoftware/">link</a>

                  you should use:

                    <a href="/freesoftware">link</a>

                  More information about the why and how:
                  https://docs.fsfe.org/en/techdocs/mainpage/editing/bestpractices#no-absolute-links-to-fsfeorg""")
    )
