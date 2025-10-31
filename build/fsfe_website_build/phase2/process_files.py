# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Build the lists and pairs file processing.

Takes care to iterate by processor file,
which is useful to prevent reparsing the XSL multiple times.
"""

import logging
import multiprocessing.pool
from collections import defaultdict
from itertools import product
from pathlib import Path

from lxml import etree

from fsfe_website_build.lib.misc import get_basepath
from fsfe_website_build.lib.process_file import process_file

logger = logging.getLogger(__name__)


def _process_set(  # noqa: PLR0913
    source: Path,
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
    for basepath, lang in product(files, languages):
        source_file = Path(str(basepath) + f".{lang}.xhtml")
        target_suffix = (
            ".html" if (len(processor.suffixes) == 1) else processor.suffixes[0]
        )
        target_file = target.joinpath(
            source_file.relative_to(source_dir),
        ).with_suffix(target_suffix)
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
                    processor,
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
            result = process_file(source, source_file, transform)
            target_file.parent.mkdir(parents=True, exist_ok=True)
            result.write_output(target_file)


def process_files(
    source: Path,
    source_dir: Path,
    languages: list[str],
    pool: multiprocessing.pool.Pool,
    target: Path,
) -> None:
    """Build .html, .rss and .ics files from .xhtml sources."""
    logger.info("Processing xhtml, rss, ics files")

    process_files_dict: dict[Path, set[Path]] = defaultdict(set)

    # This gathers all the simple xhtml files for generating xhtml output
    for file in source_dir.glob("**/*.*.xhtml"):
        # Processors with a file ending for the output encoded in the name, eg
        # events.rss.xsl
        type_specific_processors = set(
            file.parent.glob(f"{get_basepath(file).name}.*.xsl")
        )
        # The form that a named processor for a file would be
        # Essentially, if there is no output name, we default to html
        # <basename>.html.xsl should be equal in effect to <basename>.xsl
        xhtml_named_processor = (
            file.with_suffix("")
            .with_suffix(".xsl")
            .resolve()
            .relative_to(source.resolve())
        )
        # if that does not exist, default to
        xhtml_default_processor = (
            file.parent.joinpath(".default.xsl").resolve().relative_to(source.resolve())
        )
        xhtml_processor = (
            xhtml_named_processor
            if xhtml_named_processor.exists()
            else xhtml_default_processor
        )
        # And add the files/processors we should be using for every file
        for processor in type_specific_processors | {xhtml_processor}:
            # If we are using a type specific processor, there will be more suffixes
            file_to_add = processor if len(processor.suffixes) > 1 else file
            process_files_dict[processor].add(get_basepath(file_to_add))

    pool.starmap(
        _process_set,
        (
            (source, source_dir, languages, target, processor, files)
            for processor, files in process_files_dict.items()
        ),
    )
