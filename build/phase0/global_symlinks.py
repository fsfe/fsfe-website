# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

import logging
import multiprocessing
from itertools import product
from pathlib import Path

logger = logging.getLogger(__name__)


def _do_symlinking(link_type: str, lang: str) -> None:
    """
    Helper function for global symlinking that is suitable for multithreading
    """
    target = (
        Path(f"global/data/{link_type}/{link_type}.{lang}.xml")
        if Path(f"global/data/{link_type}/{link_type}.{lang}.xml").exists()
        else Path(f"global/data/{link_type}/{link_type}.en.xml")
    )
    source = Path(f"global/data/{link_type}/.{link_type}.{lang}.xml")
    if not source.exists():
        source.symlink_to(target.relative_to(source.parent))


def global_symlinks(languages: list[str], pool: multiprocessing.Pool) -> None:
    """
    After this step, the following symlinks will exist:
    * global/data/texts/.texts.<lang>.xml for each language
    * global/data/topbanner/.topbanner.<lang>.xml for each language
    Each of these symlinks will point to the corresponding file without a dot at
    the beginning of the filename, if present, and to the English version
    otherwise. This symlinks make sure that phase 2 can easily use the right file
    for each language, also as a prerequisite in the Makefile.
    """
    logger.info("Creating global symlinks")
    link_types = ["texts", "topbanner"]
    pool.starmap(_do_symlinking, product(link_types, languages))
