# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

import logging
import multiprocessing.pool
from pathlib import Path

from fsfe_website_build.lib.misc import (
    get_basepath,
    keys_exists,
    lang_from_filename,
    sort_dict,
    update_if_changed,
)
from lxml import etree

logger = logging.getLogger(__name__)


def _update_tag_pages(site: Path, tag: str, languages: list[str]) -> None:
    """
    Update the xhtml pages and xmllists for a given tag
    """
    for lang in languages:
        tagfile_source = site.joinpath(f"tags/tagged.{lang}.xhtml")
        if tagfile_source.exists():
            taggedfile = site.joinpath(f"tags/tagged-{tag}.{lang}.xhtml")
            content = tagfile_source.read_text().replace("XXX_TAGNAME_XXX", tag)
            update_if_changed(taggedfile, content)


def _update_tag_sets(
    site: Path,
    lang: str,
    filecount: dict[str, dict[str, int]],
    files_by_tag: dict[str, list[Path]],
    tags_by_lang: dict[str, dict[str, str]],
) -> None:
    """
    Update the .tags.??.xml tagset xmls for a given tag
    """
    # Add uout toplevel element
    page = etree.Element("tagset")

    # Add the subelements
    version = etree.SubElement(page, "version")
    version.text = "1"
    for section in ["news", "events"]:
        for tag in files_by_tag:
            count = filecount[section][tag]
            label = (
                tags_by_lang[lang][tag]
                if keys_exists(tags_by_lang, lang, tag)
                and tags_by_lang[lang][tag] is not None
                else tags_by_lang["en"][tag]
                if keys_exists(tags_by_lang, "en", tag)
                and tags_by_lang["en"][tag] is not None
                else tag
            )
            if count > 0:
                etree.SubElement(
                    page,
                    "tag",
                    section=section,
                    key=tag,
                    count=str(count),
                ).text = label
    update_if_changed(
        site.joinpath(f"tags/.tags.{lang}.xml"),
        etree.tostring(page, encoding="utf-8").decode("utf-8"),
    )


def run(languages: list[str], processes: int, working_dir: Path) -> None:
    """
    Update Tag pages, xmllists and xmls

     Creates/update the following files:

    * */tags/tagged-<tags>.en.xhtml for each tag used. Apart from being
      automatically created, these are regular source files for HTML pages, and
      in phase 2 are built into pages listing all news items and events for a
      tag.

    * */tags/.tags.??.xml with a list of the tags used.

    Changing or removing tags in XML files is also considered, in which case a
    file is removed from the .xmllist files.

    When a tag has been removed from the last XML file where it has been used,
    the tagged-* are correctly deleted.
    """
    with multiprocessing.Pool(processes) as pool:
        logger.debug("Updating tags for %s", working_dir)
        # Create a complete and current map of which tag is used in which files
        files_by_tag = {}
        tags_by_lang = {}
        # Fill out files_by_tag and tags_by_lang
        for file in filter(
            lambda file:
            # Not in tags dir of a source_dir
            working_dir not in file.parents,
            working_dir.parent.glob("**/*.xml"),
        ):
            for tag in etree.parse(file).xpath("//tag"):
                # Get the key attribute, and filter out some invalid chars
                key = (
                    tag.get("key")
                    .replace("/", "-")
                    .replace(" ", "-")
                    .replace(":", "-")
                    .strip()
                )
                # Get the label, and strip it.
                label = tag.text.strip() if tag.text and tag.text.strip() else None

                # Load into the dicts
                if key not in files_by_tag:
                    files_by_tag[key] = set()
                files_by_tag[key].add(get_basepath(file))
                lang = lang_from_filename(file)
                if lang not in tags_by_lang:
                    tags_by_lang[lang] = {}
                tags_by_lang[lang][key] = (
                    tags_by_lang[lang][key]
                    if key in tags_by_lang[lang] and tags_by_lang[lang][key]
                    else label
                )
        # Sort dicts to ensure that they are stable between runs
        files_by_tag = sort_dict(files_by_tag)
        for tag in files_by_tag:
            files_by_tag[tag] = sorted(files_by_tag[tag])
        tags_by_lang = sort_dict(tags_by_lang)
        for lang in tags_by_lang:
            tags_by_lang[lang] = sort_dict(tags_by_lang[lang])

        logger.debug("Updating tag pages")
        pool.starmap(
            _update_tag_pages,
            ((working_dir.parent, tag, languages) for tag in files_by_tag),
        )

        logger.debug("Updating tag lists")
        pool.starmap(
            update_if_changed,
            (
                (
                    Path(f"{working_dir}/.tagged-{tag}.xmllist"),
                    ("\n".join(str(file) for file in files_by_tag[tag]) + "\n"),
                )
                for tag in files_by_tag
            ),
        )

        logger.debug("Updating tag sets")
        # Get count of files with each tag in each section
        filecount = {}
        for section in ["news", "events"]:
            filecount[section] = {}
            for tag in files_by_tag:
                filecount[section][tag] = len(
                    list(
                        filter(
                            lambda path: section in str(path.parent),
                            files_by_tag[tag],
                        ),
                    ),
                )
        pool.starmap(
            _update_tag_sets,
            (
                (working_dir.parent, lang, filecount, files_by_tag, tags_by_lang)
                for lang in filter(lambda lang: lang in languages, tags_by_lang.keys())
            ),
        )
