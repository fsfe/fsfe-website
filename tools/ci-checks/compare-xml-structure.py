#!/usr/bin/env python3
import argparse
import logging
import multiprocessing
import sys
from collections import defaultdict
from pathlib import Path

from fsfe_website_build.lib.misc import (
    get_basepath,
    get_version,
    lang_from_filename,
)
from lxml import etree

logger = logging.getLogger(__name__)


def compare_elements(
    elem1: etree.Element,
    elem2: etree.Element,
    attr_whitelist: set[str] | None = None,
    _path: str = "",
) -> list[str]:
    """
    Recursively compare two XML elements.
    Returns a list of short, informative error strings.
    """
    if attr_whitelist is None:
        attr_whitelist = set()

    errors: list[str] = []
    tag_path = f"{_path}/{elem1.tag}" if _path else elem1.tag

    # tag mismatch
    if elem1.tag != elem2.tag:
        errors.append(f"Tag mismatch at {tag_path}: {elem1.tag} ≠ {elem2.tag}")
        return errors  # if tags differ, stop descending

    # attribute deltas
    attributes_of_elem1 = dict(elem1.attrib.items())
    attributes_of_elem2 = dict(elem2.attrib.items())

    only_in_elem1 = set(attributes_of_elem1) - set(attributes_of_elem2)
    only_in_elem2 = set(attributes_of_elem2) - set(attributes_of_elem1)
    common = set(attributes_of_elem1) & set(attributes_of_elem2)

    if only_in_elem1 or only_in_elem2:
        errors.append(
            f"Attribute delta at <{elem1.tag}>"
            f"  only 1: {list(only_in_elem1)}  only 2: {list(only_in_elem2)}"
        )
    for key in common:
        if (
            attributes_of_elem1[key] != attributes_of_elem2[key]
            and key not in attr_whitelist
        ):
            error_msg = (
                f"Attribute value diff at <{elem1.tag} {key}>:"
                f" {attributes_of_elem1[key]!r} ≠ {attributes_of_elem2[key]!r}"
            )
            errors.append(error_msg)

    # child count
    kids1 = list(elem1)
    kids2 = list(elem2)
    if len(kids1) != len(kids2):
        errors.append(f"Child count at <{elem1.tag}>: {len(kids1)} ≠ {len(kids2)}")
        return errors  # if counts differ, stop descending

    # and then recurse into children
    for idx, (child1, child2) in enumerate(zip(kids1, kids2, strict=False), start=1):
        errors.extend(
            compare_elements(child1, child2, attr_whitelist, _path=f"{tag_path}[{idx}]")
        )

    return errors


def _job(master: Path, other: Path, whitelist: set[str]) -> str | None:
    """Return a one-line result string for starmap."""
    try:
        if get_version(master) != get_version(other):
            return f"{other}: version differs → OK"
        tree1, tree2 = etree.parse(master), etree.parse(other)
        errs = compare_elements(tree1.getroot(), tree2.getroot(), whitelist)
        return f"{other}: {'; '.join(errs)}" if errs else None
    except Exception as e:
        return f"{other}: ERROR {e}"


def compare_two_files(file1: Path, file2: Path, whitelist: set[str]) -> None:
    """
    Compares the xml structure of two files.
    Exits early if they have different versions
    """
    try:
        version_1, version_2 = get_version(file1), get_version(file2)
    except ValueError as e:
        logger.critical("Version check failed: %s", e)
        sys.exit(2)
    if version_1 != version_2:
        logger.info("Files are different versions, considering comparison okay")
        return

    try:
        t1, t2 = etree.parse(file1), etree.parse(file2)
    except etree.XMLSyntaxError as e:
        logger.critical("XML parse error: %s", e)
        sys.exit(1)

    errors = compare_elements(t1.getroot(), t2.getroot(), whitelist)
    if errors:
        logger.warning("Differences found:\n%s", "\n".join(errors))
        sys.exit(1)
    else:
        logger.info("XML files match in structure and attributes.")


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
        filtered_results = (
            result for result in pool.starmap(_job, tasks) if result is not None
        )
        if filtered_results:
            for result in filtered_results:
                logger.info(result)
            logger.info("Some comparisons failed, exiting as error")
            sys.exit(1)
        else:
            logger.info("All comparisons succeeded, success")


if __name__ == "__main__":
    main()
