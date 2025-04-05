# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

import logging
import re
from datetime import datetime
from pathlib import Path

import lxml.etree as etree

from build.lib.misc import get_basename, get_version, lang_from_filename

logger = logging.getLogger(__name__)


def _include_xml(file: Path) -> str:
    """
    include second level elements of a given XML file
    this emulates the behaviour of the original
    build script which wasn't able to load top
    level elements from any file
    """
    work_str = ""
    if file.exists():
        tree = etree.parse(file)
        root = tree.getroot()
        # Remove <version> because the filename attribute would otherwise be added
        # to this element instead of the actual content element.
        for elem in root.xpath("version"):
            root.remove(elem)
        # Iterate over all elements in root node, add a filename attribute and then append the string to work_str
        for elem in root.xpath("*"):
            elem.set("filename", get_basename(file))
            work_str += etree.tostring(elem, encoding="utf-8").decode("utf-8")

    return work_str


def _get_attributes(file: Path) -> str:
    """
    get attributes of top level element in a given
    XHTML file
    """
    work_str = ""
    tree = etree.parse(file)
    root = tree.getroot()
    attributes = root.attrib
    for attrib in attributes:
        work_str += f'{attrib}="{attributes[attrib]}"\n'

    return work_str


def _list_langs(file: Path) -> str:
    """
    list all languages a file exists in by globbing up
    the shortname (i.e. file path with file ending omitted)
    output is readily formatted for inclusion
    in xml stream
    """
    return "\n".join(
        list(
            map(
                lambda path: (
                    f'<tr id="{lang_from_filename(path)}">'
                    + (
                        Path(f"global/languages/{lang_from_filename(path)}")
                        .read_text()
                        .strip()
                        if Path(f"global/languages/{lang_from_filename(path)}").exists()
                        else lang_from_filename(path)
                    )
                    + "</tr>"
                ),
                file.parent.glob(f"{get_basename(file)}.??{file.suffix}"),
            )
        )
    )


def _auto_sources(action_file: Path, lang: str) -> str:
    """
    import elements from source files, add file name
    attribute to first element included from each file
    """
    work_str = ""
    list_file = action_file.with_stem(
        f".{action_file.with_suffix('').stem}"
    ).with_suffix(".xmllist")

    if list_file.exists():
        with list_file.open("r") as file:
            for path in map(lambda line: Path(line.strip()), file):
                path_xml = (
                    path.with_suffix(f".{lang}.xml")
                    if path.with_suffix(f".{lang}.xml").exists()
                    else path.with_suffix(".en.xml")
                )
                work_str += _include_xml(path_xml)

    return work_str


def _build_xmlstream(infile: Path):
    """
    assemble the xml stream for feeding into xsltproc
    the expected shortname and language flag indicate
    a single xhtml page to be built
    """
    # TODO
    # Ideally this would use lxml to construct an object instead of string templating.
    # Should be a little faster, and also guarantees that its valid xml

    logger.debug(f"infile: {infile}")
    shortname = infile.with_suffix("")
    lang = lang_from_filename(infile)
    glob = infile.parent.joinpath(f"{get_basename(infile)}.??{infile.suffix}")
    logger.debug(f"formed glob: {glob}")
    lang_lst = list(
        infile.parent.glob(f"{get_basename(infile)}.??{infile.suffix}"),
    )
    logger.debug(f"file lang list: {lang_lst}")
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
    topbanner_xml = Path(f"global/data/topbanner/.topbanner.{lang}.xml")
    texts_xml = Path(f"global/data/texts/.texts.{lang}.xml")
    date = str(datetime.now().date())
    # time = str(datetime.now().time())
    action_lang = ""
    translation_state = ""

    if infile.exists():
        action_lang = lang
        original_version = get_version(
            shortname.with_suffix(f".{original_lang}{infile.suffix}")
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
    logger.debug(f"action_file: {action_file}")

    result_str = f"""
		<buildinfo
		  date="{date}"
		  original="{original_lang}"
		  filename="/{str(shortname.with_suffix("")).removeprefix("/")}"
		  fileurl="/{shortname.relative_to(shortname.parts[0]).with_suffix("")}"
		  dirname="/{shortname.parent}/"
		  language="{lang}"
		  translation_state="{translation_state}"
		>

		<trlist>
		  {_list_langs(infile)}
		</trlist>

		<topbanner>
		{_include_xml(topbanner_xml)}
		</topbanner>
		<textsetbackup>
		{_include_xml(Path("global/data/texts/texts.en.xml"))}
		</textsetbackup>
		<textset>
		{_include_xml(texts_xml)}
		</textset>

		<document
		  language="{action_lang}"
		  {_get_attributes(action_file)}
		>
		  <set>
		    {_auto_sources(action_file, lang)} 
		  </set>

		  {_include_xml(action_file)}
		</document>

		</buildinfo>
        """
    return result_str


def process_file(infile: Path, processor: Path) -> str:
    """
    Process a given file using the correct xsl sheet
    """
    logger.debug(f"Processing {infile}")
    lang = lang_from_filename(infile)
    xmlstream = _build_xmlstream(infile)
    xslt_tree = etree.parse(processor.resolve())
    transform = etree.XSLT(xslt_tree)
    result = str(transform(etree.XML(xmlstream)))
    # And now a bunch of regexes to fix some links.
    # xx is the language code in all comments

    # TODO
    # Probably a faster way to do this
    # Maybe iterating though all a tags with lxml?
    # Once buildxmlstream generates an xml object that should be faster.

    # Remove https://fsfe.org (or https://test.fsfe.org) from the start of all
    result = re.sub(
        r"""href\s*=\s*("|')(https?://(test\.)?fsfe\.org)([^>])\1""",
        r"""href=\1\3\1""",
        result,
        flags=re.MULTILINE | re.IGNORECASE,
    )
    # Change links from /foo/bar.html into /foo/bar.xx.html
    # Change links from foo/bar.html into foo/bar.xx.html
    # Same for .rss and .ics links
    result = re.sub(
        r"""href\s*=\s*("|')(/?([^:>]+/)?[^:/.]+\.)(html|rss|ics)(#[^>]*)?\1""",
        rf"""href=\1\2{lang}.\4\5\1""",
        result,
        flags=re.MULTILINE | re.IGNORECASE,
    )
    # Change links from /foo/bar/ into /foo/bar/index.xx.html
    # Change links from foo/bar/ into foo/bar/index.xx.html
    result = re.sub(
        r"""href\s*=\s*("|')(/?[^:>]+/)\1""",
        rf"""href=\1\2index.{lang}.html\1""",
        result,
        flags=re.MULTILINE | re.IGNORECASE,
    )

    return result
