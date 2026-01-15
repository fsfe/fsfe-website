# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
"""script for FSFE website build, phase 1.

This script is executed in the root of the source directory tree, and
creates some .xml and xhtml files as well as some symlinks, all of which
serve as input files in phase 2. The whole phase 1 runs within the source
directory tree and does not touch the target directory tree at all.
"""

import logging
from typing import TYPE_CHECKING

from .get_dependencies import get_dependencies
from .prepare_subdirectories import prepare_subdirectories
from .update_css import update_css
from .update_defaultxsls import update_defaultxsls
from .update_localmenus import update_localmenus
from .update_stylesheets import update_stylesheets
from .update_xmllists import update_xmllists

if TYPE_CHECKING:
    import multiprocessing.pool

    from fsfe_website_build.lib.build_config import GlobalBuildConfig, SiteBuildConfig
    from fsfe_website_build.lib.site_config import SiteConfig

logger = logging.getLogger(__name__)


def phase1_run(
    global_build_config: GlobalBuildConfig,
    site_build_config: SiteBuildConfig,
    site_config: SiteConfig,
    pool: multiprocessing.pool.Pool,
) -> None:
    """Run all the necessary sub functions for phase1."""
    logger.info("Starting Phase 1 - Setup")
    get_dependencies(site_build_config.site, site_config.dependencies)
    update_css(site_build_config.site)
    update_stylesheets(site_build_config.site, pool)
    prepare_subdirectories(
        global_build_config.source,
        site_build_config.site,
        site_build_config.languages,
        global_build_config.processes,
    )
    update_defaultxsls(site_build_config.site, pool)
    update_localmenus(
        global_build_config.source,
        site_build_config.site,
        site_build_config.languages,
        pool,
    )
    update_xmllists(
        global_build_config.source,
        site_build_config.site,
        site_build_config.languages,
        pool,
    )
