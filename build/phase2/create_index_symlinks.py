import logging
import multiprocessing
from pathlib import Path

from build.lib import get_basename

logger = logging.getLogger(__name__)


def _do_symlinking(target: Path) -> None:
    source = target.parent.joinpath(
        f"index{target.with_suffix('').suffix}{target.suffix}"
    )
    if not source.exists():
        source.symlink_to(target.relative_to(source.parent))


def create_index_symlinks(processes: int, target: Path) -> None:
    """
    Create index.* symlinks
    """
    logger.info("Creating index symlinks")
    with multiprocessing.Pool(processes) as pool:
        pool.map(
            _do_symlinking,
            filter(
                lambda path: get_basename(path) == path.parent.name,
                target.glob("**/*.??.html"),
            ),
        )
