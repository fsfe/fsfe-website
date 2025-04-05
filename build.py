#!/usr/bin/env python3

# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

import argparse
import logging
import multiprocessing
import os
from pathlib import Path

from build.phase0.full import full
from build.phase1.run import phase1_run
from build.phase2.run import phase2_run
from build.phase3.serve_websites import serve_websites
from build.phase3.stage_to_target import stage_to_target

logger = logging.getLogger(__name__)


def parse_arguments() -> argparse.Namespace:
    """
    Parse the arguments of the website build process

    """
    parser = argparse.ArgumentParser(
        description="Python script to handle building of the fsfe webpage"
    )
    parser.add_argument(
        "--target",
        dest="target",
        help="Final dirs for websites to be build to. Can be a single path, or a comma separated list of valid rsync targets. Supports custom rsynx extension for specifying ports for ssh targets, name@host:path?port.",
        type=str,
        default="./output/final",
    )
    parser.add_argument(
        "--log-level",
        dest="log_level",
        type=str,
        default="INFO",
        choices=["DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"],
        help="Set the logging level (default: INFO)",
    )
    parser.add_argument(
        "--full",
        dest="full",
        help="Force a full rebuild of all webpages.",
        action="store_true",
    )
    parser.add_argument(
        "--processes",
        dest="processes",
        help="Number of processes to use when building the website",
        type=int,
        default=multiprocessing.cpu_count(),
    )
    parser.add_argument(
        "--languages",
        dest="languages",
        help="Languages to build website in.",
        default=list(
            map(lambda path: path.name, Path(".").glob("global/languages/??"))
        ),
        type=lambda input: input.split(","),
    )
    parser.add_argument(
        "--stage",
        dest="stage",
        help="Force the use of an internal staging directory.",
        action="store_true",
    )
    parser.add_argument(
        "--serve",
        dest="serve",
        help="Serve the webpages after rebuild",
        action="store_true",
    )
    args = parser.parse_args()
    return args


def main(args: argparse.Namespace):
    logging.basicConfig(
        format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S",
        level=args.log_level,
    )
    logger.debug(args)

    with multiprocessing.Pool(args.processes) as pool:
        logger.info("Starting phase 0 - Conditional Setup")

        # TODO Should also be triggered whenever any build python file is changed
        if args.full:
            full()

        stage_required = any(
            [args.stage, "@" in args.target, ":" in args.target, "," in args.target]
        )
        working_target = Path("./output/stage" if stage_required else args.target)

        # Processes needed only for subdir stuff
        phase1_run(args.languages, args.processes, pool)
        phase2_run(args.languages, pool, working_target)

        logger.info("Starting Phase 3 - Conditional Finishing")
        if stage_required:
            stage_to_target(working_target, args.target, pool)

    if args.serve:
        serve_websites(working_target, 2000, 100)


if __name__ == "__main__":
    """
    Main process of the website builder
    """
    # Change to the dir the script is in.
    os.chdir(os.path.dirname(__file__))
    args = parse_arguments()
    main(args)
