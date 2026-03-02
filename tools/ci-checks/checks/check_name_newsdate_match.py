# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
#
"""Check that the passed files have matching filenames and newsdates."""

import logging
import re
import textwrap
from typing import TYPE_CHECKING

from lxml import etree

if TYPE_CHECKING:
    import multiprocessing.pool
    from pathlib import Path

logger = logging.getLogger(__name__)

CHECK_TYPE = "critical"
ALLOWED_EXTENSIONS = {".xhtml", ".xml"}


def check(files: list[Path], pool: multiprocessing.pool.Pool) -> tuple[bool, str]:  # noqa: ARG001
    """Check for mismatched file names and newsdates."""
    fileregex = re.compile(
        r"^fsfe.org/(news/20[0-9]{2}/|news/nl/|news/podcast/20[0-9]{2}/|events/20[0-9]{2}/).*"
    )

    naming_regex = re.compile(
        ""
        r"^((nl-20[0-9]{4})|episode-(special-)?[0-9]{1,3}"
        r"|(news|event)-20[0-9]{6}-[0-9]{2})\.[a-z]{2}\.(xml|xhtml)$"
    )
    newsdate_regex = re.compile(r"^20[0-9]{2}-[0-9]{2}-[0-9]{2}$")

    failed_file_names: list[str] = []
    failed_file_newsdate: list[str] = []
    for file in [file for file in files if fileregex.match(str(file))]:
        # check filename
        if not naming_regex.match(file.name):
            failed_file_names.append(f"{file} is named incorrectly")
        # check file newsdate
        failed_file_newsdate.extend(
            f"{file} has invalid newsdate"
            for file in files
            if any(
                not newsdate_regex.match(newsdate)
                for newsdate in etree.parse(file).xpath("//html/@newsdate")
            )
        )
        # TODO: implement a way to compare date from name to date in newsdate
        # and ensure they are the same
        # Maybe use a date parser on different substrings in the name based on source?

    return (
        len(failed_file_names) == 0 and len(failed_file_newsdate) == 0,
        "\n".join(failed_file_names)
        + textwrap.dedent("""
              The scheme is:
                * "news-20YYMMDD-01.en.xhtml" for news
                * "nl-20YYMM.en.xhtml" for newsletters
                * "episode-N.en.xhtml" for podcast episodes
                * "event-20YYMMDD-01.en.xml" for events

              If there is more than one news item per date, count the "-01"
              onwards. Of course, the ".en" can also be the code for another
              language we support.
              """)
        + "\n".join(failed_file_newsdate)
        + textwrap.dedent("""
              The scheme is \"20YY-MM-DD\", so the respective line should look
              something like this: <html newsdate=\"2020-01-01\">"""),
    )
