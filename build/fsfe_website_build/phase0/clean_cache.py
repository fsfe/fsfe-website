# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Clean global cache."""

import logging
import shutil
from pathlib import Path

from platformdirs import user_cache_dir

logger = logging.getLogger(__name__)


def clean_cache() -> None:
    """Remove the global cache folder."""
    logger.info("Cleaning global cache")
    cache = Path(user_cache_dir("fsfe-website-build", "fsfe"))
    # Slightly more complex logic to handle the cache dir being a mount in docker
    for item in cache.iterdir():
        if item.is_file() or item.is_symlink():
            item.unlink()
        elif item.is_dir():
            shutil.rmtree(item)
