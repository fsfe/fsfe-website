# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
#
"""Check that the passed files do not have frontpage news in non english."""

import logging
import textwrap
from pathlib import Path
from typing import TYPE_CHECKING

from fsfe_website_build.lib.misc import (
    get_basepath,
)
from lxml import etree

if TYPE_CHECKING:
    import multiprocessing.pool

logger = logging.getLogger(__name__)

CHECK_TYPE = "critical"
ALLOWED_EXTENSIONS = {".xhtml", ".xml"}


def check(files: list[Path], pool: multiprocessing.pool.Pool) -> tuple[bool, str]:  # noqa: ARG001
    """Check for frontpage news."""
    failed_files: list[str] = [
        str(file)
        for file in files
        if etree.parse(file).xpath("//tag[@key='front-page']")
        and not (
            (file_path := Path(file)).parent
            / f"{get_basepath(file_path).name}.en{file_path.suffix}"
        ).exists()
    ]
    return len(failed_files) == 0, (
        "\n".join(failed_files)
        + textwrap.dedent("""
            The above files have no english version
            and are marked for the front page:""")
    )
