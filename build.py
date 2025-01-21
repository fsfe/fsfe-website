#!/usr/bin/env -S uv run

# /// script
# dependencies = [
# # XML parser
# "lxml==5.3.0",
# # For getting english language names of languages from two letter codes.
# "python-iso639==2024.10.22",
# # For stopwords for the search index
# "nltk==3.9.1",
# # For minification html, css and js
# "tdewolff-minify==2.20.37",
# ]
# ///


import argparse
import logging
import os
import subprocess
import sys
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

    to_run = (
        [
            "./build/build_main.sh",
            "build_run",
            args.target,
        ]
        + (
            ["--stage", "./output/stage"]
            if args.stage
            or "@" in args.target
            or ":" in args.target
            or "," in args.target
            else []
        )
        + (
            [
                "--status-dir",
                str(args.status_dir),
            ]
            if args.status_dir
            else []
        )
        + (
            [
                "--languages",
                ",".join(args.languages),
            ]
            if args.languages
            else []
        )
    )
    logger.debug(f"Subprocess command: {to_run}")
    build = subprocess.run(to_run)
    if build.returncode == 1:
        logger.critical("Build process has failed, Exiting!")
        sys.exit(1)
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
