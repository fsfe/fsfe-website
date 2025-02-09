import logging
import subprocess
import sys
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
    for dir in Path("").glob("?*.?*/look"):
        for name in ["fsfe", "valentine"]:
            if dir.joinpath(name + ".less").exists() and (
                not dir.joinpath(name + ".min.css").exists()
                or any(
                    [
                        path.stat().st_mtime
                        > dir.joinpath(name + ".min.css").stat().st_mtime
                        for path in dir.glob("**/*.less")
                    ]
                )
            ):
                logger.info(f"Compiling {name}.less")
                result = subprocess.run(
                    [
                        "lessc",
                        str(dir.joinpath(name + ".less")),
                    ],
                    capture_output=True,
                    # Get output as str instead of bytes
                    universal_newlines=True,
                )
                if result.returncode != 0:
                    logger.critical("Less compilation failed with error")
                    logger.critical(result.stderr)
                    sys.exit(1)
                update_if_changed(
                    dir.joinpath(name + ".min.css"),
                    minify.string("text/css", result.stdout),
                )
