# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
#
"""Check that the passed files have one translator tag in correct place."""

import logging
from typing import TYPE_CHECKING

from lxml import etree

if TYPE_CHECKING:
    import multiprocessing.pool
    from pathlib import Path

logger = logging.getLogger(__name__)

CHECK_TYPE = "critical"
ALLOWED_EXTENSIONS = {".xhtml"}


def check(files: list[Path], pool: multiprocessing.pool.Pool) -> tuple[bool, str]:  # noqa: ARG001
    """Check for missing/misplaced translator tags."""
    invalid_files: list[str] = [
        f"{file} has missing/misplaced translator element"
        for file in files
        if (translators := etree.parse(file).xpath("//translator")) is None
        or len(translators) != 1
        or (list(etree.parse(file).getroot())[-1].tag != "translator")
    ]

    return len(invalid_files) == 0, "\n".join(invalid_files)
