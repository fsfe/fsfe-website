# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

import logging
import multiprocessing
from pathlib import Path

import lxml.etree as etree

from build.lib.misc import get_basepath, update_if_changed

logger = logging.getLogger(__name__)


def _write_localmenus(
    dir: str, files_by_dir: dict[str, list[Path]], languages: list[str]
) -> None:
    """
    Write localmenus for a given directory
    """
    # Set of files with no langcode or xhtml extension
    base_files = set(
        map(
            lambda filter_file: get_basepath(filter_file),
            files_by_dir[dir],
        )
    )
    for lang in languages:
        file = Path(dir).joinpath(f".localmenu.{lang}.xml")
        logger.debug(f"Creating {file}")
        page = etree.Element("feed")

        # Add the subelements
        version = etree.SubElement(page, "version")
        version.text = "1"

        for source_file in filter(
            lambda path: path is not None,
            map(
                lambda base_file: base_file.with_suffix(f".{lang}.xhtml")
                if base_file.with_suffix(f".{lang}.xhtml").exists()
                else (
                    base_file.with_suffix(".en.xhtml")
                    if base_file.with_suffix(".en.xhtml").exists()
                    else None
                ),
                base_files,
            ),
        ):
            for localmenu in etree.parse(source_file).xpath("//localmenu"):
                etree.SubElement(
                    page,
                    "localmenuitem",
                    set=(
                        str(localmenu.xpath("./@set")[0])
                        if localmenu.xpath("./@set") != []
                        else "default"
                    ),
                    id=(
                        str(localmenu.xpath("./@id")[0])
                        if localmenu.xpath("./@id") != []
                        else "default"
                    ),
                    link=(
                        str(
                            source_file.with_suffix(".html").relative_to(
                                source_file.parents[0]
                            )
                        )
                    ),
                ).text = localmenu.text

        update_if_changed(
            file,
            etree.tostring(page, encoding="utf-8").decode("utf-8"),
        )


def update_localmenus(
    source_dir: Path, languages: list[str], pool: multiprocessing.Pool
) -> None:
    """
    Update all the .localmenu.*.xml files containing the local menus.
    """
    logger.info("Updating local menus")
    # Get a dict of all source files containing local menus
    files_by_dir = {}
    for file in filter(
        lambda path: "-template" not in str(path),
        source_dir.glob("**/*.??.xhtml"),
    ):
        xslt_root = etree.parse(file)
        if xslt_root.xpath("//localmenu"):
            dir = xslt_root.xpath("//localmenu/@dir")
            dir = dir[0] if dir else str(file.parent.relative_to(Path(".")))
            if dir not in files_by_dir:
                files_by_dir[dir] = set()
            files_by_dir[dir].add(file)
    for dir in files_by_dir:
        files_by_dir[dir] = sorted(list(files_by_dir[dir]))

    # If any of the source files has been updated, rebuild all .localmenu.*.xml
    dirs = filter(
        lambda dir: (
            any(
                map(
                    lambda file: (
                        (not Path(dir).joinpath(".localmenu.en.xml").exists())
                        or (
                            file.stat().st_mtime
                            > Path(dir).joinpath(".localmenu.en.xml").stat().st_mtime
                        )
                    ),
                    files_by_dir[dir],
                )
            )
        ),
        files_by_dir,
    )
    pool.starmap(
        _write_localmenus, map(lambda dir: (dir, files_by_dir, languages), dirs)
    )
