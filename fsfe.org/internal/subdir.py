# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

import csv
import logging
import os
import requests
from pathlib import Path
import lxml.etree as etree
from urllib.parse import urlparse

from build.lib.misc import update_if_changed

logger = logging.getLogger(__name__)


def run(languages: list[str], processes: int, working_dir: Path) -> None:
    """
    Internal subdir preparation
    """
    logger.info("Creating activities file")
    raw_url = urlparse(
        "https://git.fsfe.org/FSFE/activities/raw/branch/master/activities.csv"
    )
    git_token = os.environ.get("GIT_TOKEN")
    if git_token is None:
        logger.warn("GIT_TOKEN is not set, skipping generation of activities file")
        return

    url = raw_url._replace(query=f"token={git_token}").geturl()
    r = requests.get(url)

    if not r.ok:
        logger.error("Failed to retrieve activities file")
        raise Exception("Failed to retrieve activities file")

    activities_csv = csv.reader(r.text.split("\n")[1:], delimiter="\t")

    page = etree.Element("data")
    # Add a version tag
    version = etree.SubElement(page, "version")
    version.text = "1"
    # add a module element to hold activities
    module = etree.SubElement(page, "module")

    for row in activities_csv:
        if len(row) == 0:
            continue

        tag = row[0]
        description = row[1]
        event = row[2]

        option = etree.SubElement(module, "option", value=f"{tag}||{description}")
        if event:
            option.attrib["data-event"] = event
        option.text = f"{tag} ({description})"

    update_if_changed(
        working_dir.joinpath("fsfe-activities-options.en.xml"),
        etree.tostring(page, encoding="utf-8").decode("utf-8"),
    )
