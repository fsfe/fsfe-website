import argparse
from pathlib import Path


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
        default=list(
            map(lambda path: path.name, Path(".").glob("global/languages/??"))
        ),
        type=lambda input: input.split(","),
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
        "--serve",
        dest="serve",
        help="Serve the webpages after rebuild",
        action="store_true",
    )
    args = parser.parse_args()
    if not args.status_dir:
        args.status_dir = (
            f"{args.target.removesuffix('/')}/status.fsfe.org/fsfe.org/data"
        )
    return args
