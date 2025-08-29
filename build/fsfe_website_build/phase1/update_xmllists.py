# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

import datetime
import fnmatch
import logging
import multiprocessing
import re
from pathlib import Path

from lxml import etree

from fsfe_website_build.lib.misc import (
    get_basepath,
    lang_from_filename,
    touch_if_newer_dep,
    update_if_changed,
)

logger = logging.getLogger(__name__)


def _update_for_base(
    base: Path,
    all_xml: set[Path],
    nextyear: str,
    thisyear: str,
    lastyear: str,
) -> None:
    """
    Update the xmllist for a given base file
    """
    matching_files = set()
    # If sources exist
    if base.with_suffix(".sources").exists():
        # Load every file that matches the pattern
        # If a tag is included in the pattern, the file must contain that tag
        with base.with_suffix(".sources").open(mode="r") as file:
            for line in file:
                pattern = (
                    re.sub(r"(\*)?:\[.*\]$", "*", line)
                    .replace("$nextyear", nextyear)
                    .replace("$thisyear", thisyear)
                    .replace("$lastyear", lastyear)
                    .strip()
                )
                if len(pattern) <= 0:
                    logger.debug("Pattern too short, continue!")
                    continue
                tag = (
                    re.search(r":\[(.*)\]", line).group(1).strip()
                    if re.search(r":\[(.*)\]", line) is not None
                    else ""
                )

                for xml_file in filter(
                    lambda xml_file:
                    # Matches glob pattern
                    fnmatch.fnmatchcase(str(xml_file), pattern)
                    # contains tag if tag in pattern
                    and (
                        any(
                            (
                                etree.parse(
                                    xml_file_with_ending,
                                ).find(f".//tag[@key='{tag}']")
                                is not None
                                for xml_file_with_ending in xml_file.parent.glob(
                                    f"{xml_file.name}.*.xml"
                                )
                            ),
                        )
                        if tag != ""
                        else True
                    )
                    # Not just matching an empty xml_file
                    and len(str(xml_file)) > 0,
                    all_xml,
                ):
                    matching_files.add(str(xml_file))

    for file in Path().glob(f"{base}.??.xhtml"):
        xslt_root = etree.parse(file)
        for module in xslt_root.xpath("//module"):
            matching_files.add(f"global/data/modules/{module.get('id')}".strip())
    matching_files = sorted(matching_files)
    update_if_changed(
        Path(f"{base.parent}/.{base.name}.xmllist"),
        ("\n".join(matching_files) + "\n") if matching_files else "",
    )


def _update_module_xmllists(
    source_dir: Path,
    languages: list[str],
    pool: multiprocessing.Pool,
) -> None:
    """
    Update .xmllist files for .sources and .xhtml containing <module>s
    """
    logger.info("Updating XML lists")
    # Get all the bases and stuff before multithreading the update bit
    all_xml = {
        get_basepath(path)
        for path in filter(
            lambda path: lang_from_filename(path) in languages,
            list(source_dir.glob("**/*.*.xml"))
            + list(Path("global/").glob("**/*.*.xml")),
        )
    }
    source_bases = {path.with_suffix("") for path in source_dir.glob("**/*.sources")}
    module_bases = {
        get_basepath(path)
        for path in filter(
            lambda path: lang_from_filename(path) in languages
            and etree.parse(path).xpath("//module"),
            source_dir.glob("**/*.*.xhtml"),
        )
    }
    all_bases = source_bases | module_bases
    nextyear = str(datetime.datetime.today().year + 1)
    thisyear = str(datetime.datetime.today().year)
    lastyear = str(datetime.datetime.today().year - 1)
    pool.starmap(
        _update_for_base,
        ((base, all_xml, nextyear, thisyear, lastyear) for base in all_bases),
    )


def _check_xmllist_deps(file: Path) -> None:
    """
    If any of the sources in an xmllist are newer than it, touch the xmllist
    """
    xmls = set()
    with file.open(mode="r") as fileobj:
        for line in fileobj:
            for newfile in Path().glob(line.strip() + ".??.xml"):
                xmls.add(newfile)
    touch_if_newer_dep(file, list(xmls))


def _touch_xmllists_with_updated_deps(
    source_dir: Path,
    pool: multiprocessing.Pool,
) -> None:
    """
    Touch all .xmllist files where one of the contained files has changed
    """
    logger.info("Checking contents of XML lists")
    pool.map(_check_xmllist_deps, source_dir.glob("**/.*.xmllist"))


def update_xmllists(
    source_dir: Path,
    languages: list[str],
    pool: multiprocessing.Pool,
) -> None:
    """
    Update XML filelists (*.xmllist)

     Creates/update the following files:

    * <dir>/.<base>.xmllist for each <dir>/<base>.sources as well as for each
      fsfe.org/tags/tagged-<tags>.en.xhtml. These files are used in phase 2 to include
      the correct XML files when generating the HTML pages. It is taken care that
      these files are only updated whenever their content actually changes, so
      they can serve as a prerequisite in the phase 2 Makefile.

    Changing or removing tags in XML files is also considered, in which case a
    file is removed from the .xmllist files.

    When a tag has been removed from the last XML file where it has been used,
    the tagged-* are correctly deleted.
    """
    _update_module_xmllists(source_dir, languages, pool)
    _touch_xmllists_with_updated_deps(source_dir, pool)
