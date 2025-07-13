# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

import logging
import subprocess
import sys
from pathlib import Path

import lxml.etree as etree

logger = logging.getLogger(__name__)


def keys_exists(element: dict, *keys: str) -> bool:
    """
    Check if *keys (nested) exists in `element` (dict).
    """
    if not isinstance(element, dict):
        raise AttributeError("keys_exists() expects dict as first argument.")
    if len(keys) == 0:
        raise AttributeError("keys_exists() expects at least two arguments, one given.")

    _element = element
    for key in keys:
        try:
            _element = _element[key]
        except KeyError:
            return False
    return True


def sort_dict(in_dict: dict) -> dict:
    """
    Sort dict by keys
    """
    return {key: val for key, val in sorted(in_dict.items(), key=lambda ele: ele[0])}


def update_if_changed(path: Path, content: str) -> None:
    """
    Compare the content of the file at path with the content.
    If the file does not exist,
    or its contents does not match content,
    write content to the file.
    """
    if not path.exists() or path.read_text() != content:
        logger.debug(f"Updating {path}")
        path.write_text(content)


def touch_if_newer_dep(file: Path, deps: list[Path]) -> None:
    """
    Takes a filepath , and a list of path of its dependencies.
    If any of the dependencies has been altered more recently than the file,
    touch the file.

    Essentially simple reimplementation of make deps for build targets.
    """
    if any(dep.stat().st_mtime > file.stat().st_mtime for dep in deps):
        logger.info(f"Touching {file}")
        file.touch()


def delete_file(file: Path) -> None:
    """
    Delete given file using pathlib
    """
    logger.debug(f"Removing file {file}")
    file.unlink()


def lang_from_filename(file: Path) -> str:
    """
    Get the lang code from a file, where the filename is of format
    <name>.XX.<ending>, with xx being the lang code.
    """
    lang = file.with_suffix("").suffix.removeprefix(".")
    # Lang codes should be the iso 631 2 letter codes,
    # but sometimes we use "nolang" to srop a file being built
    if len(lang) != 2 and lang != "nolang":
        logger.critical(
            f"Language {lang} from file {file} not of correct length, exiting"
        )
        sys.exit(1)
    else:
        return lang


def run_command(commands: list) -> str:
    result = subprocess.run(
        commands,
        capture_output=True,
        # Get output as str instead of bytes
        text=True,
    )
    if result.returncode != 0:
        logger.critical(f"Command {commands} failed with error")
        logger.critical(result.stderr.strip())
        sys.exit(1)
    return result.stdout.strip()


def get_version(file: Path) -> int:
    """
    Get the version tag of an xhtml|xml file
    """
    xslt_tree = etree.parse(Path("build/xslt/get_version.xsl"))
    transform = etree.XSLT(xslt_tree)
    result = transform(etree.parse(file))
    result = str(result).strip()
    if result == "":
        result = str(0)
    logger.debug(f"Got version: {result}")
    return int(result)


def get_basepath(file: Path) -> Path:
    """
    Return the file with the last two suffixes removed
    """
    return file.with_suffix("").with_suffix("")


def get_basename(file: Path) -> str:
    """
    Return the name of the file with the last two suffixes removed
    """
    return file.with_suffix("").with_suffix("").name
