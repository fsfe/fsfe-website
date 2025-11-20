# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
"""Copy source files to target directory.

Uses a multithreaded pathlib copy.
"""

import logging
import shutil
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    import multiprocessing.pool
    from pathlib import Path

logger = logging.getLogger(__name__)


def _copy_file(target: Path, source_dir: Path, source_file: Path) -> None:
    target_file = target.joinpath(source_file.relative_to(source_dir))
    if (
        not target_file.exists()
        or source_file.stat().st_mtime > target_file.stat().st_mtime
    ):
        logger.debug("Copying %s to %s", source_file, target_file)
        target_file.parent.mkdir(parents=True, exist_ok=True)
        target_file.write_bytes(source_file.read_bytes())
        # preserve file modes
        shutil.copymode(source_file, target_file)


def copy_files(source_dir: Path, pool: multiprocessing.pool.Pool, target: Path) -> None:
    """Copy images, documents etc."""
    logger.info("Copying over media and misc files")
    pool.starmap(
        _copy_file,
        (
            (target, source_dir, file)
            for file in list(
                filter(
                    lambda path: path.is_file()
                    and path.suffix
                    not in [
                        ".md",
                        ".yml",
                        ".gitignore",
                        ".sources",
                        ".xmllist",
                        ".xhtml",
                        ".xsl",
                        ".xml",
                        ".less",
                        ".py",
                        ".pyc",
                    ]
                    and path.name not in ["Makefile"],
                    source_dir.glob("**/*"),
                ),
            )
            # Special case hard code pass over orde items xml required by cgi script
            + list(source_dir.glob("order/data/items.en.xml"))
        ),
    )
