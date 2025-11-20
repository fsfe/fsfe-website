# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
"""Load internal activities file if possible."""

import csv
import datetime
import logging
import operator
import os
from typing import TYPE_CHECKING
from urllib.parse import urlparse

import requests
from fsfe_website_build.lib.misc import update_if_changed
from lxml import etree

if TYPE_CHECKING:
    from pathlib import Path

logger = logging.getLogger(__name__)


def run(source: Path, languages: list[str], processes: int, working_dir: Path) -> None:  # noqa: ARG001 # We allow unused args for subdirs
    """Prepare internal subdirectory."""
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

    activities_csv = csv.reader(r.text.split("\n")[1:-1], delimiter="\t")
    activities = sorted(activities_csv, key=operator.itemgetter(0))

    page = etree.Element("data")
    # Add a version tag
    version = etree.SubElement(page, "version")
    version.text = "1"
    # add a module element to hold activities
    module = etree.SubElement(page, "module")

    for row in activities:
        if len(row) == 0:
            continue

        tag = row[0]
        description = row[1]
        event = row[2]

        try:
            enddate = datetime.datetime.strptime(row[5], "%Y-%m-%d")
        except ValueError:
            enddate = datetime.datetime.today() + datetime.timedelta(days=7)

        if datetime.datetime.today() > enddate:
            continue

        option = etree.SubElement(module, "option", value=f"{tag}||{description}")
        if event:
            option.attrib["data-event"] = event
        option.text = f"{tag} ({description})"

    update_if_changed(
        working_dir.joinpath("fsfe-activities-options.en.xml"),
        etree.tostring(page, encoding="utf-8").decode("utf-8"),
    )
