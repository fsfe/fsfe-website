#!/usr/bin/env python3
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
    lang_from_filename,
)

logger = logging.getLogger(__name__)


def _job(master: Path, other: Path, whitelist: set[str]) -> str | None:
    """Return a one-line result string for starmap."""
    try:
        if get_version(master) != get_version(other):
            return None
        errs = compare_files(master, other, whitelist)
        return f"{other}: {'; '.join(errs)}" if errs else None
    except Exception as e:
        return f"{other}: ERROR {e}"


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Compare XML structure and attributes. "
        "Use --multi for space-separated list + parallel compares."
    )
    parser.add_argument("files", nargs="*", help="XML file(s)")
    parser.add_argument(
        "-w",
        "--whitelist",
        type=lambda attributes: set(attributes.split(",")),
        default={"alt"},
        help="Comma-separated list of attributes to ignore",
    )
    parser.add_argument(
        "--log-level",
        type=str,
        default="INFO",
        choices=["DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"],
        help="Set the logging level (default: INFO)",
    )
    parser.add_argument(
        "-j",
        "--jobs",
        type=int,
        default=multiprocessing.cpu_count(),
        help="Parallel workers (multi mode)",
    )
    args = parser.parse_args()
    logging.basicConfig(
        format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S",
        level=args.log_level,
    )

    groups: defaultdict[Path, list[Path]] = defaultdict(list)
    for file in args.files:
        path = Path(file).resolve()
        groups[get_basepath(path)].append(path)

    tasks: list[tuple[Path, Path, set[str]]] = []
    for basepath, paths in groups.items():
        master = next(
            (
                path
                for path in paths
                if len(path.suffixes) >= 2 and lang_from_filename(path) == "en"  # noqa: PLR2004
            ),
            None,
        )
        if not master:
            logger.warning("No english translation  of %s - skipped", basepath)
            continue
        tasks.extend((master, path, args.whitelist) for path in paths if path != master)

    with multiprocessing.Pool(processes=args.jobs) as pool:
        filtered_results = [
            result for result in pool.starmap(_job, tasks) if result is not None
        ]
        if filtered_results:
            for result in filtered_results:
                logger.info(result)
            logger.info("Some comparisons failed, exiting as error")
            sys.exit(1)
        else:
            logger.info("All comparisons succeeded, success")


if __name__ == "__main__":
    main()
