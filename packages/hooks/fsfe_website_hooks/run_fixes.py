# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
#
"""Fix the passed files in place."""

import argparse
import logging
from pathlib import Path

from fsfe_website_hooks.fixes import convert_encoding, remove_empty_paragraphs

# Encoding first, as the later fixes parse the files.
FIXES = (convert_encoding, remove_empty_paragraphs)


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
    for fix in FIXES:
        fix.fix([file for file in args.files if file.suffix in fix.ALLOWED_EXTENSIONS])


if __name__ == "__main__":
    main()
