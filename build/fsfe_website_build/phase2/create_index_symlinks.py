# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

import logging
import multiprocessing
from pathlib import Path

from fsfe_website_build.lib.misc import get_basename

logger = logging.getLogger(__name__)


def _do_symlinking(target: Path) -> None:
    source = target.parent.joinpath(
        f"index{target.with_suffix('').suffix}{target.suffix}",
    )
    if not source.exists():
        source.symlink_to(target.relative_to(source.parent))


def create_index_symlinks(
    pool: multiprocessing.Pool,
    target: Path,
) -> None:
    """
    Create index.* symlinks
    """
    logger.info("Creating index symlinks")
    pool.map(
        _do_symlinking,
        filter(
            lambda path: get_basename(path) == path.parent.name,
            target.glob("**/*.??.html"),
        ),
    )
