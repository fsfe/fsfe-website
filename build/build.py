#!/usr/bin/env python3

# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

import argparse
import logging
import multiprocessing
import sys
from pathlib import Path

from .lib.misc import lang_from_filename

from .phase0.full import full
from .phase0.global_symlinks import global_symlinks
from .phase0.prepare_early_subdirectories import prepare_early_subdirectories

from .phase1.run import phase1_run
from .phase2.run import phase2_run

from .phase3.serve_websites import serve_websites
from .phase3.stage_to_target import stage_to_target

logger = logging.getLogger(__name__)


def parse_arguments() -> argparse.Namespace:
    """
    Parse the arguments of the website build process

    """
    parser = argparse.ArgumentParser(
        description="Python script to handle building of the fsfe webpage"
    )
    parser.add_argument(
        "--full",
        help="Force a full rebuild of all webpages.",
        action="store_true",
    )
    parser.add_argument(
        "--languages",
        help="Languages to build website in.",
        default=[],
        type=lambda input: input.split(","),
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
        "--serve",
        help="Serve the webpages after rebuild",
        action="store_true",
    )
    parser.add_argument(
        "--sites",
        help="What site directories to build",
        default=list(filter(lambda path: path.is_dir(), Path().glob("?*.??*"))),
        type=lambda input: list(map(lambda site: Path(site), input.split(","))),
    )
    parser.add_argument(
        "--stage",
        help="Force the use of an internal staging directory.",
        action="store_true",
    )
    parser.add_argument(
        "--target",
        help="Final dirs for websites to be build to. Can be a single path, or a comma separated list of valid rsync targets. Supports custom rsynx extension for specifying ports for ssh targets, name@host:path?port.",
        type=str,
        default="./output/final",
    )
    args = parser.parse_args()
    return args


def main():
    """
    Main process of the website builder
    """
    args = parse_arguments()
    logging.basicConfig(
        format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S",
        level=args.log_level,
    )
    logger.debug(args)

    with multiprocessing.Pool(args.processes) as pool:
        logger.info("Starting phase 0 - Global Conditional Setup")

        # TODO Should also be triggered whenever any build python file is changed
        if args.full:
            full()
        # -----------------------------------------------------------------------------
        # Create XML symlinks
        # -----------------------------------------------------------------------------

        # After this step, the following symlinks will exist:
        # * global/data/texts/.texts.<lang>.xml for each language
        # * global/data/topbanner/.topbanner.<lang>.xml for each language
        # Each of these symlinks will point to the corresponding file without a dot at
        # the beginning of the filename, if present, and to the English version
        # otherwise. This symlinks make sure that phase 2 can easily use the right file
        # for each language
        global_symlinks(
            args.languages
            if args.languages
            else list(
                map(lambda path: path.name, Path(".").glob("global/languages/??"))
            ),
            pool,
        )

        # Early subdirs
        # for subdir actions that need to be performed very early in the build process. Do not get access to languages to be built in, and other benefits of being ran later.
        for site in args.sites:
            prepare_early_subdirectories(
                site,
                args.processes,
            )

        stage_required = any(
            [args.stage, "@" in args.target, ":" in args.target, "," in args.target]
        )
        working_target = Path("./output/stage" if stage_required else args.target)
        # the two middle phases are unconditional, and run on a per site basis
        for site in args.sites:
            logger.info(f"Processing {site}")
            if not site.exists():
                logger.critical(f"Site {site} does not exist, exiting")
                sys.exit(1)
            languages = (
                args.languages
                if args.languages
                else list(
                    set(
                        map(
                            lambda path: lang_from_filename(path),
                            site.glob("**/*.*.xhtml"),
                        )
                    )
                )
            )
            # Processes needed only for subdir stuff
            phase1_run(site, languages, args.processes, pool)
            phase2_run(site, languages, pool, working_target.joinpath(site))

        logger.info("Starting Phase 3 - Global Conditional Finishing")
        if stage_required:
            stage_to_target(working_target, args.target, pool)

    if args.serve:
        serve_websites(working_target, 2000, 100)
