# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Prepare subdirectories, knowing what languages we have already.

Will call the `run` function of any `subdir.py`
found in the website to build source tree.
"""

import logging
import sys
from pathlib import Path

logger = logging.getLogger(__name__)


def prepare_subdirectories(
    source: Path,
    source_dir: Path,
    languages: list[str],
    processes: int,
) -> None:
    """Find any subdir scripts in subdirectories and run them."""
    logger.info("Preparing Subdirectories")
    for subdir_path in sorted(
        (path.parent for path in source_dir.glob("**/subdir.py")),
        key=lambda directory: directory.joinpath("subdir-prio.txt").read_text().strip()
        if directory.joinpath("subdir-prio.txt").exists()
        else "0",
    ):
        logger.info("Preparing subdirectory %s", subdir_path)
        sys.path.append(str(subdir_path.resolve()))
        # Ignore this very sensible warning, as we do evil things
        # here for out subdir scripts
        import subdir  # noqa: PLC0415 # pyright: ignore [reportMissingImports]

        subdir.run(source, languages, processes, subdir_path)  # pyright: ignore [reportUnknownMemberType]
        # Remove its path from where things can be imported
        sys.path.remove(str(subdir_path.resolve()))
        # Remove it from loaded modules
        sys.modules.pop("subdir")
        # prevent us from accessing it again
        del subdir
