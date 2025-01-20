import logging
import multiprocessing
from pathlib import Path

logger = logging.getLogger(__name__)


def _do_symlinking(target: Path) -> None:
    source = target.parent.joinpath(
        f"index{target.with_suffix('').suffix}{target.suffix}"
    )
    if not source.exists():
        source.symlink_to(target.relative_to(source.parent))


def create_index_symlinks(target: Path) -> None:
    logger.info("Creating index symlinks")
    with multiprocessing.Pool(multiprocessing.cpu_count()) as pool:
        pool.map(
            _do_symlinking,
            filter(
                lambda path: path.with_suffix("").with_suffix("").name
                == path.parent.name,
                target.glob("**/*.??.html"),
            ),
        )
