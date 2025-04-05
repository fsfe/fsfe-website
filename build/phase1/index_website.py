# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# Build an index for the search engine based on the article titles and tags

import json
import logging
import multiprocessing
from pathlib import Path

import iso639
import lxml.etree as etree
import nltk
from nltk.corpus import stopwords as nltk_stopwords

from build.lib.misc import update_if_changed

logger = logging.getLogger(__name__)


def _find_teaser(document: etree.ElementTree) -> str:
    """
    Find a suitable teaser for indexation

    Get all the paragraphs in <body> and return the first which contains more
    than 10 words

    :document: The parsed lxml ElementTree document
    :returns: The text of the teaser or an empty string
    """
    for p in document.xpath("//body//p"):
        if p.text and len(p.text.strip().split(" ")) > 10:
            return p.text
    return ""


def _process_file(file: Path, stopwords: set[str]) -> dict:
    """
    Generate the search index entry for a given file and set of stopwords
    """
    logger.debug(f"Processing file {file}")
    xslt_root = etree.parse(file)
    tags = map(
        lambda tag: tag.get("key"),
        filter(lambda tag: tag.get("key") != "front-page", xslt_root.xpath("//tag")),
    )
    return {
        "url": f"/{file.with_suffix('.html')}",
        "tags": " ".join(tags),
        "title": (
            xslt_root.xpath("//html//title")[0].text
            if xslt_root.xpath("//html//title")
            else ""
        ),
        "teaser": " ".join(
            w
            for w in _find_teaser(xslt_root).strip().split(" ")
            if w.lower() not in stopwords
        ),
        "type": "news" if "news/" in str(file) else "page",
        # Get the date of the file if it has one
        "date": (
            xslt_root.xpath("//news[@newsdate]").get("newsdate")
            if xslt_root.xpath("//news[@newsdate]")
            else None
        ),
    }


def index_websites(languages: list[str], pool: multiprocessing.Pool) -> None:
    """
    Generate a search index for all sites that have a search/search.js file
    """
    logger.info("Creating search indexes")
    # Download all stopwords
    nltkdir = "./.nltk_data"
    nltk.data.path = [nltkdir] + nltk.data.path
    nltk.download("stopwords", download_dir=nltkdir, quiet=True)
    # Iterate over sites
    for site in filter(
        lambda path: path.joinpath("search/search.js").exists(),
        Path(".").glob("?*.??*"),
    ):
        logger.debug(f"Indexing {site}")

        # Get all xhtml files in languages to be processed
        # Create a list of tuples
        # The first element of each tuple is the file and the second is a set of stopwords for that language
        # Use iso639 to get the english name of the language from the two letter iso639-1 code we use to mark files.
        # Then if that language has stopwords from nltk, use those stopwords.
        files_with_stopwords = map(
            lambda file: (
                file,
                (
                    set(
                        nltk_stopwords.words(
                            iso639.Language.from_part1(
                                file.suffixes[0].removeprefix(".")
                            ).name.lower()
                        )
                    )
                    if iso639.Language.from_part1(
                        file.suffixes[0].removeprefix(".")
                    ).name.lower()
                    in nltk_stopwords.fileids()
                    else set()
                ),
            ),
            filter(
                lambda file: file.suffixes[0].removeprefix(".") in languages,
                Path(site).glob("**/*.??.xhtml"),
            ),
        )

        articles = pool.starmap(_process_file, files_with_stopwords)

        update_if_changed(
            Path(f"{site}/search/index.js"),
            "var pages = " + json.dumps(articles, ensure_ascii=False),
        )
