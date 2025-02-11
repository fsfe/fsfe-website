import logging
import subprocess
import sys

logger = logging.getLogger(__name__)


def stage_to_target(stagedir: str, targets: str) -> None:
    """
    Git clean the repo to remove all cached artifacts
    Excluded the root .venv repo, as removing it mid build breaks the build, obviously
    """
    logger.info("Rsyncing from stage dir to target dir(s)")
    for target in targets.split(","):
        logger.debug(f"Rsyncing to {target}")
        result = subprocess.run(
            [
                "rsync",
                "-av",
                "--copy-unsafe-links",
                "--del",
                str(stagedir) + "/",
                target,
            ],
            capture_output=True,
            universal_newlines=True,
        )
        if result.returncode != 0:
            logger.critical("Rsyncing failed with message:")
            logger.critical(result.stderr)
            sys.exit(1)
