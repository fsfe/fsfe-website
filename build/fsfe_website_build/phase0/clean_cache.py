# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Clean global cache."""

import logging
from pathlib import Path
from shutil import rmtree

from platformdirs import user_cache_dir

logger = logging.getLogger(__name__)


def clean_cache() -> None:
    """Remove the global cache folder."""
    logger.info("Cleaning global cache")
    cache = Path(user_cache_dir("fsfe-website-build", "fsfe"))
    rmtree(cache)
