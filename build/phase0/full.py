# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

import logging

from build.lib.misc import run_command

logger = logging.getLogger(__name__)


def full() -> None:
    """
    Git clean the repo to remove all cached artifacts
    Excluded the root .venv repo, as removing it mid build breaks the build, obviously
    """
    logger.info("Performing a full rebuild, git cleaning")
    run_command(
        ["git", "clean", "-fdx", "--exclude", "/.venv"],
    )
