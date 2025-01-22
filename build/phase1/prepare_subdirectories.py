import logging
import sys
from pathlib import Path

logger = logging.getLogger(__name__)


def prepare_subdirectories(languages: list[str]) -> None:
    """
    Find any makefiles in subdirectories and run them
    """
    logger.info("Preparing Subdirectories")
    for subdir_script in Path("").glob("?*.?*/**/subdir.py"):
        logger.info(f"Preparing subdirectory {subdir_script.parent}")
        sys.path.append(str(subdir_script.parent.resolve()))
        import subdir
        subdir.run(languages)
        # Remove its path from where things can be imported
        sys.path.remove(str(subdir_script.parent.resolve()))
        # Remove it from loaded modules
        sys.modules.pop('subdir')
        # prevent us from accessing it again
        del subdir
