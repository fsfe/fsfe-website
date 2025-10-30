# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
"""Global directory symlinking logic."""

import logging
import multiprocessing.pool
from itertools import product
from pathlib import Path

logger = logging.getLogger(__name__)


def _do_symlinking(source: Path, link_type: str, lang: str) -> None:
    """Link a specific file."""
    target = (
        source.joinpath(f"global/data/{link_type}/{link_type}.{lang}.xml")
        if source.joinpath(f"global/data/{link_type}/{link_type}.{lang}.xml").exists()
        else source.joinpath(f"global/data/{link_type}/{link_type}.en.xml")
    )
    source_xml = source.joinpath(f"global/data/{link_type}/.{link_type}.{lang}.xml")
    if not source_xml.exists():
        source_xml.symlink_to(target.relative_to(source_xml.parent))


def global_symlinks(
    source: Path, languages: list[str], pool: multiprocessing.pool.Pool
) -> None:
    """Do all the global symlinking.

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
    pool.starmap(_do_symlinking, product([source], link_types, languages))
