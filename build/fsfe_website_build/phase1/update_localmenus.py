# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Update local menus.

After this step, all .localmenu.??.xml files will be up to date.
"""

import logging
from collections import defaultdict
from pathlib import Path
from typing import TYPE_CHECKING

from lxml import etree

from fsfe_website_build.lib.misc import (
    get_basepath,
    get_localised_file,
    update_if_changed,
)

if TYPE_CHECKING:
    import multiprocessing.pool

logger = logging.getLogger(__name__)


def _write_localmenus(
    source_site: Path,
    directory: Path,
    files: list[Path],
    languages: list[str],
) -> None:
    """Write localmenus for a given directory."""
    # Set of files with no langcode or xhtml extension
    base_files = {get_basepath(file) for file in files}
    for lang in languages:
        localmenu_file = directory.joinpath(f".localmenu.{lang}.xml")
        logger.debug("Creating %s", localmenu_file)
        page = etree.Element("feed")

        # Add the subelements
        etree.SubElement(page, "version").text = "1"

        for base_file in base_files:
            # source file to get localmenu data from
            source_file = get_localised_file(base_file, lang, ".xhtml")
            if source_file is None:
                logger.debug("No source for basefile %s", base_file)
                continue
            # the file we are linking to in the localmenu
            link_file = base_file.with_suffix(base_file.suffix + ".html")
            # now generate a localmenu entry for each localmenu entry in the source file
            for localmenu in etree.parse(source_file).xpath("//localmenu"):
                etree.SubElement(
                    page,
                    "localmenuitem",
                    set=localmenu.get("set", "default"),
                    id=localmenu.get("id", "default"),
                    link=(
                        "/"
                        + str(
                            link_file.relative_to(source_site),
                        )
                    ),
                ).text = localmenu.text

        update_if_changed(localmenu_file, etree.tostring(page, encoding="unicode"))


def update_localmenus(
    source: Path,
    source_site: Path,
    languages: list[str],
    pool: multiprocessing.pool.Pool,
) -> None:
    """Update all the .localmenu.*.xml files containing the local menus."""
    logger.info("Updating local menus")
    # Get a dict of all source files containing local menus
    files_by_dir: dict[Path, list[Path]] = defaultdict(list)
    for file in (
        file
        for file in source_site.glob("**/*.??.xhtml")
        if "-template" not in file.name
    ):
        xslt_root = etree.parse(file)
        for localmenu_elem in xslt_root.xpath("//localmenu"):
            directory = Path(
                localmenu_elem.get(
                    "dir", str(file.parent.resolve().relative_to(source.resolve()))
                )
            )
            files_by_dir[directory].append(file)

    # If any of the source files has been updated, rebuild all .localmenu.*.xml
    dirs = [
        (directory, files)
        for directory, files in files_by_dir.items()
        if any(
            [
                (
                    not (
                        localmenu_path := directory.joinpath(".localmenu.en.xml")
                    ).exists()
                )
                or (file.stat().st_mtime > localmenu_path.stat().st_mtime)
            ]
            for file in files
        )
    ]
    pool.starmap(
        _write_localmenus,
        ((source_site, directory, files, languages) for directory, files in dirs),
    )
