#!/usr/bin/env python3

import argparse
import logging
import os
import subprocess
import sys
from pathlib import Path

from tools.serve_websites import serve_websites

logger = logging.getLogger(__name__)

if __name__ == "__main__":
    """
    Main process of the website builder
    """
    # Change to the dir the script is in.
    os.chdir(os.path.dirname(__file__))

    parser = argparse.ArgumentParser(
        description="Python script to handle building of the fsfe webpage"
    )
    parser.add_argument(
        "--target",
        dest="target",
        help="Directory to build websites into.",
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
        "--update",
        dest="update",
        help="Update the repo as part of the build.",
        action="store_true",
    )
    parser.add_argument(
        "--languages",
        dest="languages",
        help="Languages to build website in.",
        type=str,
    )
    # parser.add_argument(
    #     "--status",
    #     dest="status",
    #     help="Store status reports.",
    #     action="store_true",
    # )
    parser.add_argument(
        "--status-dir",
        dest="status_dir",
        help="Directory to store status reports in.",
        type=Path,
    )
    parser.add_argument(
        "--stage",
        dest="stage",
        help="Force the use of an internal staging directory.",
        action="store_true",
    )
    parser.add_argument(
        "--test",
        dest="test",
        help="Enable some testing features that test for worse scenarios, but hamper performance.",
        action="store_true",
    )
    parser.add_argument(
        "--serve",
        dest="serve",
        help="Serve the webpages after rebuild",
        action="store_true",
    )
    args = parser.parse_args()
    logging.basicConfig(format="*   %(message)s", level=args.log_level)
    Path("./output").mkdir(parents=True, exist_ok=True)
    if not (args.full and args.update):
        command = (
            "build_run"
            if not args.full or args.update
            else "build_into"
            if args.full
            else "git_build_into"
        )
    else:
        logger.critical("Cannot do a full rebuild and an update at once, exiting")
        sys.exit(1)
    if not args.status_dir:
        args.status_dir = (
            f"{args.target.removesuffix('/')}/status.fsfe.org/fsfe.org/data"
        )
    logger.debug(f"Args: {args}")
    to_run = (
        [
            "./build/build_main.sh",
            command,
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
                args.languages,
            ]
            if args.languages
            else []
        )
    )
    logger.debug(f"Subprocess command: {to_run}")
    env = dict(os.environ)
    env["LOGLEVEL"] = args.log_level
    if args.test:
        env["TEST"] = str(args.test).upper()
    logger.debug(f"Env Vars being set: {env}")
    build = subprocess.run(to_run, env=env)
    if build.returncode == 1:
        logger.critical("Build process has failed, Exiting!")
        sys.exit(1)
    if args.serve:
        serve_websites(args.target, 2000, 100)
