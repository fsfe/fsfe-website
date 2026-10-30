# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
#
"""Fix the passed files in place."""

import argparse
import logging
import sys
from pathlib import Path
from typing import Protocol, runtime_checkable

from fsfe_website_hooks import fixes
from fsfe_website_hooks.lib.misc import FixError, load_stages, with_suffixes


@runtime_checkable
class Fix(Protocol):
    """A fix module."""

    ALLOWED_EXTENSIONS: set[str]

    def fix(self, files: list[Path]) -> None:
        """Fix the files in place, raising FixError for files it cannot fix."""


def main() -> None:
    """Fix the passed files."""
    parser = argparse.ArgumentParser(description="Fix passed files in place.")
    parser.add_argument("files", nargs="*", type=Path, help="Files to be fixed")
    args = parser.parse_args()
    logging.basicConfig(
        format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S",
        level=logging.INFO,
    )
    try:
        for stage in load_stages(fixes, Fix):
            for fix in stage:
                if files := with_suffixes(args.files, fix.ALLOWED_EXTENSIONS):
                    fix.fix(files)
    except FixError as error:
        sys.exit(str(error))


if __name__ == "__main__":
    main()
