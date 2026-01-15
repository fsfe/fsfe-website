#!/usr/bin/env python3

# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
#
"""Check that the passed files match xml structure across languages."""

import argparse
import logging
import multiprocessing
import sys
from collections import defaultdict
from pathlib import Path

from fsfe_website_build.lib.checks import (
    compare_files,
)
from fsfe_website_build.lib.misc import (
    get_basepath,
    get_version,
)

logger = logging.getLogger(__name__)


def _job(master: Path, other: Path, whitelist: set[str]) -> str | None:
    """Return a result string for starmap."""
    try:
        if get_version(master) != get_version(other):
            return None
        errs = compare_files(master, other, whitelist)
        return (
            f"There were differences between {master} and {other}:\n{'\n'.join(errs)}"
            if errs
            else None
        )
    except Exception as e:
        return f"Exception occurred comparing {master} and {other}: ERROR {e}"


def main() -> None:
    """Check that the passed files match xml structure across languages."""
    parser = argparse.ArgumentParser(
        description="Compare XML structure and attributes. "
        "Use --multi for space-separated list + parallel compares.",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    parser.add_argument("files", nargs="*", help="XML file(s)")
    parser.add_argument(
        "-w",
        "--whitelist",
        nargs="+",
        type=str,
        default=[
            "//discussion/@href",  # Mastodon links can be in different langs
            "/html/translator",  # the translator
            "//image/@alt",  # Image alt text for title image
            "//img/@alt",  # Image alt text
            "//input[@name='language']",  # Input language types
            "//profileimage/@alt",  # Profilemage alt text for about/people images
            "//track/@label",  # Language label, used in some track elements
            "//track/@srclang",  # Languages, used in some track elements
        ],
        help="XPATHS that we then ignore.",
    )
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

    groups: defaultdict[tuple[Path, str], list[Path]] = defaultdict(list)
    for file in args.files:
        path = Path(file).resolve()
        groups[(get_basepath(path), path.suffix)].append(path)

    tasks: list[tuple[Path, Path, set[str]]] = []
    for path_data, paths in groups.items():
        basepath, suffix = path_data
        if (master := basepath.parent / f"{basepath.name}.en{suffix}").exists():
            tasks.extend(
                (master, path, args.whitelist) for path in paths if path != master
            )
        else:
            logger.warning(
                "No english translation of %s with suffix %s exists - skipping",
                basepath,
                suffix,
            )

    with multiprocessing.Pool(processes=args.jobs) as pool:
        filtered_results = [
            result for result in pool.starmap(_job, tasks) if result is not None
        ]
        if filtered_results:
            for result in filtered_results:
                logger.info(result)
            logger.error("Some comparisons failed, exiting")
            sys.exit(1)

        logger.info("All comparisons succeeded, success")


if __name__ == "__main__":
    main()
