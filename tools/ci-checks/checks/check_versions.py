# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
#
"""Check that the passed files have one version and that it is an integer."""

import logging
from typing import TYPE_CHECKING

from lxml import etree

if TYPE_CHECKING:
    import multiprocessing.pool
    from pathlib import Path

logger = logging.getLogger(__name__)

CHECK_TYPE = "critical"
ALLOWED_EXTENSIONS = {".xhtml", ".xml"}


def check(files: list[Path], pool: multiprocessing.pool.Pool) -> tuple[bool, str]:  # noqa: ARG001
    """Check for missing/too many/non integer versions."""
    invalid_files: list[str] = [
        f"{file} has missing/too many/non integer version attribute"
        for file in files
        if (versions := etree.parse(file).xpath("/*/version")) is None
        or len(versions) != 1
        or not versions[0].text.isdigit()
    ]

    return len(invalid_files) == 0, "\n".join(invalid_files)
