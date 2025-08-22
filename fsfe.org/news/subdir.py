# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

import logging
import multiprocessing
from pathlib import Path
from textwrap import dedent

import lxml.etree as etree
from fsfe_website_build.lib.misc import lang_from_filename, update_if_changed

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
                {directory}/news-*:[]
                {directory}/.news-*:[]
                {directory.parent}/.localmenu:[]
            """
        ),
    )


def _gen_xml_files(working_dir: Path, file: Path):
    logger.debug(f"Transforming {file}")
    # Would be more efficient to pass this to the function,
    # but this causes a pickling error,
    # and  the faq seems to indicate passing around these objects
    # between threads causes issues
    # https://lxml.de/5.0/FAQ.html
    # So I guess we just have to take the performance hit.
    xslt_tree = etree.parse(working_dir.joinpath("xhtml2xml.xsl"))
    transform = etree.XSLT(xslt_tree)
    result = transform(
        etree.parse(file),
        link=f"'/news/{file.with_suffix('').with_suffix('.html').relative_to(file.parent.parent)}'",
    )
    update_if_changed(
        file.parent.joinpath(
            f".{file.with_suffix('').stem}{file.with_suffix('').suffix}.xml"
        ),
        str(result),
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
        pool.starmap(
            _gen_xml_files,
            [
                (working_dir, file)
                for file in filter(
                    lambda path: lang_from_filename(path) in languages
                    and etree.parse(path).xpath("//html[@newsdate]"),
                    working_dir.glob("*/*.??.xhtml"),
                )
            ],
        )
        logger.debug("Finished generating xml files")
