# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
"""Prepare subdirectories before we choose languages to build each site in.

Will call the `run` function of any `early_subdir.py`
found in the website to build source tree.
"""

import logging
import sys
from pathlib import Path

logger = logging.getLogger(__name__)


def prepare_early_subdirectories(
    source: Path, source_dir: Path, processes: int
) -> None:
    """Find any early subdir scripts in subdirectories and run them."""
    logger.info("Preparing Early Subdirectories for site %s", source_dir)
    for subdir_path in (path.parent for path in source_dir.glob("**/early_subdir.py")):
        logger.info("Preparing early subdirectory %s", subdir_path)
        sys.path.append(str(subdir_path.resolve()))
        # Ignore this very sensible warning, as we do evil things
        # here for out subdir scripts
        import early_subdir  # noqa: PLC0415 # pyright: ignore [reportMissingImports]

        early_subdir.run(source, processes, subdir_path)
        # Remove its path from where things can be imported
        sys.path.remove(str(subdir_path.resolve()))
        # Remove it from loaded modules
        sys.modules.pop("early_subdir")
        # prevent us from accessing it again
        del early_subdir
