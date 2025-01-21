# -----------------------------------------------------------------------------
# script for FSFE website build, phase 2
# -----------------------------------------------------------------------------
import logging
from pathlib import Path

from .build_rss_ics_files import build_rss_ics_files
from .copy_files import copy_files
from .create_index_symlinks import create_index_symlinks
from .create_language_symlinks import create_language_symlinks
from .process_xhtml_files import process_xhtml_files

logger = logging.getLogger(__name__)


def phase2_run(languages: list[str], target: Path):
    """
    Run all the necessary sub functions for phase2.
    """
    logger.info("Starting Phase 2")
    process_xhtml_files(languages, target)
    create_index_symlinks(target)
    create_language_symlinks(target)
    build_rss_ics_files(languages, target)
    copy_files(target)
