# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

import logging
import multiprocessing.pool
import re
from pathlib import Path

from lxml import etree

from fsfe_website_build.lib.misc import touch_if_newer_dep

logger = logging.getLogger(__name__)


def _update_sheet(file: Path) -> None:
    """
    Update a given xsl file if any of its dependant xsl files have been updated
    """
    xslt_root = etree.parse(file)
    imports = [
        file.parent.joinpath(imp.get("href")).resolve().relative_to(Path.cwd())
        for imp in xslt_root.xpath(
            "//xsl:import", namespaces={"xsl": "http://www.w3.org/1999/XSL/Transform"}
        )
    ]
    touch_if_newer_dep(file, imports)


def update_stylesheets(source_dir: Path, pool: multiprocessing.pool.Pool) -> None:
    """
    This script is called from the phase 1 Makefile and touches all XSL files
    which depend on another XSL file that has changed since the last build run.
    The phase 2 Makefile then only has to consider the
    directly used stylesheet as a prerequisite for building each file and doesn't
    have to worry about other stylesheets imported into that one.
    """
    logger.info("Updating XSL stylesheets")
    banned = re.compile(r"(\.venv/.*)|(.*\.default\.xsl$)")
    pool.map(
        _update_sheet,
        filter(
            lambda file: re.match(banned, str(file)) is None,
            source_dir.glob("**/*.xsl"),
        ),
    )
