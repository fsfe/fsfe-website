# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
#
"""Misc functions. Mainly common non trivial path manipulations."""

import logging
import subprocess
from typing import TYPE_CHECKING, Any, cast

from lxml import etree

if TYPE_CHECKING:
    from pathlib import Path

logger = logging.getLogger(__name__)


def keys_exists(element: dict[Any, Any], *keys: str) -> bool:
    """Check if *keys (nested) exists in `element` (dict)."""
    _element = element  # make a copy to prevent manipulating up the scope
    for key in keys:
        try:
            _element = _element[key]
        except KeyError:
            return False
    return True


def sort_dict[Dict: dict[Any, Any]](in_dict: Dict) -> Dict:
    """Sort dict by keys."""
    return cast("Dict", dict(sorted(in_dict.items(), key=lambda ele: ele[0])))


def update_if_changed(path: Path, content: str) -> None:
    """Compare the content of the file at path with the content.

    If the file does not exist,
    or its contents does not match content,
    write content to the file.
    """
    if not path.exists() or path.read_text() != content:
        logger.debug("Updating %s", path)
        path.write_text(content)


def touch_if_newer_dep(file: Path, deps: list[Path]) -> None:
    """Take a filepath, and a list of path of its dependencies.

    If any of the dependencies has been altered more recently than the file,
    touch the file.

    Essentially simple reimplementation of make deps for build targets.
    """
    if any(dep.stat().st_mtime > file.stat().st_mtime for dep in deps):
        logger.info("Touching %s", file)
        file.touch()


def delete_file(file: Path) -> None:
    """Delete given file using pathlib."""
    logger.debug("Removing file %s", file)
    file.unlink()


def lang_from_filename(file: Path) -> str:
    """Get the lang code from a file.

    Where the filename is of format
    <name>.XX.<ending>, with xx being the lang code.
    """
    lang = file.with_suffix("").suffix.removeprefix(".")
    # Lang codes should be the iso 631 2 letter codes,
    # but sometimes we use "nolang" to srop a file being built
    lang_length = 2
    if len(lang) != lang_length and lang != "nolang":
        message = f"Language {lang} from file {file} not of correct length"
        logger.error(message)
        raise RuntimeError(message)
    return lang


def run_command(commands: list[str]) -> str:
    """Run the passed command.

    Useful to standardise how we manage output,
    and command error handling across the project.
    """
    try:
        result = subprocess.run(  # noqa: S603 allow callsing subprocess without knowing the args
            # we validate that they are okay elsewhere in the code
            commands,
            capture_output=True,
            # Get output as str instead of bytes
            text=True,
            check=True,
        )
        return result.stdout.strip()
    except subprocess.CalledProcessError as error:
        logger.exception(
            "Command: %s returned non zero exit code %s\nstdout: %s\nstderr: %s",
            error.cmd,
            error.returncode,
            error.stdout,
            error.stderr,
        )
        raise


def get_version(file: Path) -> int:
    """Get the version tag of an xhtml|xml file."""
    xml = etree.parse(file)
    result_list = xml.xpath("/*/version")
    result = result_list[0].text if result_list else str(0)
    return int(result)


def get_basepath(file: Path) -> Path:
    """Return the file with the last two suffixes removed."""
    return file.with_suffix("").with_suffix("")


def get_basename(file: Path) -> str:
    """Return the name of the file with the last two suffixes removed."""
    return file.with_suffix("").with_suffix("").name


def get_localised_file(base_file: Path, lang: str, suffix: str) -> Path | None:
    """Return basefile localised if exists, else fallback if exists, else none."""
    # ensure the suffix has a leading .
    normalised_suffix = "." + suffix.removeprefix(".")
    return (
        localised
        if (
            localised := base_file.with_suffix(
                base_file.suffix + f".{lang}" + normalised_suffix
            )
        ).exists()
        else fallback
        if (
            fallback := base_file.with_suffix(
                base_file.suffix + ".en" + normalised_suffix
            )
        ).exists()
        else None
    )
