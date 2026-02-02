# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
"""Global variables for build process."""

from pathlib import Path

from platformdirs import user_cache_dir

APP_NAME = "fsfe-website-build"

CACHE_DIR = Path(user_cache_dir(APP_NAME, "fsfe"))
