# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
#
"""Check that the passed files have the proper encoding."""

import logging
import textwrap
from typing import TYPE_CHECKING

from fsfe_website_build.lib.misc import run_command

if TYPE_CHECKING:
    import multiprocessing.pool
    from pathlib import Path

logger = logging.getLogger(__name__)

CHECK_TYPE = "critical"
ALLOWED_EXTENSIONS = {".xhtml", ".xml", "xsl"}


def check(files: list[Path], pool: multiprocessing.pool.Pool) -> tuple[bool, str]:  # noqa: ARG001
    """Check correct encoding."""
    failed_files: list[str] = []
    for file in files:
        encoding_result = run_command(["file", "-b", "--mime-encoding", str(file)])
        if encoding_result not in ["utf-8", "ascii", "us-ascii"]:
            failed_files.append(f"{file} has invalid encoding {encoding_result}")
    return len(failed_files) == 0, (
        "\n".join(failed_files)
        + textwrap.dedent("""
                  For the FSFE website, we strongly prefer UTF-8 encoded files.
                  Everything else creates problems. Please change the file encoding in
                  your text editor or with a special tool.""")
    )
