# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

import csv
import logging
import os
import requests
from pathlib import Path
from urllib.parse import urlparse

logger = logging.getLogger(__name__)

raw_url = urlparse(
    "https://git.fsfe.org/FSFE/activities/raw/branch/master/activities.csv"
)


def create_activities_file():
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
    activities = ""

    for row in activities_csv:
        if len(row) == 0:
            continue

        tag = row[0]
        description = row[1]
        event = row[2]

        activities += f'    <option value="{tag}||{description}"'
        if event:
            activities += f' data-event="{event}"'

        activities += ">"
        activities += f"{tag} ({description})"
        activities += "</option>\n"

    content = f"""<?xml version="1.0" encoding="UTF-8"?>

<data>
    <version>1</version>

    <module>
    {activities}
    </module>
</data>"""

    activities_path = Path("global/data/modules/fsfe-activities-options.en.xml")
    with open(activities_path, "w") as f:
        f.write(content)

    logger.info(f"Wrote activity file to {str(activities_path)}")
