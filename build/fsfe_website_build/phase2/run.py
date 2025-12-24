# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Script for FSFE website build, phase 2."""

import logging
from typing import TYPE_CHECKING

from .copy_files import copy_files
from .create_index_symlinks import create_index_symlinks
from .create_language_symlinks import create_language_symlinks
from .process_files import process_files

if TYPE_CHECKING:
    import multiprocessing.pool
    from pathlib import Path

    from fsfe_website_build.lib.build_config import GlobalBuildConfig, SiteBuildConfig
    from fsfe_website_build.lib.site_config import SiteConfig

logger = logging.getLogger(__name__)


def phase2_run(
    global_build_config: GlobalBuildConfig,
    site_build_config: SiteBuildConfig,
    site_config: SiteConfig,
    site_target: Path,
    pool: multiprocessing.pool.Pool,
) -> None:
    """Run all the necessary sub functions for phase2."""
    logger.info("Starting Phase 2 - Generating output")
    process_files(
        global_build_config.source,
        site_build_config.site,
        site_build_config.languages,
        pool,
        site_target,
    )
    create_index_symlinks(pool, site_target)
    create_language_symlinks(pool, site_target)
    copy_files(
        site_build_config.site,
        pool,
        site_target,
        site_config.deployment,
    )
