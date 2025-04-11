# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

import logging
import multiprocessing
from pathlib import Path

logger = logging.getLogger(__name__)


def _copy_file(target: Path, source_file: Path) -> None:
    target_file = target.joinpath(source_file)
    if (
        not target_file.exists()
        or source_file.stat().st_mtime > target_file.stat().st_mtime
    ):
        logger.debug(f"Copying {source_file} to {target_file}")
        target_file.parent.mkdir(parents=True, exist_ok=True)
        target_file.write_bytes(source_file.read_bytes())


def copy_files(pool: multiprocessing.Pool, target: Path) -> None:
    """
    Copy images, docments etc
    """
    logger.info("Copying over media and misc files")
    pool.starmap(
        _copy_file,
        map(
            lambda file: (target, file),
            list(
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
                    Path("").glob("*?.?*/**/*"),
                )
            )
            # Special case hard code pass over orde items xml required by cgi script
            + list(Path("").glob("*?.?*/order/data/items.en.xml")),
        ),
    )
