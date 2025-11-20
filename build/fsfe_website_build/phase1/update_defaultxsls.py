# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
"""Create XSL symlinks.

After this step, each directory with source files for HTML pages contains a
symlink named .default.xsl and pointing to the default.xsl "responsible" for
this directory. These symlinks make it easier for the phase 2 Makefile to
determine which XSL script should be used to build a HTML page from a source
file.
"""

import logging
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    import multiprocessing.pool
    from pathlib import Path

logger = logging.getLogger(__name__)


def _do_symlinking(directory: Path) -> None:
    """In each dir, place a .default.xsl symlink pointing to the nearest default.xsl."""
    working_dir = directory
    if not directory.joinpath(".default.xsl").exists():
        while not working_dir.joinpath("default.xsl").exists():
            working_dir = working_dir.parent
        directory.joinpath(".default.xsl").symlink_to(
            working_dir.joinpath("default.xsl").resolve(),
        )


def update_defaultxsls(source_dir: Path, pool: multiprocessing.pool.Pool) -> None:
    """Place a .default.xsl into each XHTML source directory.

    These .default.xsl are symlinks to the first
    available actual default.xsl found when climbing the directory tree
    upwards, it's the xsl stylesheet to be used for building the HTML
    files from this directory.
    """
    logger.info("Updating default xsl's")

    # Get a set of all directories containing .xhtml source files
    directories = {path.parent for path in source_dir.glob("**/*.*.xhtml")}

    # Do all directories asynchronously
    pool.map(_do_symlinking, directories)
