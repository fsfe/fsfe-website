# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
#
"""Check that the passed files do not have unobfustucated emails."""

import logging
import re
import textwrap
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    import multiprocessing.pool
    from pathlib import Path

logger = logging.getLogger(__name__)

CHECK_TYPE = "informational"
ALLOWED_EXTENSIONS = {".xhtml", ".xml", "xsl"}


def check(files: list[Path], pool: multiprocessing.pool.Pool) -> tuple[bool, str]:  # noqa: ARG001
    """Check for plaintext emails."""
    email_regex = re.compile(
        r"[A-Za-z-+]*@fsfe.org(?!<\/email)", re.IGNORECASE | re.MULTILINE
    )
    failed_files: list[str] = [
        f"{file} has plaintext email"
        for file in files
        if email_regex.search(file.read_text())
    ]
    return len(failed_files) == 0, (
        "\n".join(failed_files)
        + textwrap.dedent("""
          Plaintext email addresses are trivial to crawl for by bots:
          There is a simple solution: wrap the email address(es) in <email>...</email>.

          More information on obfuscated email addresses:
          https://fsfe.org/contribute/web/features.html#emails""")
    )
