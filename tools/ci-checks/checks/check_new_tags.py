# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
#
"""Check that the passed files do not add new tags."""

import logging
import re
import textwrap
from pathlib import Path
from typing import TYPE_CHECKING

from lxml import etree

if TYPE_CHECKING:
    import multiprocessing.pool

logger = logging.getLogger(__name__)

CHECK_TYPE = "informational"
ALLOWED_EXTENSIONS = {".xhtml", ".xml", "xsl"}


def check(files: list[Path], pool: multiprocessing.pool.Pool) -> tuple[bool, str]:  # noqa: ARG001
    """Check for newly added tags."""
    fileregex = re.compile(r"^fsfe.org/(news/|events/).*")

    new_tags: list[str] = []  # List of new tag messages

    # Get all relevant files in the news and events directories
    # For seeing if tags already exist
    base_dir = Path()
    relevant_files: list[Path] = []
    for pattern in [
        "fsfe.org/news/**/*.xhtml",
        "fsfe.org/news/**/*.xml",
        "fsfe.org/news/**/*.xsl",
        "fsfe.org/events/**/*.xhtml",
        "fsfe.org/events/**/*.xml",
        "fsfe.org/events/**/*.xsl",
    ]:
        relevant_files.extend(base_dir.glob(pattern))

    for file in files:
        if not fileregex.match(str(file)):
            continue
        # parse the current file
        tree = etree.parse(file)

        # iterate over tag keys
        for tag_key in tree.xpath("//tag/@key"):
            # Check if this tag exists in any other file
            found_in_other = False
            for other_file in relevant_files:
                # Ignore the file itself
                if other_file == file.relative_to(base_dir):
                    continue

                other_tree = etree.parse(
                    other_file,
                )
                # check if there are kays with the key in the other file
                other_tags = other_tree.xpath(f'//tag[@key="{tag_key}"]')
                if other_tags:
                    found_in_other = True

            if not found_in_other:
                new_tags.append(f"{file} adds new tag: {tag_key}")

    return len(new_tags) == 0, (
        "\n".join(new_tags)
        + textwrap.dedent("""
              Please make sure that you use already used tags, and only introduce a
              new tag e.g. if it's about a new campaign that will be more often
              mentioned in news or events. If you feel unsure, please ask
              <web@lists.fsfe.org>.

              Here you will find the currently used tags:
              https://fsfe.org/tags/tags.html

              Please make another commit to replace a new tag with an already
              existing one unless you are really sure. Thank you.""")
    )
