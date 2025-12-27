# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
"""Command line entrypoint to the build process."""

import argparse
import logging
import multiprocessing
import sys
from pathlib import Path
from textwrap import dedent

from .lib.misc import lang_from_filename
from .phase0.clean_cache import clean_cache
from .phase0.full import full
from .phase0.global_symlinks import global_symlinks
from .phase0.prepare_early_subdirectories import prepare_early_subdirectories
from .phase1.run import phase1_run
from .phase2.run import phase2_run
from .phase3.serve_websites import serve_websites
from .phase3.stage_to_target import stage_to_target

logger = logging.getLogger(__name__)


def _parse_arguments() -> argparse.Namespace:
    """Parse the arguments of the website build process."""
    parser = argparse.ArgumentParser(
        description="Python script to handle building of the fsfe webpage",
    )
    parser.add_argument(
        "--full",
        help="Force a full rebuild of all webpages.",
        action="store_true",
    )
    parser.add_argument(
        "--clean-cache",
        help="Clean the global cache stored in the platform cache directory.",
        action="store_true",
    )
    parser.add_argument(
        "--languages",
        help="Languages to build website in.",
        default=[],
        type=lambda langs: sorted(langs.split(",")),
    )
    parser.add_argument(
        "--log-level",
        type=str,
        default="INFO",
        choices=["DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"],
        help="Set the logging level (default: INFO)",
    )
    parser.add_argument(
        "--processes",
        help="Number of processes to use when building the website",
        type=int,
        default=multiprocessing.cpu_count(),
    )
    parser.add_argument(
        "--source",
        help="Source directory, that contains the sites and global data",
        default=Path(),
        type=Path,
    )
    parser.add_argument(
        "--serve",
        help="Serve the webpages after rebuild",
        action="store_true",
    )
    parser.add_argument(
        "--sites",
        help="What site directories to build",
        default=None,
        type=str,
    )
    parser.add_argument(
        "--stage",
        help="Force the use of an internal staging directory.",
        action="store_true",
    )
    parser.add_argument(
        "--target",
        help=dedent("""\
        Final dirs for websites to be build to.
        Can be a single path, or a comma separated list of valid rsync targets.
        Supports custom rsynx extension for specifying ports for ssh targets,
        name@host:path?port.
        """),
        type=str,
        default=None,
    )
    args = parser.parse_args()
    args.sites = (
        [path for path in args.source.glob("?*.??*") if path.is_dir()]
        if args.sites is None
        else [args.source.joinpath(site) for site in args.sites.split(",")]
    )
    if args.target is None:
        args.target = str(args.source.joinpath("output/final"))
    return args


def build(args: argparse.Namespace) -> None:
    """Coordinate the website builder."""
    logging.basicConfig(
        format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S",
        level=args.log_level,
    )
    logger.debug(args)

    with multiprocessing.Pool(args.processes) as pool:
        logger.info("Starting phase 0 - Global Conditional Setup")

        if args.clean_cache:
            clean_cache()
        # TODO Should also be triggered whenever any build python file is changed
        if args.full:
            full(args.source)
        global_symlinks(
            args.source,
            (
                args.languages
                if args.languages
                else sorted(
                    (path.name for path in args.source.glob("global/languages/??")),
                )
            ),
            pool,
        )

        stage_required = any(
            [args.stage, "@" in args.target, ":" in args.target, "," in args.target],
        )
        working_target = Path(
            f"{args.source}/output/stage" if stage_required else args.target
        )
        # the two middle phases are unconditional, and run on a per site basis
        for site in args.sites:
            logger.info("Processing %s", site)
            if not site.exists():
                logger.critical("Site %s does not exist, exiting", site)
                sys.exit(1)
            # Early subdirs
            # for subdir actions that need to be performed
            # very early in the build process.
            # Do not get access to languages to be built in,
            # and other benefits of being ran later.
            prepare_early_subdirectories(
                args.source,
                site,
                args.processes,
            )
            languages = (
                args.languages
                if args.languages
                else sorted(
                    {lang_from_filename(path) for path in site.glob("**/*.*.xhtml")},
                )
            )
            # Processes needed only for subdir stuff
            phase1_run(args.source, site, languages, args.processes, pool)
            phase2_run(
                args.source,
                site,
                languages,
                pool,
                working_target.joinpath(site.name),
            )

        logger.info("Starting Phase 3 - Global Conditional Finishing")
        if stage_required:
            stage_to_target(working_target, args.target, pool)

    if args.serve:
        serve_websites(working_target, args.sites, 2000, 100)


def main() -> None:
    """Parse args and run build."""
    args = _parse_arguments()
    build(args)
