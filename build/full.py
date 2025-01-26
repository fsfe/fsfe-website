import logging
import subprocess
import sys

logger = logging.getLogger(__name__)


def full() -> None:
    """
    Git clean the repo to remove all cached artifacts
    Excluded the root .venv repo, as removing it mid build breaks the build, obviously
    """
    logger.info("Performing a full rebuild")
    result = subprocess.run(
        ["git", "clean", "-fdx", "--exclude", "/.venv"],
        capture_output=True,
        universal_newlines=True,
    )
    if result.returncode != 0:
        logger.critical("git clean failed with message:")
        logger.critical(result.stderr)
        sys.exit(1)
