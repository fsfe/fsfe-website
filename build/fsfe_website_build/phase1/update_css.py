# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

import logging
from pathlib import Path

import minify

from fsfe_website_build.lib.misc import run_command, update_if_changed

logger = logging.getLogger(__name__)


def update_css(
    source_dir: Path,
) -> None:
    """
    If any less files have been changed, update the css.
    Compile less found at website/look/(fsfe.less|valentine.less)
    Then minify it, and place it in the expected location for the build process.
    """
    logger.info("Updating css")
    directory = source_dir.joinpath("look")
    if directory.exists():
        for name in ["fsfe", "valentine"]:
            if directory.joinpath(name + ".less").exists() and (
                not directory.joinpath(name + ".min.css").exists()
                or any(
                    map(
                        lambda path: path.stat().st_mtime
                        > directory.joinpath(name + ".min.css").stat().st_mtime,
                        directory.glob("**/*.less"),
                    )
                )
            ):
                logger.info(f"Compiling {name}.less")
                result = run_command(
                    [
                        "lessc",
                        str(directory.joinpath(name + ".less")),
                    ],
                )
                update_if_changed(
                    directory.joinpath(name + ".min.css"),
                    minify.string("text/css", result),
                )
