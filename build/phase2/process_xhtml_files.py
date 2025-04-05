# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

import logging
import multiprocessing
from pathlib import Path

from build.lib.process_file import process_file

logger = logging.getLogger(__name__)


def _process_dir(languages: list[str], target: Path, dir: Path) -> None:
    for basename in set(map(lambda path: path.with_suffix(""), dir.glob("*.??.xhtml"))):
        for lang in languages:
            source_file = basename.with_suffix(f".{lang}.xhtml")
            target_file = target.joinpath(source_file).with_suffix(".html")
            processor = (
                basename.with_suffix(".xsl")
                if basename.with_suffix(".xsl").exists()
                else basename.parent.joinpath(".default.xsl")
            )
            if not target_file.exists() or any(
                # If any source file is newer than the file to be generated
                # If the file does not exist to
                map(
                    lambda file: (
                        file.exists()
                        and file.stat().st_mtime > target_file.stat().st_mtime
                    ),
                    [
                        (
                            source_file
                            if source_file.exists()
                            else basename.with_suffix(".en.xhtml")
                        ),
                        processor,
                        target_file.with_suffix("").with_suffix(".xmllist"),
                        Path(f"global/data/texts/.texts.{lang}.xml"),
                        Path(f"global/data/topbanner/.topbanner.{lang}.xml"),
                        Path("global/data/texts/texts.en.xml"),
                    ],
                )
            ):
                logger.debug(f"Building {target_file}")
                result = process_file(source_file, processor)
                target_file.parent.mkdir(parents=True, exist_ok=True)
                target_file.write_text(result)


def process_xhtml_files(
    languages: list[str], pool: multiprocessing.Pool, target: Path
) -> None:
    """
    Build .html files from .xhtml sources
    """
    # TODO
    # It should be possible to upgrade this and process_rss_ics files such that only one functions is needed
    # Also for performance it would be better to iterate by processor xls, and parse it only once and pass the xsl object to called function.
    logger.info("Processing xhtml files")

    pool.starmap(
        _process_dir,
        map(
            lambda dir: (languages, target, dir),
            set(map(lambda path: path.parent, Path("").glob("*?.?*/**/*.*.xhtml"))),
        ),
    )
