#!/usr/bin/env python3

import argparse
import logging
import os
from pathlib import Path

from build.full import full
from build.parse_arguments import parse_arguments
from build.phase1.run import phase1_run
from build.phase2.run import phase2_run
from build.serve_websites import serve_websites
from build.update import update

logger = logging.getLogger(__name__)


def main(args: argparse.Namespace):
    logging.basicConfig(
        format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S",
        level=args.log_level,
    )
    logger.debug(args)

    if args.full:
        full()
    if args.update:
        update()

    working_target = Path(
        "./output/stage"
        if args.stage or "@" in args.target or ":" in args.target or "," in args.target
        else args.target
    )

    phase1_run(args.languages)
    phase2_run(args.languages, working_target)

    if args.serve:
        serve_websites(args.target, 2000, 100)


if __name__ == "__main__":
    """
    Main process of the website builder
    """
    # Change to the dir the script is in.
    os.chdir(os.path.dirname(__file__))
    args = parse_arguments()
    main(args)
