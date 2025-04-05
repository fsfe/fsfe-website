# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

import logging
import sys
from pathlib import Path

logger = logging.getLogger(__name__)


def prepare_subdirectories(languages: list[str], processes: int) -> None:
    """
    Find any makefiles in subdirectories and run them
    """
    logger.info("Preparing Subdirectories")
    for subdir_path in map(
        lambda path: path.parent, Path("").glob("?*.?*/**/subdir.py")
    ):
        logger.info(f"Preparing subdirectory {subdir_path}")
        sys.path.append(str(subdir_path.resolve()))
        import subdir

        subdir.run(languages, processes, subdir_path)
        # Remove its path from where things can be imported
        sys.path.remove(str(subdir_path.resolve()))
        # Remove it from loaded modules
        sys.modules.pop("subdir")
        # prevent us from accessing it again
        del subdir
