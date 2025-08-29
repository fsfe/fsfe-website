# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

import datetime
import logging
import multiprocessing
from pathlib import Path

from fsfe_website_build.lib.misc import (
    get_basepath,
    get_version,
    run_command,
    update_if_changed,
)
from lxml import etree

logger = logging.getLogger(__name__)


def _generate_translation_data(lang: str, file: Path) -> dict:
    page = get_basepath(file)
    ext = file.suffix.removeprefix(".")
    working_file = file.with_suffix("").with_suffix(f".{lang}.{ext}")

    result = run_command(["git", "log", '--pretty="%ct"', "-1", file]).strip('"')
    time = int(result)
    original_date = datetime.datetime.fromtimestamp(time)

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
            (elem.get("id") for elem in root.iter()),
        ),
    )


def _create_overview(
    target_dir: Path,
    data: dict[str : dict[int : list[dict]]],
) -> None:
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
        "utf-8",
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
    for priority, file_data_list in data.items():
        prio = etree.SubElement(page, "priority", value=str(priority))
        for file_data in file_data_list:
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
        "utf-8",
    )

    update_if_changed(work_file, result_str)


def run(languages: list[str], processes: int, working_dir: Path) -> None:
    """
    Build translation-status xmls for languages where the status has changed.
    Xmls are placed in target_dir, and only languages are processed.
    """
    target_dir = working_dir.joinpath("data/")
    logger.debug("Building index of status of translations into dir %s", target_dir)

    # TODO
    # Run generating all this stuff only if some xhtml|xml files have been changed

    # List files separated by a null bytes
    all_git_tracked_files = run_command(
        ["git", "ls-files", "-z"],
    )

    all_files_with_translations = set(
        filter(
            lambda path: path.suffix in [".xhtml", ".xml"],
            # Split on null bytes, strip and then parse into path
            (Path(line.strip()) for line in all_git_tracked_files.split("\x00")),
        ),
    )
    priorities_and_searches = {
        "1": [
            "**/fsfe.org/index.en.xhtml",
            "**/fsfe.org/freesoftware/freesoftware.en.xhtml",
        ],
        "2": ["**/fsfe.org/activities/*/activity.en.xml"],
        "3": [
            "**/fsfe.org/activities/*.en.xhtml",
            "**/fsfe.org/activities/*.en.xml",
            "**/fsfe.org/freesoftware/*.en.xhtml",
            "**/fsfe.org/freesoftware/*.en.xml",
        ],
        "4": [
            "**/fsfe.org/order/*.en.xml",
            "**/fsfe.org/order/*.en.xhtml",
            "**/fsfe.org/contribute/*.en.xml",
            "**/fsfe.org/contribute/*.en.xhtml",
        ],
        "5": ["**/fsfe.org/order/**/*.en.xml", "**/fsfe.org/order/**/*.en.xhtml"],
    }
    with multiprocessing.Pool(processes) as pool:
        # Generate our file lists by priority
        # Super hardcoded unfortunately
        files_by_priority = {}
        for file in all_files_with_translations:
            for priority, searches in priorities_and_searches.items():
                if priority not in files_by_priority:
                    files_by_priority[priority] = []
                # If any search matches,
                # add it to that priority and skip all subsequent priorities
                if any(file.full_match(search) for search in searches):
                    files_by_priority[priority].append(file)
                    continue

        files_by_lang_by_prio = {}
        for lang in languages:
            files_by_lang_by_prio[lang] = {}
            for priority in sorted(files_by_priority.keys()):
                files_by_lang_by_prio[lang][priority] = list(
                    filter(
                        lambda result: result is not None,
                        pool.starmap(
                            _generate_translation_data,
                            [(lang, file) for file in files_by_priority[priority]],
                        ),
                    ),
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
