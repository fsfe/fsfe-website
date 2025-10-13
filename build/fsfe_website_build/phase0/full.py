# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

import logging
from pathlib import Path

from fsfe_website_build.lib.misc import run_command

logger = logging.getLogger(__name__)


def full(source: Path) -> None:
    """
    Git clean the repo to remove all cached artifacts
    Excluded the root .venv repo, as removing it mid build breaks the build, obviously
    """
    logger.info("Performing a full rebuild, git cleaning")
    run_command(
        [
            "git",
            "--git-dir",
            str(source) + "/.git",
            "clean",
            "-fdx",
            "--exclude",
            "/.venv",
            "--exclude",
            "/.nltk_data",
        ],
    )
