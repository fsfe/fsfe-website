import logging
import multiprocessing
from pathlib import Path

from build.lib.misc import run_command

logger = logging.getLogger(__name__)


def _rsync(stagedir: Path, target: str) -> None:
    run_command(
        [
            "rsync",
            "-av",
            "--copy-unsafe-links",
            "--del",
            # Use ssh with a command such that it does not worry about fingerprints, as every connection is a new one basically
            "-e",
            "ssh -o StrictHostKeyChecking=accept-new",
            str(stagedir) + "/",
            target,
        ]
    )


def stage_to_target(stagedir: Path, targets: str, pool: multiprocessing.Pool) -> None:
    """
    Git clean the repo to remove all cached artifacts
    Excluded the root .venv repo, as removing it mid build breaks the build, obviously
    """
    logger.info("Rsyncing from stage dir to target dir(s)")
    pool.starmap(_rsync, map(lambda target: (stagedir, target), targets.split(",")))
