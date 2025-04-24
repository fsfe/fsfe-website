# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

import logging
import multiprocessing
from pathlib import Path
from textwrap import dedent

logger = logging.getLogger(__name__)


def _gen_archive_index(working_dir: Path, languages: list[str], dir: Path):
    logger.debug(f"Operating on dir {dir}")
    for lang in languages:
        logger.debug(f"Operating on lang {lang}")
        template = working_dir.joinpath(f"archive-template.{lang}.xhtml")
        if template.exists():
            logger.debug("Template Exists!")
            content = template.read_text()
            content = content.replace(":YYYY:", dir.name)
            dir.joinpath(f"index.{lang}.xhtml").write_text(content)


def _gen_index_sources(dir: Path):
    dir.joinpath("index.sources").write_text(
        dedent(
            f"""\
                {dir}/event-*:[]
                {dir}/.event-*:[]
                {dir.parent}/.localmenu:[]
            """
        )
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
            [(working_dir, languages, dir) for dir in years[:-2]],
        )
        logger.debug("Finished Archiving")
        # Generate index.sources for every year
        pool.map(_gen_index_sources, years)
        logger.debug("Finished generating sources")
