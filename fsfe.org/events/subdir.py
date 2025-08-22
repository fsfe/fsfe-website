# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

import logging
import multiprocessing
from pathlib import Path
from textwrap import dedent

from fsfe_website_build.lib.misc import update_if_changed

logger = logging.getLogger(__name__)


def _gen_archive_index(working_dir: Path, languages: list[str], directory: Path):
    logger.debug(f"Operating on dir {directory}")
    for lang in languages:
        logger.debug(f"Operating on lang {lang}")
        template = working_dir.joinpath(f"archive-template.{lang}.xhtml")
        if template.exists():
            logger.debug("Template Exists!")
            content = template.read_text()
            content = content.replace(":YYYY:", directory.name)
            update_if_changed(directory.joinpath(f"index.{lang}.xhtml"), content)


def _gen_index_sources(directory: Path):
    update_if_changed(
        directory.joinpath("index.sources"),
        dedent(
            f"""\
                {directory}/event-*:[]
                {directory}/.event-*:[]
                {directory.parent}/.localmenu:[]
            """
        ),
    )


def run(languages: list[str], processes: int, working_dir: Path) -> None:
    """
    preparation for news subdirectory
    """
    with multiprocessing.Pool(processes) as pool:
        years = list(sorted(working_dir.glob("[0-9][0-9][0-9][0-9]")))
        # Copy news archive template to each of the years
        pool.starmap(
            _gen_archive_index,
            [(working_dir, languages, directory) for directory in years[:-2]],
        )
        logger.debug("Finished Archiving")
        # Generate index.sources for every year
        pool.map(_gen_index_sources, years)
        logger.debug("Finished generating sources")
