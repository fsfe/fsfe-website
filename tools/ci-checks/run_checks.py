#!/usr/bin/env python3

# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
#
"""Runs a variety of checks."""

import argparse
import importlib.util
import logging
import multiprocessing
import multiprocessing.pool
import sys
from pathlib import Path
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from types import ModuleType

logger = logging.getLogger(__name__)


def load_check_modules(check_dir: Path) -> tuple[list[ModuleType], list[ModuleType]]:
    """Dynamically load all check modules from a directory."""
    # Ensure the check_dir is in sys.path so it's importable
    if str(check_dir) not in sys.path:
        sys.path.insert(0, str(check_dir))

    critical_modules: list[ModuleType] = []
    informational_modules: list[ModuleType] = []
    if not check_dir.exists() or not check_dir.is_dir():
        raise FileNotFoundError(f"Check directory not found: {check_dir}")

    for file in sorted(check_dir.iterdir()):
        if file.name.startswith("check_") and file.suffix == ".py":
            module_name = f"checks.{file.stem}"

            # Load module from file
            spec = importlib.util.spec_from_file_location(module_name, file)
            if spec is None or spec.loader is None:
                raise RuntimeError("Failed to load %s.", file)

            module = importlib.util.module_from_spec(spec)
            # Register it to prevent pickle issues
            sys.modules[module_name] = module
            spec.loader.exec_module(module)

            # Ensure it has the required function
            if (
                not hasattr(module, "check")
                or not hasattr(module, "ALLOWED_EXTENSIONS")
                or not hasattr(module, "CHECK_TYPE")
                or module.CHECK_TYPE not in ["critical", "informational"]
                or not callable(module.check)
            ):
                raise RuntimeError("%s. missing some required attr", file)
            if module.CHECK_TYPE == "critical":
                critical_modules.append(module)
            elif module.CHECK_TYPE == "informational":
                informational_modules.append(module)
            else:
                raise RuntimeError("%s CHECK_TYPE invalid", file)

    return critical_modules, informational_modules


def run_module_list(
    files: list[Path], modules: list[ModuleType], pool: multiprocessing.pool.Pool
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
        critical_modules, informational_modules = load_check_modules(
            Path("./tools/ci-checks/checks")
        )
    except Exception:
        logger.exception("Error loading check modules: %s")
        sys.exit(1)
    with multiprocessing.Pool(processes=args.jobs) as pool:
        # Run each check
        try:
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
            logger.exception("Check failed to run correctly: %s")
            sys.exit(1)


if __name__ == "__main__":
    main()
