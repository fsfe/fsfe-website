import logging
from pathlib import Path

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


def sort_dict(dict: dict) -> dict:
    """
    Sort dict by keys
    """
    return {key: val for key, val in sorted(dict.items(), key=lambda ele: ele[0])}


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
