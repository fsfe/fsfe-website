# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Transform a file using a given processor, souring sources and similar correctly."""

import logging
import re
from datetime import datetime
from typing import TYPE_CHECKING, Any

from lxml import etree

from fsfe_website_build.lib.misc import get_basename, get_version, lang_from_filename

if TYPE_CHECKING:
    from pathlib import Path

logger = logging.getLogger(__name__)


def _get_xmls(file: Path, parser: etree.XMLParser) -> list[etree.Element]:
    """Include second level elements of a given XML file.

    This emulates the behaviour of the original
    build script which wasn't able to load top
    level elements from any file
    """
    elements: list[etree.Element] = []
    if file.exists():
        tree = etree.parse(file, parser)
        root = tree.getroot()
        # Remove <version> because the filename attribute would otherwise be added
        # to this element instead of the actual content element.
        for elem in root.xpath("version"):
            root.remove(elem)
        for elem in root.xpath("*"):
            elem.set("filename", get_basename(file))
            elements.append(elem)
        # and then we return the element
    return elements


def _get_attributes(file: Path) -> dict[str, Any]:
    """Get attributes of top level element in a given XHTML file."""
    tree = etree.parse(file)
    root = tree.getroot()
    attributes = root.items()
    return dict(attributes)


def _get_trlist(source: Path, file: Path) -> etree.Element:
    """List all languages a file exists.

    Does so by globbing up
    the shortname (i.e. file path with file ending omitted)
    output is readily formatted for inclusion
    in xml stream
    """
    trlist = etree.Element("trlist")
    for path in file.parent.glob(f"{get_basename(file)}.??{file.suffix}"):
        tr = etree.SubElement(trlist, "tr", id=lang_from_filename(path))
        tr.text = (
            source.joinpath(f"global/languages/{lang_from_filename(path)}")
            .read_text()
            .strip()
        )
    return trlist


def _get_set(
    source: Path, action_file: Path, lang: str, parser: etree.XMLParser
) -> etree.Element:
    """Import elements from source files.

    Adds file name attribute to first element included from each file
    """
    doc_set = etree.Element("set")
    list_file = action_file.with_stem(
        f".{action_file.with_suffix('').stem}",
    ).with_suffix(".xmllist")

    if list_file.exists():
        with list_file.open("r") as file:
            for path in (source.joinpath(line.strip()) for line in file):
                path_xml = (
                    path.with_suffix(f".{lang}.xml")
                    if path.with_suffix(f".{lang}.xml").exists()
                    else path.with_suffix(".en.xml")
                )
                doc_set.extend(_get_xmls(path_xml, parser))

    return doc_set


def _get_document(
    source: Path,
    action_lang: str,
    action_file: Path,
    lang: str,
    parser: etree.XMLParser,
) -> etree.Element:
    document = etree.Element(
        "document",
        language=action_lang,
        **_get_attributes(action_file),
    )
    document.append(_get_set(source, action_file, lang, parser))
    document.extend(_get_xmls(action_file, parser))
    return document


def _build_xmlstream(
    source: Path, infile: Path, parser: etree.XMLParser
) -> etree.Element:
    """Assemble the xml stream for feeding into the transform.

    The expected shortname and language flag indicate
    a single xhtml page to be built
    """
    logger.debug("infile: %s", infile)
    shortname = infile.with_suffix("")
    lang = lang_from_filename(infile)
    glob = infile.parent.joinpath(f"{get_basename(infile)}.??{infile.suffix}")
    logger.debug("formed glob: %s", glob)
    lang_lst = list(
        infile.parent.glob(f"{get_basename(infile)}.??{infile.suffix}"),
    )
    logger.debug("file lang list: %s", lang_lst)
    original_lang = (
        "en"
        if infile.with_suffix("").with_suffix(f".en{infile.suffix}").exists()
        else sorted(
            infile.parent.glob(f"{get_basename(infile)}.??{infile.suffix}"),
            key=get_version,
            reverse=True,
        )[0]
        .with_suffix("")
        .suffix.removeprefix(".")
    )
    topbanner_xml = source.joinpath(f"global/data/topbanner/.topbanner.{lang}.xml")
    texts_xml = source.joinpath(f"global/data/texts/.texts.{lang}.xml")
    date = str(datetime.now().date())
    action_lang = ""
    translation_state = ""

    if infile.exists():
        action_lang = lang
        original_version = get_version(
            shortname.with_suffix(f".{original_lang}{infile.suffix}"),
        )
        lang_version = get_version(shortname.with_suffix(f".{lang}{infile.suffix}"))
        translation_state = (
            "up-to-date"
            if (original_version <= lang_version)
            else (
                "very-outdated"
                if (original_version - 3 >= lang_version)
                else "outdated"
            )
        )
    else:
        action_lang = original_lang
        translation_state = "untranslated"

    action_file = shortname.with_suffix(f".{action_lang}{infile.suffix}")
    logger.debug("action_file: %s", action_file)
    # Create the root element
    page = etree.Element(
        "buildinfo",
        date=date,
        original=original_lang,
        filename=f"/{str(shortname.with_suffix('')).removeprefix('/')}",
        fileurl=f"/{shortname.relative_to(shortname.parts[0]).with_suffix('')}",
        dirname=f"/{shortname.parent}/",
        language=lang,
        translation_state=translation_state,
    )

    # Add the subelements
    page.append(_get_trlist(source, infile))

    # Make the relevant subelmenets
    # and then add the relevant xmls to it
    topbanner = etree.SubElement(page, "topbanner")
    topbanner.extend(_get_xmls(topbanner_xml, parser))

    textsetbackup = etree.SubElement(page, "textsetbackup")
    textsetbackup.extend(
        _get_xmls(source.joinpath("global/data/texts/texts.en.xml"), parser)
    )

    textset = etree.SubElement(page, "textset")
    textset.extend(_get_xmls(texts_xml, parser))

    page.append(_get_document(source, action_lang, action_file, lang, parser))
    return page


def process_file(source: Path, infile: Path, transform: etree.XSLT) -> str:
    """Process a given file using the correct xsl sheet."""
    logger.debug("Processing %s", infile)
    lang = lang_from_filename(infile)
    parser = etree.XMLParser(remove_blank_text=True, remove_comments=True)
    xmlstream = _build_xmlstream(source, infile, parser)
    result = transform(xmlstream)
    # And now a bunch of regexes to fix some links.
    # xx is the language code in all comments
    try:
        for linkelem in result.xpath("//*[@href]"):
            # remove any spurious whitespace
            linkelem.set(
                "href",
                linkelem.get("href").strip(),
            )
            # Change links from /foo/bar.html into /foo/bar.xx.html
            # Change links from foo/bar.html into foo/bar.xx.html
            # Same for .rss and .ics links
            linkelem.set(
                "href",
                re.sub(
                    r"""^(/?([^:>]+/)?[^:/.]{3,}\.)(html|rss|ics)""",
                    rf"""\1{lang}.\3""",
                    linkelem.get("href"),
                    flags=re.IGNORECASE,
                ),
            )
            # Change links from /foo/bar/ into /foo/bar/index.xx.html
            # Change links from foo/bar/ into foo/bar/index.xx.html
            linkelem.set(
                "href",
                re.sub(
                    r"""^(/?[^:>]+/)$""",
                    rf"""\1index.{lang}.html""",
                    linkelem.get("href"),
                    flags=re.IGNORECASE,
                ),
            )
    except AssertionError:
        logger.debug("Output generated for file %s is not valid xml", infile)
    return str(result)
