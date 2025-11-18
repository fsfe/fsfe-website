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

from .prepare_subdirectories import prepare_subdirectories
from .update_css import update_css
from .update_defaultxsls import update_defaultxsls
from .update_localmenus import update_localmenus
from .update_stylesheets import update_stylesheets
from .update_xmllists import update_xmllists

if TYPE_CHECKING:
    import multiprocessing.pool
    from pathlib import Path

logger = logging.getLogger(__name__)


def phase1_run(
    source: Path,
    source_site: Path,
    languages: list[str],
    processes: int,
    pool: multiprocessing.pool.Pool,
) -> None:
    """Run all the necessary sub functions for phase1."""
    logger.info("Starting Phase 1 - Setup")
    update_css(source_site)
    update_stylesheets(source_site, pool)
    prepare_subdirectories(source, source_site, languages, processes)
    update_defaultxsls(source_site, pool)
    update_localmenus(source, source_site, languages, pool)
    update_xmllists(source, source_site, languages, pool)
