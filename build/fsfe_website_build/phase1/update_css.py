# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Update CSS files.

This step recompiles the less files into the final CSS files to be
distributed to the web server.
"""

import logging
from typing import TYPE_CHECKING

import minify  # pyright: ignore [reportMissingTypeStubs]

from fsfe_website_build.lib.misc import run_command, update_if_changed

if TYPE_CHECKING:
    from pathlib import Path

logger = logging.getLogger(__name__)


def update_css(
    source_dir: Path,
) -> None:
    """If any less files have been changed, update the css.

    Compile less found at <website>/look/(main*less)
    Then minify it, and place it in the expected location for the build process.
    """
    logger.info("Updating css")
    directory = source_dir.joinpath("look")
    if directory.exists():
        for file in directory.glob("main*.less"):
            minified_path = file.with_suffix(".min.css")
            if not minified_path.exists() or any(
                (
                    path.stat().st_mtime > minified_path.stat().st_mtime
                    for path in directory.glob("**/*.less")
                ),
            ):
                logger.info("Compiling %s", file)
                result = run_command(
                    [
                        "lessc",
                        str(file),
                    ],
                )
                update_if_changed(
                    minified_path,
                    minify.string("text/css", result),
                )
