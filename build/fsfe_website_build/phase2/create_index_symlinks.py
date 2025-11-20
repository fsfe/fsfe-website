# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
"""Create index symlinks.

For directories with no existing index,
where there is a file with the same name as the parent folder,
EG about/about.en.html
generate a symlink from about/index.en.html to about.en.html
"""

import logging
from typing import TYPE_CHECKING

from fsfe_website_build.lib.misc import get_basename

if TYPE_CHECKING:
    import multiprocessing.pool
    from pathlib import Path

logger = logging.getLogger(__name__)


def _do_symlinking(target: Path) -> None:
    source = target.parent.joinpath(
        f"index{target.with_suffix('').suffix}{target.suffix}",
    )
    if not source.exists():
        source.symlink_to(target.relative_to(source.parent))


def create_index_symlinks(
    pool: multiprocessing.pool.Pool,
    target: Path,
) -> None:
    """Create index.* symlinks."""
    logger.info("Creating index symlinks")
    pool.map(
        _do_symlinking,
        filter(
            lambda path: get_basename(path) == path.parent.name,
            target.glob("**/*.??.html"),
        ),
    )
