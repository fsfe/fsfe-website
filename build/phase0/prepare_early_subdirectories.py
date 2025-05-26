# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

import logging
import sys
from pathlib import Path

logger = logging.getLogger(__name__)


def prepare_early_subdirectories(source_dir: Path, processes: int) -> None:
    """
    Find any early subdir scripts in subdirectories and run them
    """
    logger.info("Preparing Early Subdirectories")
    for subdir_path in map(
        lambda path: path.parent, source_dir.glob("**/early_subdir.py")
    ):
        logger.info(f"Preparing early subdirectory {subdir_path}")
        sys.path.append(str(subdir_path.resolve()))
        import early_subdir

        early_subdir.run(processes, subdir_path)
        # Remove its path from where things can be imported
        sys.path.remove(str(subdir_path.resolve()))
        # Remove it from loaded modules
        sys.modules.pop("early_subdir")
        # prevent us from accessing it again
        del early_subdir
