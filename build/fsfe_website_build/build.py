# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
"""Command line entrypoint to the build process."""

import argparse
import logging
import multiprocessing
import sys
import tomllib
from pathlib import Path
from textwrap import dedent

from dacite import Config, from_dict

from .lib.build_config import GlobalBuildConfig, SiteBuildConfig
from .lib.misc import lang_from_filename
from .lib.site_config import SiteConfig
from .phase0.clean_cache import clean_cache
from .phase0.full import full
from .phase0.global_symlinks import global_symlinks
from .phase0.prepare_early_subdirectories import prepare_early_subdirectories
from .phase1.run import phase1_run
from .phase2.run import phase2_run
from .phase3.completion_notification import completion_notification
from .phase3.serve_websites import serve_websites
from .phase3.stage_to_target import stage_to_target

logger = logging.getLogger(__name__)


def _build_parser() -> argparse.ArgumentParser:
    """Build the argument parser."""
    parser = argparse.ArgumentParser(
        description="Python script to handle building of the fsfe webpages",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
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
        nargs="+",
        type=str,
    )
    parser.add_argument(
        "--log-level",
        type=str,
        default="INFO",
        choices=["DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"],
        help="Set the logging level",
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
        nargs="+",
        type=Path,
    )
    parser.add_argument(
        "--stage",
        help="Force the use of an internal staging directory.",
        action="store_true",
    )
    parser.add_argument(
        "--targets",
        help=dedent("""\
        Final dirs for websites to be build to.
        Can be a single path, or a comma separated list of valid rsync targets.
        Supports custom rsynx extension for specifying ports for ssh targets,
        name@host:path?port.
        """),
        nargs="+",
        type=str,
    )
    parser.add_argument(
        "--completion-notification",
        help=dedent("""\
        Send a notification a build finishes successfully.
        Requires extra dependencies from the `notifications` dep group.
        Easiest way to get them is `uv sync --all-groups`
        """),
        action="store_true",
    )
    return parser


def _build_config_from_arguments(args: argparse.Namespace) -> GlobalBuildConfig:
    """Convert the arguments to a build config."""
    # Now, update any args that need to default based on other arguments
    args.sites = (
        [path for path in args.source.glob("?*.??*") if path.is_dir()]
        if args.sites is None
        else args.sites
    )
    if not args.targets:
        args.targets = [str(args.source.joinpath("output/final"))]
    args.stage = (
        args.stage
        # Multiple targets
        or len(args.targets) > 1
        # Has special char marking it as an rsync ssh target
        or any(char in target for char in "@:" for target in args.targets)
    )
    # And our derived settings we do not have as an argument
    # args.targets is certain to be exactly one long if args.stage is not true
    working_target = Path(
        args.source / "output/stage" if args.stage else args.targets[0]
    )
    all_languages = sorted(
        (path.name for path in args.source.glob("global/languages/??")),
    )
    return GlobalBuildConfig(
        **vars(args), working_target=working_target, all_languages=all_languages
    )


def _run_build(global_build_config: GlobalBuildConfig) -> None:
    """Coordinate the website builder."""
    logging.basicConfig(
        format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S",
        level=global_build_config.log_level,
    )
    logger.debug(global_build_config)

    with multiprocessing.Pool(global_build_config.processes) as pool:
        logger.info("Starting phase 0 - Global Conditional Setup")
        # These are simple conditional steps that interact directly with args
        if global_build_config.clean_cache:
            clean_cache()
        # TODO Should also be triggered whenever any build python file is changed
        if global_build_config.full:
            full(global_build_config.source)
        global_symlinks(
            global_build_config.source,
            (
                global_build_config.languages
                if global_build_config.languages
                else global_build_config.all_languages
            ),
            pool,
        )
        # Create our stable config across all sites
        # the two middle phases are unconditional, and run on a per site basis
        for site in global_build_config.sites:
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
                global_build_config,
                site,
            )
            languages: list[str] = (
                global_build_config.languages
                if global_build_config.languages
                else sorted(
                    {lang_from_filename(path) for path in site.glob("**/*.*.xhtml")},
                )
            )
            # Now we know our languages, build our site build config
            site_build_config = SiteBuildConfig(languages, site)
            # And build our config that is saved inside the site
            site_config = (
                from_dict(
                    SiteConfig,
                    tomllib.loads(config_file.read_text()),
                    Config(strict=True, cast=[Path]),
                )
                if (config_file := site / "config.toml").exists()
                else SiteConfig()
            )

            # Processes needed only for subdir stuff
            phase1_run(global_build_config, site_build_config, site_config, pool)
            site_target = global_build_config.working_target / site.name

            phase2_run(
                global_build_config, site_build_config, site_config, site_target, pool
            )

        logger.info("Starting Phase 3 - Global Conditional Finishing")
        if global_build_config.stage:
            stage_to_target(
                global_build_config.working_target, global_build_config.targets, pool
            )
    if global_build_config.completion_notification:
        completion_notification()

    if global_build_config.serve:
        serve_websites(
            global_build_config.working_target, global_build_config.sites, 2000, 100
        )


def build(passed_args: list[str] | None = None) -> None:
    """Parse args and run build."""
    parser = _build_parser()
    args = parser.parse_args(passed_args)
    global_build_config = _build_config_from_arguments(args)
    _run_build(global_build_config)
