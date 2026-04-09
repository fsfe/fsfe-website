# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
"""Copy source files to target directory.

Uses a multithreaded pathlib copy.
"""

import logging
import shutil
from typing import TYPE_CHECKING

import minify

if TYPE_CHECKING:
    import multiprocessing.pool
    from pathlib import Path

    from fsfe_website_build.lib.site_config import Deployment

logger = logging.getLogger(__name__)


def _copy_file(target: Path, source_site: Path, source_file: Path) -> None:
    target_file = target.joinpath(source_file.relative_to(source_site))
    if (
        not target_file.exists()
        or source_file.stat().st_mtime > target_file.stat().st_mtime
    ):
        logger.debug("Copying %s to %s", source_file, target_file)
        target_file.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(source_file, target_file)
        # preserve file modes
        shutil.copymode(source_file, target_file)


def _copy_minify_file(
    target: Path, source_site: Path, source_file: Path, mime: str
) -> None:
    target_file = target.joinpath(source_file.relative_to(source_site))
    if (
        not target_file.exists()
        or source_file.stat().st_mtime > target_file.stat().st_mtime
    ):
        logger.debug("Copying minified %s to %s", source_file, target_file)
        target_file.parent.mkdir(parents=True, exist_ok=True)
        # Do not minify pre minified files
        if ".min" not in source_file.suffixes:
            minify.file(mime, str(source_file), str(target_file))
        else:
            # Instead just copy them into place
            shutil.copyfile(source_file, target_file)
        # preserve file modes
        shutil.copymode(source_file, target_file)


def copy_files(
    source_site: Path,
    pool: multiprocessing.pool.Pool,
    target: Path,
    deploy_config: Deployment,
) -> None:
    """Copy images, documents etc."""
    logger.info("Copying over media and misc files")
    # file extensions and mimes of minificable content
    # excluding files we should not be copying, like xml and html
    minifiable_content = {
        ".css": "text/css",
        ".js": "application/javascript",
        ".svg": "image/svg+xml",
    }
    # Here we copy everything we cannot minify
    pool.starmap(
        _copy_file,
        (
            (target, source_site, file)
            for file in [
                # globbing of all files, exclude blacklist
                *[
                    path
                    for path in source_site.glob("**/*")
                    if path.is_file()
                    # Things we dont want over at all
                    and path.suffix
                    not in [
                        ".less",
                        ".md",
                        ".py",
                        ".pyc",
                        ".sources",
                        ".typed",
                        ".xhtml",
                        ".xml",
                        ".xmllist",
                        ".xsl",
                        ".yml",
                        # and the things we can minify
                        *minifiable_content.keys(),
                    ]
                    and path.name
                    not in [
                        ".gitignore",
                        "Makefile",
                        "subdir-prio.txt",
                    ]
                ],
                # special whitelist to include
                *[source_site / file for file in deploy_config.required_files],
            ]
        ),
    )
    # This has to be single threaded as their is an upstream bug that
    # prevents multihreading the minifier
    # https://github.com/tdewolff/minify/issues/535
    for file_suffix, mime in minifiable_content.items():
        for file in [
            path for path in source_site.glob(f"**/*{file_suffix}") if path.is_file()
        ]:
            _copy_minify_file(target, source_site, file, mime)
