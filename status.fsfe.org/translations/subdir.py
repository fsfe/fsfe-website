# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

import datetime
import logging
import multiprocessing
import os
from pathlib import Path

import lxml.etree as etree
from fsfe_website_build.lib.misc import (
    get_basepath,
    get_version,
    run_command,
    update_if_changed,
)

logger = logging.getLogger(__name__)


def _update_mtime(
    file: Path,
) -> None:
    logger.debug(f"Updating mtime of {file}")
    result = run_command(["git", "log", '--pretty="%ct"', "-1", file])
    time = int(result.strip('"'))
    os.utime(file, (time, time))


def _generate_translation_data(lang: str, priority: int, file: Path) -> dict:
    page = get_basepath(file)
    ext = file.suffix.removeprefix(".")
    working_file = file.with_suffix("").with_suffix(f".{lang}.{ext}")

    original_date = datetime.datetime.fromtimestamp(file.stat().st_mtime)

    original_version = str(get_version(file))
    translation_version = (
        str(get_version(working_file)) if working_file.exists() else "untranslated"
    )

    original_url = (
        f"https://webpreview.fsfe.org?uri=/{page.relative_to(page.parts[0])}.en.html"
        if ext == "xhtml"
        else (
            f"https://git.fsfe.org/FSFE/fsfe-website/src/branch/master/{page}.en.xml"
            if ext == "xml"
            else "#"
        )
    )
    translation_url = (
        "#"
        if not working_file.exists()
        else (
            f"https://webpreview.fsfe.org?uri=/{page.relative_to(page.parts[0])}.{lang}.html"
            if ext == "xhtml"
            else (
                f"https://git.fsfe.org/FSFE/fsfe-website/src/branch/master/{page}.{lang}.xml"
                if ext == "xml"
                else "#"
            )
        )
    )

    return (
        {
            "page": str(page),
            "original_date": str(original_date),
            "original_url": str(original_url),
            "original_version": str(original_version),
            "translation_url": str(translation_url),
            "translation_version": str(translation_version),
        }
        if translation_version != original_version
        else None
    )


def _get_text_ids(file: Path) -> list[str]:
    texts_tree = etree.parse(file)
    root = texts_tree.getroot()
    return list(
        filter(
            lambda text_id: text_id is not None,
            map(lambda elem: elem.get("id"), root.iter()),
        )
    )


def _create_overview(
    target_dir: Path,
    data: dict[str : dict[int : list[dict]]],
):
    work_file = target_dir.joinpath("langs.en.xml")
    if not target_dir.exists():
        target_dir.mkdir(parents=True)
    # Create the root element
    page = etree.Element("translation-overall-status")

    # Add the subelements
    version = etree.SubElement(page, "version")
    version.text = "1"
    for lang in data:
        language_elem = etree.SubElement(
            page,
            "language",
            short=lang,
            long=Path(f"global/languages/{lang}").read_text().strip(),
        )
        for prio in list(data[lang].keys())[:2]:
            etree.SubElement(
                language_elem,
                "priority",
                number=str(prio),
                value=str(len(data[lang][prio])),
            )

    result_str = etree.tostring(page, xml_declaration=True, encoding="utf-8").decode(
        "utf-8"
    )

    update_if_changed(work_file, result_str)


def _create_translation_file(
    target_dir: Path,
    lang: str,
    data: dict[int : list[dict]],
) -> None:
    work_file = target_dir.joinpath(f"translations.{lang}.xml")
    page = etree.Element("translation-status")
    version = etree.SubElement(page, "version")
    version.text = "1"
    for priority in data:
        prio = etree.SubElement(page, "priority", value=str(priority))
        for file_data in data[priority]:
            etree.SubElement(prio, "file", **file_data)

    en_texts_file = Path("global/data/texts/texts.en.xml")
    lang_texts_file = Path(f"global/data/texts/texts.{lang}.xml")
    en_texts = _get_text_ids(en_texts_file)
    lang_texts = _get_text_ids(lang_texts_file) if lang_texts_file.exists() else []

    missing_texts_elem = etree.SubElement(
        page,
        "missing-texts",
        en=str(get_version(en_texts_file)),
        curr_lang=(
            str(get_version(lang_texts_file))
            if lang_texts_file.exists()
            else "No texts File!"
        ),
        url=f"https://git.fsfe.org/FSFE/fsfe-website/src/branch/master/{lang_texts_file}",
        filepath=str(lang_texts_file),
    )
    for missing_text in filter(lambda text_id: text_id not in lang_texts, en_texts):
        text_elem = etree.SubElement(missing_texts_elem, "text")
        text_elem.text = missing_text

    # Save to XML file
    result_str = etree.tostring(page, xml_declaration=True, encoding="utf-8").decode(
        "utf-8"
    )

    update_if_changed(work_file, result_str)


def run(languages: list[str], processes: int, working_dir: Path) -> None:
    """
    Build translation-status xmls for languages where the status has changed.
    Xmls are placed in target_dir, and only languages are processed.
    """
    target_dir = working_dir.joinpath("data/")
    logger.debug(f"Building index of status of translations into dir {target_dir}")

    result = run_command(
        ["git", "rev-parse", "--show-toplevel"],
    )

    # TODO
    # Run generating all this stuff only if some xhtml|xml files have been changed

    # List files separated by a null bytes
    result = run_command(
        ["git", "ls-files", "-z", result],
    )

    with multiprocessing.Pool(processes) as pool:
        pool.map(
            _update_mtime,
            filter(
                lambda path: path.suffix in [".xhtml", ".xml"],
                # Split on null bytes, strip and then parse into path
                map(lambda line: Path(line.strip()), result.split("\x00")),
            ),
        )

        # Generate our file lists by priority
        # Super hardcoded unfortunately
        files_by_priority = dict()
        files_by_priority[1] = list(Path("fsfe.org/").glob("index.en.xhtml")) + list(
            Path("fsfe.org/freesoftware/").glob("freesoftware.en.xhtml")
        )
        files_by_priority[2] = list(
            Path("fsfe.org/activities/").glob("*/activity.en.xml")
        )
        files_by_priority[3] = (
            list(Path("fsfe.org/activities/").glob("*.en.xhtml"))
            + list(Path("fsfe.org/activities/").glob("*.en.xml"))
            + list(Path("fsfe.org/freesoftware/").glob("*.en.xhtml"))
            + list(Path("fsfe.org/freesoftware/").glob("*.en.xml"))
        )
        files_by_priority[4] = (
            list(Path("fsfe.org/order/").glob("*.en.xml"))
            + list(Path("fsfe.org/order/").glob("*.en.xhtml"))
            + list(Path("fsfe.org/contribute/").glob("*.en.xml"))
            + list(Path("fsfe.org/contribute/").glob("*.en.xhtml"))
        )
        files_by_priority[5] = list(Path("fsfe.org/order/").glob("**/*.en.xml")) + list(
            Path("fsfe.org/order/").glob("**/*.en.xhtml")
        )

        # Make remove files from a priority if they already exist in a higher priority
        for priority in sorted(files_by_priority.keys(), reverse=True):
            files_by_priority[priority] = list(
                filter(
                    lambda path: not any(
                        [
                            (path in files_by_priority[priority])
                            for priority in range(1, priority)
                        ]
                    ),
                    files_by_priority[priority],
                )
            )

        files_by_lang_by_prio = {}
        for lang in languages:
            files_by_lang_by_prio[lang] = {}
            for priority in sorted(files_by_priority.keys()):
                files_by_lang_by_prio[lang][priority] = list(
                    filter(
                        lambda result: result is not None,
                        pool.starmap(
                            _generate_translation_data,
                            [
                                (lang, priority, file)
                                for file in files_by_priority[priority]
                            ],
                        ),
                    )
                )

        # sadly single treaded, as only one file being operated on
        _create_overview(target_dir, files_by_lang_by_prio)

        pool.starmap(
            _create_translation_file,
            [
                (target_dir, lang, files_by_lang_by_prio[lang])
                for lang in files_by_lang_by_prio
            ],
        )
