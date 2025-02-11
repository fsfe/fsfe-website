import logging
import multiprocessing
import textwrap
from pathlib import Path
from xml.sax.saxutils import escape

import lxml.etree as etree

from build.lib.misc import (
    delete_file,
    get_basepath,
    keys_exists,
    lang_from_filename,
    sort_dict,
    update_if_changed,
)

logger = logging.getLogger(__name__)


def _update_tag_pages(site: Path, tag: str) -> None:
    """
    Update the xhtml pages and xmllists for a given tag
    """
    taggedfile = Path(f"{site}/tags/tagged.en.xhtml")
    content = taggedfile.read_text().replace("XXX_TAGNAME_XXX", tag)
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
    taglist = textwrap.dedent(
        """\
            <?xml version="1.0" encoding="UTF-8"?>
    
            <tagset>
           """
    )
    for section in ["news", "events"]:
        for tag in files_by_tag:
            count = filecount[section][tag]
            label = (
                tags_by_lang[lang][tag]
                if keys_exists(tags_by_lang, lang, tag) and tags_by_lang[lang][tag]
                else (
                    tags_by_lang["en"][tag]
                    if keys_exists(tags_by_lang, "en", tag) and tags_by_lang["en"][tag]
                    else tag
                )
            )
            if count > 0:
                taglist = taglist + textwrap.dedent(
                    f"""\
                    <tag section="{section}" key="{tag}" count="{count}">{label}</tag>
                       """
                )
    taglist = taglist + textwrap.dedent(
        """\
            </tagset>
           """
    )
    update_if_changed(Path(f"{site}/tags/.tags.{lang}.xml"), taglist)


def update_tags(languages: list[str], pool: multiprocessing.Pool) -> None:
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
    for site in filter(
        lambda path: path.joinpath("tags").exists(),
        Path(".").glob("?*.??*"),
    ):
        logger.info(f"Updating tags for {site}")
        # Create a complete and current map of which tag is used in which files
        files_by_tag = {}
        tags_by_lang = {}
        # Fill out files_by_tag and tags_by_lang
        for file in filter(
            lambda file:
            # Not in tags dir of a site
            site.joinpath("tags") not in file.parents
            # Has a tag element
            and etree.parse(file).xpath("//tag"),
            site.glob("**/*.xml"),
        ):
            xslt_root = etree.parse(file)
            for tag in xslt_root.xpath("//tag"):
                # Get the key attribute, and filter out some invalid chars
                key = (
                    tag.get("key")
                    .replace("/", "-")
                    .replace(" ", "-")
                    .replace(":", "-")
                    .strip()
                )
                # Get the label, and strip it.
                label = str(
                    escape(tag.text.strip()) if tag.text and tag.text.strip() else None
                )
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

        # Now we have the necessary data, begin
        logger.debug("Removing files for removed tags")
        tagfiles_to_delete = filter(
            lambda path: not any([(tag in str(path)) for tag in files_by_tag]),
            list(Path(f"{site}/tags/").glob("tagged-*.en.xhtml"))
            + list(Path(f"{site}/tags/").glob(".tagged-*.xmllist")),
        )
        pool.map(delete_file, tagfiles_to_delete)

        logger.debug("Updating tag pages")
        pool.starmap(
            _update_tag_pages,
            [(site, tag) for tag in files_by_tag],
        )

        logger.debug("Updating tag lists")
        pool.starmap(
            update_if_changed,
            [
                (
                    Path(f"{site}/tags/.tagged-{tag}.xmllist"),
                    ("\n".join(map(lambda file: str(file), files_by_tag[tag])) + "\n"),
                )
                for tag in files_by_tag
            ],
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
                        )
                    )
                )
        pool.starmap(
            _update_tag_sets,
            map(
                lambda lang: (site, lang, filecount, files_by_tag, tags_by_lang),
                filter(lambda lang: lang in languages, tags_by_lang.keys()),
            ),
        )
