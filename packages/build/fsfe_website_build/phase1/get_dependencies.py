# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
"""Download the dependencies of a site, should it be necessary."""

import logging
from typing import TYPE_CHECKING

from fsfe_website_build.globals import CACHE_DIR
from fsfe_website_build.lib.misc import run_command

if TYPE_CHECKING:
    from pathlib import Path

    from fsfe_website_build.lib.site_config import Dependency

logger = logging.getLogger(__name__)


def fetch_sparse(cache: Path, source_site: Path, dependency: Dependency) -> None:
    """Clone source, and move necessary files into place with source/dest pairs."""
    clone_dir = cache / f"{dependency.repo.split('/')[-1]}_{dependency.rev}"

    if not (clone_dir / ".git").exists():
        clone_dir.mkdir(exist_ok=True)
        run_command(
            ["git", "-C", str(clone_dir), "init", "--quiet", "--no-initial-branch"]
        )
        run_command(
            ["git", "-C", str(clone_dir), "remote", "add", "origin", dependency.repo]
        )
        run_command(
            ["git", "-C", str(clone_dir), "config", "core.sparseCheckout", "true"]
        )
        # Extract all paths for sparse checkout
        paths = [str(mapping.source) for mapping in dependency.file_sets]
        sparse_checkout_path = clone_dir / ".git" / "info" / "sparse-checkout"
        # if path is ".", checkout the whole repo
        if any(path == "." for path in paths):
            sparse_checkout_path.write_text("/*\n")
        else:
            sparse_checkout_path.write_text("\n".join(paths) + "\n")

        # Fetch the required revision
        run_command(
            [
                "git",
                "-C",
                str(clone_dir),
                "fetch",
                "--depth=1",
                "origin",
                dependency.rev,
            ]
        )
        # Checkout the fetched revision
        run_command(["git", "-C", str(clone_dir), "checkout", "FETCH_HEAD"])
    # Copy each file to its destination
    for mapping in dependency.file_sets:
        # create our source path
        # the source syntax is that of .gitignore, and so may have a leading /
        # to say to interpret it only relative to the root
        # and so we remove that so joining gives us a proper path
        src = clone_dir / str(mapping.source).lstrip("/")
        target = source_site / mapping.target
        target.parent.mkdir(parents=True, exist_ok=True)

        run_command(
            [
                "rsync",
                "-avz",
                "--del",
                "--exclude=.git",
                str(src) if not src.is_dir() else str(src) + "/",
                str(target),
            ]
        )


def get_dependencies(source_site: Path, dependencies: list[Dependency]) -> None:
    """Download and put in place all website dependencies."""
    logger.info("Getting Dependencies")
    cache = CACHE_DIR / "repos"
    cache.mkdir(parents=True, exist_ok=True)
    for dependency in dependencies:
        fetch_sparse(cache, source_site, dependency)
