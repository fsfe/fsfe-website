import logging
import subprocess
from pathlib import Path

import minify

from build.lib import update_if_changed

logger = logging.getLogger(__name__)


def update_css() -> None:
    """
    If any less files have been changed, update the css.
    Compile less found at website/look/(fsfe.less|valentine.less)
    Then minify it, and place it in the expected location for the build process.
    """
    logger.info("Updating css")
    for folder in Path("").glob("?*.?*/look"):
        for name in ["fsfe", "valentine"]:
            if folder.joinpath(name + ".less").exists() and (
                not folder.joinpath(name + ".min.css").exists()
                or any(
                    [
                        path.stat().st_mtime
                        > folder.joinpath(name + ".min.css").stat().st_mtime
                        for path in folder.glob("**/*.less")
                    ]
                )
            ):
                logger.info(f"Compiling {name}.less")
                result = subprocess.run(
                    [
                        "lessc",
                        str(folder.joinpath(name + ".less")),
                    ],
                    capture_output=True,
                    # Get output as str instead of bytes
                    universal_newlines=True,
                )
                update_if_changed(
                    folder.joinpath(name + ".min.css"),
                    minify.string("text/css", result.stdout),
                )
