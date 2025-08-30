# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

import logging
import multiprocessing.pool
from pathlib import Path

logger = logging.getLogger(__name__)


def _do_symlinking(target: Path) -> None:
    source = target.with_suffix("").with_suffix(f".html{target.with_suffix('').suffix}")
    if not source.exists():
        source.symlink_to(target.relative_to(source.parent))


def create_language_symlinks(
    pool: multiprocessing.pool.Pool,
    target: Path,
) -> None:
    """
    Create symlinks from file.<lang>.html to file.html.<lang>
    """
    logger.info("Creating language symlinks")
    pool.map(
        _do_symlinking,
        target.glob("**/*.??.html"),
    )
