# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Implementation of the full build logic."""

import logging
from typing import TYPE_CHECKING

from fsfe_website_build.lib.misc import run_command

if TYPE_CHECKING:
    from pathlib import Path

logger = logging.getLogger(__name__)


def full(source: Path) -> None:
    """Git clean the repo to remove all cached artifacts.

    Excluding the root .venv repo, as removing it mid build breaks the build, obviously.
    """
    logger.info("Performing a full rebuild, git cleaning")
    run_command(
        [
            "git",
            "--git-dir",
            str(source / ".git"),
            "clean",
            "-ffdx",
            "--exclude",
            "/.venv",
        ],
    )
