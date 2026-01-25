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
import sys
from pathlib import Path
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from types import ModuleType

logger = logging.getLogger(__name__)


def load_check_modules(check_dir: Path) -> list[ModuleType]:
    """Dynamically load all check modules from a directory."""
    # Ensure the check_dir is in sys.path so it's importable
    if str(check_dir) not in sys.path:
        sys.path.insert(0, str(check_dir))

    modules: list[ModuleType] = []
    if not check_dir.exists() or not check_dir.is_dir():
        raise FileNotFoundError(f"Check directory not found: {check_dir}")  # noqa: TRY003

    for file in sorted(check_dir.iterdir()):
        if file.name.startswith("check_") and file.suffix == ".py":
            module_name = f"checks.{file.stem}"

            # Load module from file
            spec = importlib.util.spec_from_file_location(module_name, file)
            if spec is None or spec.loader is None:
                raise RuntimeError("Failed to load %s.", file)  # noqa: TRY003

            module = importlib.util.module_from_spec(spec)
            # Register it to prevent pickle issues
            sys.modules[module_name] = module
            spec.loader.exec_module(module)

            # Ensure it has the required function
            if (
                not hasattr(module, "check")
                or not hasattr(module, "ALLOWED_EXTENSIONS")
                or not callable(module.check)
            ):
                raise RuntimeError("%s. missing check function", file)  # noqa: TRY003

            modules.append(module)

    return modules


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
        check_modules = load_check_modules(Path("./tools/ci-checks/checks"))
    except Exception:
        logger.exception("Error loading check modules: %s")
        sys.exit(1)
    all_checks_passed = True
    with multiprocessing.Pool(processes=args.jobs) as pool:
        # Run each check
        for module in check_modules:
            try:
                # Filter files by extension based on ALLOWED_EXTENSIONS
                filtered_files: list[Path] = [
                    file
                    for file in args.files
                    if file.suffix in module.ALLOWED_EXTENSIONS
                ]
                # Skip check if no relevant files
                if not filtered_files:
                    logger.info("No relevant files for %s, skipping", module)
                    continue
                logger.info("Running %s", module)
                success, message = module.check(filtered_files, pool)
                if not success:
                    logger.error(message)
                    all_checks_passed = False
                else:
                    logger.info("Check Passed!")

            except Exception:
                logger.exception("Check failed to run correctly: %s")
                sys.exit(1)
    if not all_checks_passed:
        logger.error("Some checks failed, check messages and fix errors!")
        sys.exit(1)
    else:
        logger.info("All checks passed.")
        sys.exit(0)


if __name__ == "__main__":
    main()
