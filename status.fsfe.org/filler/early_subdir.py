# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

import logging
import multiprocessing
from pathlib import Path

import lxml.etree as etree
from fsfe_website_build.lib.misc import (
    update_if_changed,
)

logger = logging.getLogger(__name__)


def _create_index(
    target_file: Path,
):
    # Create the root element
    page = etree.Element("html")

    # Add the subelements
    version = etree.SubElement(page, "version")
    version.text = "1"
    head = etree.SubElement(page, "head")
    title = etree.SubElement(head, "title")
    title.text = "filler"
    head = etree.SubElement(page, "body")

    result_str = etree.tostring(page, xml_declaration=True, encoding="utf-8").decode(
        "utf-8"
    )
    update_if_changed(target_file, result_str)


def run(processes: int, working_dir: Path) -> None:
    """
    Place filler indices to encourage the site to
    ensure that status pages for all langs are build.
    """

    with multiprocessing.Pool(processes) as pool:
        pool.map(
            _create_index,
            map(
                lambda path: (
                    working_dir.joinpath(
                        f"index.{path.name}.xhtml",
                    )
                ),
                Path().glob("global/languages/*"),
            ),
        )
