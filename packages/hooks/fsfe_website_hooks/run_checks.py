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

from fsfe_website_hooks.checks import critical, informational
from fsfe_website_hooks.checks.critical import check_encoding
from fsfe_website_hooks.lib.misc import load_modules

logger = logging.getLogger(__name__)


@runtime_checkable
class Check(Protocol):
    """A check module."""

    ALLOWED_EXTENSIONS: set[str]

    def check(
        self, files: list[Path], pool: multiprocessing.pool.Pool
    ) -> tuple[bool, str]:
        """Check the files, returning whether they passed and why not."""


def run_module_list(
    files: list[Path], modules: list[Check], pool: multiprocessing.pool.Pool
) -> bool:
    """Run a list of modules on passed files, using passed pool."""
    all_passed = True
    for module in modules:
        # Filter files by extension based on ALLOWED_EXTENSIONS
        filtered_files: list[Path] = [
            file for file in files if file.suffix in module.ALLOWED_EXTENSIONS
        ]
        # Skip check if no relevant files
        if not filtered_files:
            logger.debug("%s: no relevant files, skipping", module)
            continue
        logger.debug("%s: Running", module)
        success, message = module.check(filtered_files, pool)
        if not success:
            logger.error(message)
            all_passed = False
        else:
            logger.debug("Check Passed!")
    return all_passed


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
        informational_modules = load_modules(informational, Check)
        critical_modules = load_modules(critical, Check)
        critical_modules.remove(check_encoding)
    except Exception:
        logger.exception("Error loading check modules")
        sys.exit(1)
    with multiprocessing.Pool(processes=args.jobs) as pool:
        # Run each check
        try:
            # Encoding first, as the other checks read the files as UTF-8.
            if not run_module_list(args.files, [check_encoding], pool):
                sys.exit(1)
            logger.info("Beginning Informational checks!")
            logger.info(
                "One may commit if these fail,"
                " but should consider fixing the issues raised!\n\n"
            )
            informational_checks_successful = run_module_list(
                args.files, informational_modules, pool
            )
            logger.info("Informational Checks finished!\n\n")
            logger.info("Beginning Critical checks!")
            logger.info("One must fix raised issues before being able to commit!\n\n")
            critical_checks_successful = run_module_list(
                args.files, critical_modules, pool
            )
            logger.info("Critical Checks finished!\n\n")
            if not informational_checks_successful:
                logger.warning(
                    "Some informational checks failed,"
                    " check messages and consider errors!"
                )
            else:
                logger.info("All informational checks passed.")

            if not critical_checks_successful:
                logger.error(
                    "Some critical checks failed, check messages and fix errors!"
                )
                sys.exit(1)
            else:
                logger.info("All critical checks passed.")
                sys.exit(0)

        except Exception:
            logger.exception("Check failed to run correctly")
            sys.exit(1)


if __name__ == "__main__":
    main()
