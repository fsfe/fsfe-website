# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

import logging
import multiprocessing.pool
from pathlib import Path

from lxml import etree

from fsfe_website_build.lib.misc import get_basepath
from fsfe_website_build.lib.process_file import process_file

logger = logging.getLogger(__name__)


def _run_process(
    target_file: Path,
    processor_tuple: tuple[Path, etree.XSLT],
    source_file: Path,
    basepath: Path,
    lang: str,
) -> None:
    # if the target file does not exist, we make it
    if not target_file.exists() or any(
        # If any source file is newer than the file to be generated
        # we recreate the generated file
        # if the source file does not exist, ignore it.
        (
            (file.exists() and file.stat().st_mtime > target_file.stat().st_mtime)
            for file in [
                (
                    source_file
                    if source_file.exists()
                    else Path(str(basepath) + ".en.xhtml")
                ),
                processor_tuple[0],
                (
                    source_file.parent.joinpath("." + basepath.name).with_suffix(
                        ".xmllist",
                    )
                ),
                Path(f"global/data/texts/.texts.{lang}.xml"),
                Path(f"global/data/topbanner/.topbanner.{lang}.xml"),
                Path("global/data/texts/texts.en.xml"),
            ]
        ),
    ):
        logger.debug("Building %s", target_file)
        result = process_file(source_file, processor_tuple[1])
        target_file.parent.mkdir(parents=True, exist_ok=True)
        result.write_output(target_file)


def _process_set(
    source_dir: Path,
    languages: list[str],
    target: Path,
    processor: Path,
    files: set[Path],
) -> None:
    # generate the transform func
    # doing it here should mean that we use only one per thread,
    # and also process each one only once
    # Max memory and performance efficacy
    parser = etree.XMLParser(remove_blank_text=True, remove_comments=True)
    xslt_tree = etree.parse(processor.resolve(), parser)
    transform = etree.XSLT(xslt_tree)
    for basepath in files:
        for lang in languages:
            source_file = Path(str(basepath) + f".{lang}.xhtml")
            target_suffix = (
                ".html" if (len(processor.suffixes) == 1) else processor.suffixes[0]
            )
            target_file = target.joinpath(
                source_file.relative_to(source_dir),
            ).with_suffix(target_suffix)
            _run_process(
                target_file, (processor, transform), source_file, basepath, lang
            )


def process_files(
    source_dir: Path,
    languages: list[str],
    pool: multiprocessing.pool.Pool,
    target: Path,
) -> None:
    """
    Build .html, .rss and .ics files from .xhtml sources

    """
    logger.info("Processing xhtml, rss, ics files")
    # generate a set of unique processing xsls
    xsl_files = {
        processor.resolve().relative_to(source_dir.parent.resolve())
        for processor in source_dir.glob("**/*.xsl")
    }

    process_files_dict = {}
    for processor in xsl_files:
        process_files_dict[processor] = set()

    # This gathers all the simple xhtml files for generating xhtml output
    for file in source_dir.glob("**/*.*.xhtml"):
        specific_processor = (
            file.with_suffix("")
            .with_suffix(".xsl")
            .resolve()
            .relative_to(source_dir.parent.resolve())
        )
        default_processor = (
            file.parent.joinpath(".default.xsl")
            .resolve()
            .relative_to(source_dir.parent.resolve())
        )
        used_processor = (
            specific_processor if specific_processor.exists() else default_processor
        )
        basepath = get_basepath(file)
        process_files_dict[used_processor].add(basepath)

    # And now for processors with additional suffixes we (eg events.rss.xsl)
    # we add the basename
    # this is for the generation of rss and ics files mainly,
    # but is extensible by design
    for processor, files in process_files_dict.items():
        if len(processor.suffixes) > 1:
            files.add(get_basepath(processor))

    pool.starmap(
        _process_set,
        (
            (source_dir, languages, target, processor, files)
            for processor, files in process_files_dict.items()
        ),
    )
