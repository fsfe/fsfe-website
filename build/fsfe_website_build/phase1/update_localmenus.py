# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

import logging
import multiprocessing.pool
from pathlib import Path

from lxml import etree

from fsfe_website_build.lib.misc import get_basepath, update_if_changed

logger = logging.getLogger(__name__)


def _write_localmenus(
    directory: str,
    files_by_dir: dict[str, list[Path]],
    languages: list[str],
) -> None:
    """
    Write localmenus for a given directory
    """
    # Set of files with no langcode or xhtml extension
    base_files = {get_basepath(filter_file) for filter_file in files_by_dir[directory]}
    for lang in languages:
        file = Path(directory).joinpath(f".localmenu.{lang}.xml")
        logger.debug("Creating %s", file)
        page = etree.Element("feed")

        # Add the subelements
        version = etree.SubElement(page, "version")
        version.text = "1"

        for source_file in [
            path
            for path in (
                base_file.with_suffix(f".{lang}.xhtml")
                if base_file.with_suffix(f".{lang}.xhtml").exists()
                else (
                    base_file.with_suffix(".en.xhtml")
                    if base_file.with_suffix(".en.xhtml").exists()
                    else None
                )
                for base_file in base_files
            )
            if path is not None
        ]:
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
                                source_file.parents[0],
                            ),
                        )
                    ),
                ).text = localmenu.text

        update_if_changed(
            file,
            etree.tostring(page, encoding="utf-8").decode("utf-8"),
        )


def update_localmenus(
    source: Path,
    source_dir: Path,
    languages: list[str],
    pool: multiprocessing.pool.Pool,
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
            directory = xslt_root.xpath("//localmenu/@dir")
            directory = (
                str(source.joinpath(directory[0]))
                if directory
                else str(file.parent.resolve())
            )
            if directory not in files_by_dir:
                files_by_dir[directory] = set()
            files_by_dir[directory].add(file)
    for directory, files in files_by_dir.items():
        files_by_dir[directory] = sorted(files)

    # If any of the source files has been updated, rebuild all .localmenu.*.xml
    dirs = filter(
        lambda directory: (
            any(
                (
                    (
                        (not Path(directory).joinpath(".localmenu.en.xml").exists())
                        or (
                            file.stat().st_mtime
                            > Path(directory)
                            .joinpath(".localmenu.en.xml")
                            .stat()
                            .st_mtime
                        )
                    )
                    for file in files_by_dir[directory]
                ),
            )
        ),
        files_by_dir,
    )
    pool.starmap(
        _write_localmenus,
        ((directory, files_by_dir, languages) for directory in dirs),
    )
