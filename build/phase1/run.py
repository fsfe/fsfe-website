# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

# -----------------------------------------------------------------------------
# script for FSFE website build, phase 1
# -----------------------------------------------------------------------------
# This script is executed in the root of the source directory tree, and
# creates some .xml and xhtml files as well as some symlinks, all of which
# serve as input files in phase 2. The whole phase 1 runs within the source
# directory tree and does not touch the target directory tree at all.
# -----------------------------------------------------------------------------
import logging
import multiprocessing
from pathlib import Path

from .index_website import index_websites
from .prepare_subdirectories import prepare_subdirectories
from .update_css import update_css
from .update_defaultxsls import update_defaultxsls
from .update_localmenus import update_localmenus
from .update_stylesheets import update_stylesheets
from .update_tags import update_tags
from .update_xmllists import update_xmllists

logger = logging.getLogger(__name__)


def phase1_run(
    source_dir: Path,
    languages: list[str] or None,
    processes: int,
    pool: multiprocessing.Pool,
):
    """
    Run all the necessary sub functions for phase1.
    """
    logger.info("Starting Phase 1 - Setup")

    # -----------------------------------------------------------------------------
    # Build search index
    # -----------------------------------------------------------------------------

    # This step runs a Python tool that creates an index of all news and
    # articles. It extracts titles, teaser, tags, dates and potentially more.
    # The result will be fed into a JS file.
    index_websites(source_dir, languages, pool)
    # -----------------------------------------------------------------------------
    # Update CSS files
    # -----------------------------------------------------------------------------

    # This step recompiles the less files into the final CSS files to be
    # distributed to the web server.
    update_css(
        source_dir,
    )
    # -----------------------------------------------------------------------------
    # Update XSL stylesheets
    # -----------------------------------------------------------------------------

    # This step updates (actually: just touches) all XSL files which depend on
    # another XSL file that has changed since the last build run. The phase 2
    # Makefile then only has to consider the directly used stylesheet as a
    # prerequisite for building each file and doesn't have to worry about other
    # stylesheets imported into that one.
    # This must run before the "dive into subdirectories" step, because in the news
    # and events directories, the XSL files, if updated, will be copied for the
    # per-year archives.

    update_stylesheets(source_dir, pool)
    # -----------------------------------------------------------------------------
    # Dive into subdirectories
    # -----------------------------------------------------------------------------
    # Find any makefiles in subdirectories and run them
    prepare_subdirectories(source_dir, languages, processes)

    # -----------------------------------------------------------------------------
    # Create XSL symlinks
    # -----------------------------------------------------------------------------

    # After this step, each directory with source files for HTML pages contains a
    # symlink named .default.xsl and pointing to the default.xsl "responsible" for
    # this directory. These symlinks make it easier for the phase 2 Makefile to
    # determine which XSL script should be used to build a HTML page from a source
    # file.

    update_defaultxsls(source_dir, pool)
    # -----------------------------------------------------------------------------
    # Update local menus
    # -----------------------------------------------------------------------------

    # After this step, all .localmenu.??.xml files will be up to date.

    update_localmenus(source_dir, languages, pool)
    # -----------------------------------------------------------------------------
    # Update tags
    # -----------------------------------------------------------------------------

    # After this step, the following files will be up to date:
    # * tags/tagged-<tags>.en.xhtml for each tag used. Apart from being
    #   automatically created, these are regular source files for HTML pages, and
    #   in phase 2 are built into pages listing all news items and events for a
    #   tag.
    # * tags/.tags.??.xml with a list of the tags used.
    update_tags(source_dir, languages, pool)
    # -----------------------------------------------------------------------------
    # Update XML filelists
    # -----------------------------------------------------------------------------

    # After this step, the following files will be up to date:
    # * <dir>/.<base>.xmllist for each <dir>/<base>.sources as well as for each
    #   $site/tags/tagged-<tags>.en.xhtml. These files are used in phase 2 to include the
    #   correct XML files when generating the HTML pages. It is taken care that
    #   these files are only updated whenever their content actually changes, so
    #   they can serve as a prerequisite in the phase 2 Makefile.
    update_xmllists(source_dir, languages, pool)
