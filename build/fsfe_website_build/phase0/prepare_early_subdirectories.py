# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
"""Prepare subdirectories before we choose languages to build each site in.

Will call the `run` function of any `early_subdir.py`
found in the website to build source tree.
"""

import logging
import sys
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from pathlib import Path

    from fsfe_website_build.lib.build_config import GlobalBuildConfig

logger = logging.getLogger(__name__)


def prepare_early_subdirectories(
    global_build_config: GlobalBuildConfig, source_site: Path
) -> None:
    """Find any early subdir scripts in subdirectories and run them."""
    logger.info("Preparing Early Subdirectories for site %s", source_site)
    for subdir_path in (path.parent for path in source_site.glob("**/early_subdir.py")):
        logger.info("Preparing early subdirectory %s", subdir_path)
        early_subdir_path_resolved = str(subdir_path.resolve())
        sys.path.append(early_subdir_path_resolved)
        # Ignore this very sensible warning, as we do evil things
        # here for out subdir scripts
        import early_subdir  # noqa: PLC0415 # type: ignore

        early_subdir.run(
            global_build_config.source, global_build_config.processes, subdir_path
        )
        # Remove its path from where things can be imported
        sys.path.remove(early_subdir_path_resolved)
        # Remove it from loaded modules
        sys.modules.pop("early_subdir")
        # prevent us from accessing it again
        del early_subdir
