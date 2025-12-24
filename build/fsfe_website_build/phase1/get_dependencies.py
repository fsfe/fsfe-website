# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
"""Download the dependencies of a site, should it be necessary."""

import logging
import tomllib
from collections import defaultdict
from pathlib import Path

from fsfe_website_build.globals import CACHE_DIR
from fsfe_website_build.lib.misc import run_command

logger = logging.getLogger(__name__)


def fetch_sparse(
    cache: Path,
    repo: str,
    rev: str,
    file_mappings: list[dict[str, str]],
) -> None:
    """Clone source, and move necessary files into place with source/dest pairs."""
    clone_dir = cache / f"{Path(repo).name}_{rev}"

    if not (clone_dir / ".git").exists():
        clone_dir.mkdir(exist_ok=True)
        run_command(
            ["git", "-C", str(clone_dir), "init", "--quiet", "--no-initial-branch"]
        )
        run_command(["git", "-C", str(clone_dir), "remote", "add", "origin", repo])
        run_command(
            ["git", "-C", str(clone_dir), "config", "core.sparseCheckout", "true"]
        )
        # Extract all paths for sparse checkout
        paths = [mapping["source"] for mapping in file_mappings]
        sparse_checkout_path = clone_dir / ".git" / "info" / "sparse-checkout"
        # if path is ".", checkout the whole repo
        if any(path == "." for path in paths):
            sparse_checkout_path.write_text("/*\n")
        else:
            sparse_checkout_path.write_text("\n".join(paths) + "\n")

        # Fetch the required revision
        run_command(["git", "-C", str(clone_dir), "fetch", "--depth=1", "origin", rev])
        # Checkout the fetched revision
        run_command(["git", "-C", str(clone_dir), "checkout", "FETCH_HEAD"])
    # Copy each file to its destination
    for mapping in file_mappings:
        # create our source path
        # the source syntax is that of .gitignore, and so may have a leading /
        # to say to interpret it only relative to the root
        # and so we remove that so joining gives us a proper path
        src = clone_dir / mapping["source"].lstrip("/")
        dest_path = Path(mapping["dest"])
        dest_path.parent.mkdir(parents=True, exist_ok=True)

        run_command(
            [
                "rsync",
                "-avz",
                "--del",
                "--exclude=.git",
                str(src) if not src.is_dir() else str(src) + "/",
                str(dest_path),
            ]
        )


def get_dependencies(
    source_dir: Path,
) -> None:
    """Download and put in place all website dependencies."""
    logger.info("Getting Dependencies")
    cache = CACHE_DIR / "repos"
    cache.mkdir(parents=True, exist_ok=True)
    deps_file = source_dir / "dependencies.toml"
    if deps_file.exists():
        with deps_file.open("rb") as file:
            cfg = tomllib.load(file)

        # Group file mappings by repository and revision
        repo_tasks: defaultdict[tuple[str, str], list[dict[str, str]]] = defaultdict(
            list
        )

        for data in cfg.values():
            repo = str(data["repo"])
            rev = str(data["rev"])
            key = (repo, rev)

            for file_set in data["file_sets"]:
                # Make path relative to source dir
                dest = source_dir / file_set["target"]
                repo_tasks[key].append(
                    {"source": str(file_set["source"]), "dest": str(dest)}
                )

        # Process each repository/revision only once
        for (repo, rev), file_mappings in repo_tasks.items():
            fetch_sparse(cache, repo, rev, file_mappings)
