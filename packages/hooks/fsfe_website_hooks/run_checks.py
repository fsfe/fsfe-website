# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
#
"""Runs a variety of checks."""

import argparse
import logging
import multiprocessing
import multiprocessing.pool
import sys
from pathlib import Path
from typing import Protocol, runtime_checkable

from fsfe_website_hooks import checks
from fsfe_website_hooks.lib.misc import load_stages

logger = logging.getLogger(__name__)


@runtime_checkable
class Check(Protocol):
    """A check module, which only blocks a commit if critical."""

    ALLOWED_EXTENSIONS: set[str]
    CRITICAL: bool

    def check(
        self, files: list[Path], pool: multiprocessing.pool.Pool
    ) -> tuple[bool, str]:
        """Check the files, returning whether they passed and why not."""


def run_stage(
    files: list[Path], stage: list[Check], pool: multiprocessing.pool.Pool
) -> bool:
    """Run the checks of a stage, returning whether the critical ones passed."""
    critical_passed = True
    for check in stage:
        filtered_files = [
            file for file in files if file.suffix in check.ALLOWED_EXTENSIONS
        ]
        if not filtered_files:
            logger.debug("%s: no relevant files, skipping", check)
            continue
        logger.debug("%s: Running", check)
        success, message = check.check(filtered_files, pool)
        if success:
            logger.debug("Check Passed!")
        elif check.CRITICAL:
            logger.error(message)
            critical_passed = False
        else:
            logger.warning(message)
    return critical_passed


def main() -> None:
    """Check the passed files."""
    parser = argparse.ArgumentParser(
        description="Check passed files.",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    parser.add_argument("files", nargs="*", type=Path, help="Files to be checked")
    parser.add_argument(
        "--log-level",
        type=str,
        default="INFO",
        choices=["DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"],
        help="Set the logging level",
    )
    parser.add_argument(
        "-j",
        "--jobs",
        type=int,
        default=multiprocessing.cpu_count(),
        help="Parallel workers",
    )
    args = parser.parse_args()
    logging.basicConfig(
        format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S",
        level=args.log_level,
    )
    try:
        stages = load_stages(checks, Check)
    except Exception:
        logger.exception("Error loading check modules")
        sys.exit(1)
    with multiprocessing.Pool(processes=args.jobs) as pool:
        try:
            for stage in stages:
                if not run_stage(args.files, stage, pool):
                    logger.error(
                        "Some critical checks failed, check messages and fix errors!"
                    )
                    sys.exit(1)
            logger.info("All critical checks passed.")
        except Exception:
            logger.exception("Check failed to run correctly")
            sys.exit(1)


if __name__ == "__main__":
    main()
