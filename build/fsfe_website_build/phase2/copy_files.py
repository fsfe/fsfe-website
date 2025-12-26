# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
"""Copy source files to target directory.

Uses a multithreaded pathlib copy.
"""

import logging
import shutil
from typing import TYPE_CHECKING

from fsfe_website_build.lib.misc import run_command

if TYPE_CHECKING:
    import multiprocessing.pool
    import types
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
        shutil.copyfile(source_file, target_file)
        # preserve file modes
        shutil.copymode(source_file, target_file)


def _cli_copy_minify_file(target: Path, source_dir: Path, source_file: Path) -> None:
    target_file = target.joinpath(source_file.relative_to(source_dir))
    if (
        not target_file.exists()
        or source_file.stat().st_mtime > target_file.stat().st_mtime
    ):
        logger.debug("Copying minified %s to %s", source_file, target_file)
        target_file.parent.mkdir(parents=True, exist_ok=True)
        # Do not minify pre minified files
        if ".min" not in source_file.suffixes:
            run_command(["minify", str(source_file), "-o", str(target_file)])
        else:
            # Instead just copy them into place
            shutil.copyfile(source_file, target_file)
        # preserve file modes
        shutil.copymode(source_file, target_file)


def _module_copy_minify_file(
    target: Path,
    source_dir: Path,
    source_file: Path,
    mime: str,
    minify_module: types.ModuleType,
) -> None:
    target_file = target.joinpath(source_file.relative_to(source_dir))
    if (
        not target_file.exists()
        or source_file.stat().st_mtime > target_file.stat().st_mtime
    ):
        logger.debug("Copying minified %s to %s", source_file, target_file)
        target_file.parent.mkdir(parents=True, exist_ok=True)
        # Do not minify pre minified files
        if ".min" not in source_file.suffixes:
            minify_module.file(mime, str(source_file), str(target_file))
        else:
            # Instead just copy them into place
            shutil.copyfile(source_file, target_file)
        # preserve file modes
        shutil.copymode(source_file, target_file)


def copy_files(source_dir: Path, pool: multiprocessing.pool.Pool, target: Path) -> None:
    """Copy images, documents etc."""
    logger.info("Copying over media and misc files")
    # file extensions and mimes of minificable content
    # excluding files we should not be copying, like xml and html
    minifiable_content = {
        ".css": "text/css",
        ".js": "application/javascript",
        ".svg": "image/svg+xml",
    }
    # get the special cases per site
    special_case_file = source_dir / "required_deploy_files.txt"
    stripped_lines = (
        [line.strip() for line in special_case_file.read_text().split("\n")]
        if special_case_file.exists()
        else []
    )
    special_includes = [
        file
        for line in stripped_lines
        if line and not line.startswith("#")
        for file in source_dir.glob(line)
    ]

    # Here we copy everything we cannot minify
    pool.starmap(
        _copy_file,
        (
            (target, source_dir, file)
            for file in [
                # globbing of all files, exclude blacklist
                *[
                    path
                    for path in source_dir.glob("**/*")
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
                *special_includes,
            ]
        ),
    )
    # This has to be single threaded as their is an upstream bug that
    # prevents multihreading the minifier
    # https://github.com/tdewolff/minify/issues/535
    for file_suffix, mime in minifiable_content.items():
        files = [
            path for path in source_dir.glob(f"**/*{file_suffix}") if path.is_file()
        ]
        # Use cli based minify if possible
        if shutil.which("minify"):
            pool.starmap(
                _cli_copy_minify_file, ((target, source_dir, file) for file in files)
            )
        else:
            # fallback to python module
            # This has to be single threaded as there is an upstream bug that
            # prevents multihreading the minifier
            # https://github.com/tdewolff/minify/issues/535
            import minify  # pyright: ignore [reportMissingTypeStubs]  # noqa: PLC0415

            for file in files:
                _module_copy_minify_file(target, source_dir, file, mime, minify)
