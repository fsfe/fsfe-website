# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
#
"""Store data on translation priorities.

Used in po4a scripts and translation status page.
"""

import datetime

_CURRENT_YEAR = str(datetime.datetime.today().year)

PRIORITIES_AND_SEARCHES = {
    "1": [
        "**/fsfe.org/index.en.xhtml",
        "**/fsfe.org/freesoftware/freesoftware.en.xhtml",
    ],
    "2": ["**/fsfe.org/activities/*/activity.en.xml"],
    "3": [
        "**/fsfe.org/activities/*.en.xhtml",
        "**/fsfe.org/activities/*.en.xml",
        "**/fsfe.org/freesoftware/*.en.xhtml",
        "**/fsfe.org/freesoftware/*.en.xml",
    ],
    "4": [
        "**/fsfe.org/order/*.en.xml",
        "**/fsfe.org/order/*.en.xhtml",
        "**/fsfe.org/contribute/*.en.xml",
        "**/fsfe.org/contribute/*.en.xhtml",
    ],
    "5": ["**/fsfe.org/order/**/*.en.xml", "**/fsfe.org/order/**/*.en.xhtml"],
    "6": [
        f"**/fsfe.org/news/nl/nl-{_CURRENT_YEAR}*.en.xhtml",
        f"**/fsfe.org/news/nl/nl-{_CURRENT_YEAR}*.en.xml",
        f"**/fsfe.org/news/podcast/{_CURRENT_YEAR}/*.en.xhtml",
        f"**/fsfe.org/news/podcast/{_CURRENT_YEAR}/*.en.xml",
        f"**/fsfe.org/news/podcast/transcript/{_CURRENT_YEAR}/*.en.xhtml",
        f"**/fsfe.org/news/podcast/transcript/{_CURRENT_YEAR}/*.en.xml",
        f"**/fsfe.org/news/{_CURRENT_YEAR}/*.en.xhtml",
        "**/fsfe.org/news/*.en.xhtml",
        "**/fsfe.org/news/*.en.xml",
    ],
}
