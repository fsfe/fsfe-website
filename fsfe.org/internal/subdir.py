# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

import csv
import logging
import os
from pathlib import Path
from urllib.parse import urlparse

import requests
from fsfe_website_build.lib.misc import update_if_changed
from lxml import etree

logger = logging.getLogger(__name__)


def run(languages: list[str], processes: int, working_dir: Path) -> None:  # noqa: ARG001 # We allow unused args for subdirs
    """
    Internal subdir preparation
    """
    logger.info("Creating activities file")
    raw_url = urlparse(
        "https://git.fsfe.org/FSFE/activities/raw/branch/master/activities.csv",
    )
    git_token = os.environ.get("FSFE_WEBSITE_GIT_TOKEN")
    if git_token is None:
        logger.warning(
            "FSFE_WEBSITE_GIT_TOKEN is not set, skipping generation of activities file",
        )
        return

    url = raw_url._replace(query=f"token={git_token}").geturl()
    r = requests.get(url)

    if not r.ok:
        message = "Failed to retrieve activities file"
        logger.error(message)
        raise RuntimeError(message)

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
