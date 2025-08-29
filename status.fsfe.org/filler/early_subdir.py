# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

import logging
import multiprocessing
from pathlib import Path

from fsfe_website_build.lib.misc import (
    update_if_changed,
)
from lxml import etree

logger = logging.getLogger(__name__)


def run(processes: int, working_dir: Path) -> None:
    """
    Place filler indices to encourage the site to
    ensure that status pages for all langs are build.
    """
    # Create the root element
    page = etree.Element("html")

    # Add the subelements
    version = etree.SubElement(page, "version")
    version.text = "1"
    head = etree.SubElement(page, "head")
    title = etree.SubElement(head, "title")
    title.text = "filler"
    head = etree.SubElement(page, "body")

    index_content = etree.tostring(page, xml_declaration=True, encoding="utf-8").decode(
        "utf-8",
    )

    with multiprocessing.Pool(processes) as pool:
        pool.starmap(
            update_if_changed,
            (
                (
                    working_dir.joinpath(
                        f"index.{path.name}.xhtml",
                    ),
                    index_content,
                )
                for path in Path().glob("global/languages/*")
            ),
        )
