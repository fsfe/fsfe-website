# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

import logging
import multiprocessing
from pathlib import Path

from build.lib.misc import get_basepath
from build.lib.process_file import process_file

logger = logging.getLogger(__name__)


def _process_stylesheet(languages: list[str], target: Path, source_xsl: Path) -> None:
    base_file = get_basepath(source_xsl)
    destination_base = target.joinpath(base_file)
    for lang in languages:
        target_file = destination_base.with_suffix(
            f".{lang}{source_xsl.with_suffix('').suffix}"
        )
        source_xhtml = base_file.with_suffix(f".{lang}.xhtml")
        if not target_file.exists() or any(
            # If any source file is newer than the file to be generated
            map(
                lambda file: (
                    file.exists() and file.stat().st_mtime > target_file.stat().st_mtime
                ),
                [
                    (
                        source_xhtml
                        if source_xhtml.exists()
                        else base_file.with_suffix(".en.xhtml")
                    ),
                    source_xsl,
                    Path(f"global/data/texts/.texts.{lang}.xml"),
                    Path("global/data/texts/texts.en.xml"),
                ],
            )
        ):
            logger.debug(f"Building {target_file}")
            result = process_file(source_xhtml, source_xsl)
            target_file.parent.mkdir(parents=True, exist_ok=True)
            target_file.write_text(result)


def process_rss_ics_files(
    languages: list[str], pool: multiprocessing.Pool, target: Path
) -> None:
    """
    Build .rss files from .xhtml sources
    """
    logger.info("Processing rss files")
    pool.starmap(
        _process_stylesheet,
        map(
            lambda source_xsl: (languages, target, source_xsl),
            Path("").glob("*?.?*/**/*.rss.xsl"),
        ),
    )
    logger.info("Processing ics files")
    pool.starmap(
        _process_stylesheet,
        map(
            lambda source_xsl: (languages, target, source_xsl),
            Path("").glob("*?.?*/**/*.ics.xsl"),
        ),
    )
