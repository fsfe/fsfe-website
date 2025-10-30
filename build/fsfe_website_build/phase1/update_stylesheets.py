# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
"""Update XSL stylesheets.

This step updates (actually: just touches) all XSL files which depend on
another XSL file that has changed since the last build run. The phase 2
build process then only has to consider the directly used stylesheet as a
prerequisite for building each file and doesn't have to worry about other
stylesheets imported into that one.
This must run before the "prepare_subdirectories" step, because in the news
and events directories, the XSL files, if updated, will be copied for the
per-year archives.
"""

import logging
import multiprocessing.pool
import re
from pathlib import Path

from lxml import etree

from fsfe_website_build.lib.misc import touch_if_newer_dep

logger = logging.getLogger(__name__)


def _update_sheet(file: Path) -> None:
    """Update a given xsl file if any of its dependant xsl files have been updated."""
    xslt_root = etree.parse(file)
    imports = [
        file.parent.joinpath(imp.get("href")).resolve()
        for imp in xslt_root.xpath(
            "//xsl:import", namespaces={"xsl": "http://www.w3.org/1999/XSL/Transform"}
        )
    ]
    touch_if_newer_dep(file, imports)


def update_stylesheets(source_dir: Path, pool: multiprocessing.pool.Pool) -> None:
    """Touch all XSL files dependant on an XSL that has changed since last build."""
    logger.info("Updating XSL stylesheets")
    banned = re.compile(r"(\.venv/.*)|(.*\.default\.xsl$)")
    pool.map(
        _update_sheet,
        filter(
            lambda file: re.match(banned, str(file)) is None,
            source_dir.glob("**/*.xsl"),
        ),
    )
