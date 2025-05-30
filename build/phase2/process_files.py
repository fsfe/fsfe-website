# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

import logging
import multiprocessing
from pathlib import Path

from build.lib.misc import get_basepath
from build.lib.process_file import process_file

logger = logging.getLogger(__name__)


def _run_process(
    target_file: Path, processor: Path, source_file: Path, basename: Path, lang: str
):
    # if the target file does not exist, we make it
    if not target_file.exists() or any(
        # If any source file is newer than the file to be generated
        # we recreate the generated file
        # if the source file does not exist, ignore it.
        map(
            lambda file: (
                file.exists() and file.stat().st_mtime > target_file.stat().st_mtime
            ),
            [
                (
                    source_file
                    if source_file.exists()
                    else basename.with_suffix(".en.xhtml")
                ),
                processor,
                (
                    source_file.parent.joinpath("." + basename.name).with_suffix(
                        ".xmllist"
                    )
                ),
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


def _process_dir(
    source_dir: Path, languages: list[str], target: Path, dir: Path
) -> None:
    for basename in set(map(lambda path: path.with_suffix(""), dir.glob("*.??.xhtml"))):
        for lang in languages:
            source_file = basename.with_suffix(f".{lang}.xhtml")
            target_file = target.joinpath(
                source_file.relative_to(source_dir)
            ).with_suffix(".html")
            processor = (
                basename.with_suffix(".xsl")
                if basename.with_suffix(".xsl").exists()
                else basename.parent.joinpath(".default.xsl")
            )
            _run_process(target_file, processor, source_file, basename, lang)


def _process_stylesheet(
    source_dir: Path, languages: list[str], target: Path, processor: Path
) -> None:
    basename = get_basepath(processor)
    destination_base = target.joinpath(basename.relative_to(source_dir))
    for lang in languages:
        target_file = destination_base.with_suffix(
            f".{lang}{processor.with_suffix('').suffix}"
        )
        source_file = basename.with_suffix(f".{lang}.xhtml")
        _run_process(target_file, processor, source_file, basename, lang)


def process_files(
    source_dir: Path, languages: list[str], pool: multiprocessing.Pool, target: Path
) -> None:
    """
    Build .html, .rss and .ics files from .xhtml sources

    """
    # TODO for performance it would be better to iterate by processor xls, and parse it only once and pass the xsl object to called function.
    logger.info("Processing xhtml files")
    pool.starmap(
        _process_dir,
        map(
            lambda dir: (source_dir, languages, target, dir),
            set(map(lambda path: path.parent, source_dir.glob("**/*.*.xhtml"))),
        ),
    )
    logger.info("Processing rss files")
    pool.starmap(
        _process_stylesheet,
        map(
            lambda processor: (source_dir, languages, target, processor),
            source_dir.glob("**/*.rss.xsl"),
        ),
    )
    logger.info("Processing ics files")
    pool.starmap(
        _process_stylesheet,
        map(
            lambda processor: (source_dir, languages, target, processor),
            source_dir.glob("**/*.ics.xsl"),
        ),
    )
