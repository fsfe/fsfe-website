# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# -----------------------------------------------------------------------------
# script for FSFE website build, phase 2
# -----------------------------------------------------------------------------
import logging
import multiprocessing
from pathlib import Path

from .copy_files import copy_files
from .create_index_symlinks import create_index_symlinks
from .create_language_symlinks import create_language_symlinks
from .process_files import process_files

logger = logging.getLogger(__name__)


def phase2_run(languages: list[str], pool: multiprocessing.Pool, target: Path):
    """
    Run all the necessary sub functions for phase2.
    """
    logger.info("Starting Phase 2 - Generating output")
    process_files(languages, pool, target)
    create_index_symlinks(pool, target)
    create_language_symlinks(pool, target)
    copy_files(pool, target)
