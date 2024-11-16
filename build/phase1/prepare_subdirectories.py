import logging
import subprocess
from pathlib import Path

logger = logging.getLogger(__name__)


def prepare_subdirectories(languages: list[str]) -> None:
    """
    Find any makefiles in subdirectories and run them
    """
    logger.info("Preparing Subdirectories")
    for makefile in Path("").glob("?*.?*/**/Makefile"):
        subprocess.run(
            [
                "make",
                "--silent",
                f"--directory={makefile.parent}",
                f'languages="{" ".join(languages)}"',
            ]
        )
