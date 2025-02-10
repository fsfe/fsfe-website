# -----------------------------------------------------------------------------
# script for FSFE website build, phase 2
# -----------------------------------------------------------------------------
import logging
from pathlib import Path

from .copy_files import copy_files
from .create_index_symlinks import create_index_symlinks
from .create_language_symlinks import create_language_symlinks
from .process_rss_ics_files import process_rss_ics_files
from .process_xhtml_files import process_xhtml_files

logger = logging.getLogger(__name__)


def phase2_run(languages: list[str], processes: int, target: Path):
    """
    Run all the necessary sub functions for phase2.
    """
    logger.info("Starting Phase 2")
    process_xhtml_files(languages, processes, target)
    create_index_symlinks(processes, target)
    create_language_symlinks(processes, target)
    process_rss_ics_files(languages, processes, target)
    copy_files(processes, target)
