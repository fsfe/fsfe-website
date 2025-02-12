import logging

from build.lib.misc import run_command

logger = logging.getLogger(__name__)


def stage_to_target(stagedir: str, targets: str) -> None:
    """
    Git clean the repo to remove all cached artifacts
    Excluded the root .venv repo, as removing it mid build breaks the build, obviously
    """
    logger.info("Rsyncing from stage dir to target dir(s)")
    for target in targets.split(","):
        logger.debug(f"Rsyncing to {target}")
        run_command(
            [
                "rsync",
                "-av",
                "--copy-unsafe-links",
                "--del",
                str(stagedir) + "/",
                target,
            ]
        )
