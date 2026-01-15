# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
"""Create search index javascript file."""

import json
import logging
import multiprocessing
from typing import TYPE_CHECKING, TypedDict

import iso639
import nltk  # pyright: ignore[reportMissingTypeStubs]
from fsfe_website_build.globals import CACHE_DIR
from fsfe_website_build.lib.misc import lang_from_filename, update_if_changed
from lxml import etree
from nltk.corpus import (  # pyright: ignore[reportMissingTypeStubs]
    stopwords as nltk_stopwords,  # pyright: ignore[reportMissingTypeStubs]
)

if TYPE_CHECKING:
    from collections.abc import Generator
    from pathlib import Path
logger = logging.getLogger(__name__)


class _SearchIndexEntry(TypedDict):
    url: str
    tags: str
    title: str
    teaser: str
    type: str
    date: str | None


def _find_teaser(document: etree.ElementTree) -> str:
    """Find a suitable teaser for indexation.

    Get all the paragraphs in <body> and return the first which contains more
    than 10 words

    :document: The parsed lxml ElementTree document
    :returns: The text of the teaser or an empty string
    """
    trivial_length = 10
    for paragraph_text in (
        p.text.strip() for p in document.xpath("//body//p") if p.text
    ):
        if len(paragraph_text.split(" ")) > trivial_length:
            return paragraph_text
    return ""


def _process_file(file: Path, stopwords: set[str]) -> _SearchIndexEntry:
    """Generate the search index entry for a given file and set of stopwords."""
    xslt_root = etree.parse(file)
    tags = sorted(
        key
        for tag in xslt_root.xpath("//tag")
        if (key := str(tag.get("key"))) != "front-page"
    )
    return _SearchIndexEntry(
        url=f"/{file.with_suffix('.html').relative_to(file.parents[-2])}",
        tags=" ".join(tags),
        title=(
            titles[0].text.strip()
            if (titles := xslt_root.xpath("//html//title"))
            else ""
        ),
        teaser=" ".join(
            w for w in _find_teaser(xslt_root).split(" ") if w.lower() not in stopwords
        ),
        type="news" if "news/" in str(file) else "page",
        # Get the date of the file if it has one
        date=(newsdate if (newsdate := xslt_root.xpath("//news/@newsdate")) else None),
    )


def run(source: Path, languages: list[str], processes: int, working_dir: Path) -> None:  # noqa: ARG001
    """Create a search index.

    Indexes all files, including news and articles.
    It extracts titles, teaser, tags, dates and potentially more.
    The result will be fed into a JS file.
    """
    # Download all stopwords
    nltkdir = CACHE_DIR / "nltk_data"
    source_site = working_dir.parent
    nltk.data.path = [nltkdir]
    nltk.download("stopwords", download_dir=nltkdir, quiet=True)  # pyright: ignore [(reportUnknownMemberType)]
    with multiprocessing.Pool(processes) as pool:
        logger.debug("Indexing %s", source_site)

        # Get all xhtml files in languages to be processed
        # Create a list of tuples
        # The first element of each tuple is the file and
        # the second is a set of stopwords for that language
        # Use iso639 to get the english name of the language
        # from the two letter iso639-1 code we use to mark files.
        # Then if that language has stopwords from nltk, use those stopwords.
        files_with_stopwords: Generator[tuple[Path, set[str]]] = (
            (
                file,
                (
                    set(
                        nltk_stopwords.words(  # pyright: ignore [(reportUnknownMemberType)]
                            lang_full,
                        ),
                    )
                    if (
                        lang_full := (
                            iso639.Language.from_part1(
                                lang_from_filename(file)
                            ).name.lower()
                        )
                    )
                    in nltk_stopwords.fileids()  # pyright: ignore [(reportUnknownMemberType)]
                    else set()
                ),
            )
            for file in source_site.glob("**/*.??.xhtml")
            if file.suffixes[0].removeprefix(".") in languages
        )

        articles = sorted(
            pool.starmap(_process_file, files_with_stopwords),
            key=lambda article: tuple(article.values()),
        )

        update_if_changed(
            working_dir.joinpath("index.json"),
            json.dumps(articles, ensure_ascii=False),
        )
