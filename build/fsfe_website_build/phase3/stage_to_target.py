# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
"""Use rsync to copy files to the targets."""

import logging
import multiprocessing.pool
from pathlib import Path

from fsfe_website_build.lib.misc import run_command

logger = logging.getLogger(__name__)


def _rsync(stagedir: Path, target: str, port: int) -> None:
    run_command(
        [
            "rsync",
            "-av",
            "--copy-unsafe-links",
            "--del",
            str(stagedir) + "/",
            target,
        ]
        # Use ssh with a command such that it does not worry about fingerprints,
        # as every connection is a new one basically
        # Also specify the sshport, and only load this sshconfig if required
        + (
            ["-e", f"ssh -o StrictHostKeyChecking=accept-new -p {port}"]
            if ":" in target
            else []
        ),
    )


def stage_to_target(
    stagedir: Path, targets: str, pool: multiprocessing.pool.Pool
) -> None:
    """Use a multithreaded rsync to copy the stage dir to all targets."""
    logger.info("Rsyncing from stage dir to target dir(s)")
    pool.starmap(
        _rsync,
        (
            (
                stagedir,
                (target if "?" not in target else target.split("?")[0]),
                (int(target.split("?")[1]) if "?" in target else 22),
            )
            for target in targets.split(",")
        ),
    )
