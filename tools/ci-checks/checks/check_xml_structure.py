# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
#
"""Check that the passed files match xml structure across languages."""

import logging
from collections import defaultdict
from typing import TYPE_CHECKING

from fsfe_website_build.lib.checks import (
    compare_files,
)
from fsfe_website_build.lib.misc import (
    get_basepath,
    get_version,
)

if TYPE_CHECKING:
    import multiprocessing.pool
    from pathlib import Path

logger = logging.getLogger(__name__)

CHECK_TYPE = "critical"
ALLOWED_EXTENSIONS = {".xhtml", ".xml"}


def _job(master: Path, other: Path, whitelist: set[str]) -> str | None:
    """Return a result string for starmap."""
    try:
        if get_version(master) != get_version(other):
            return None
        errs = compare_files(master, other, whitelist)
        return (
            f"There were differences between {master} and {other}:\n{'\n'.join(errs)}"
            if errs
            else None
        )
    except Exception as e:
        return f"Exception occurred comparing {master} and {other}: ERROR {e}"


def check(files: list[Path], pool: multiprocessing.pool.Pool) -> tuple[bool, str]:
    """Check for xml structure differences."""
    whitelist = {
        "//discussion/@href",  # Mastodon links can be in different langs
        "/html/translator",  # the translator
        "//image/@alt",  # Image alt text for title image
        "//img/@alt",  # Image alt text
        "//input[@name='language']",  # Input language types
        "//label[@for='address']",
        "//label[@for='email']",
        "//label[@for='name']",  # city and many others
        "//label[@for='phone']",
        "//label[@for='zip']",  # zip code localisation
        "//profileimage/@alt",  # Profilemage alt text for about/people images
        "//track/@label",  # Language label, used in some track elements
        "//track/@srclang",  # Languages, used in some track elements
    }
    groups: defaultdict[tuple[Path, str], list[Path]] = defaultdict(list)
    for file in files:
        path = file.resolve()
        groups[(get_basepath(path), path.suffix)].append(path)

    tasks: list[tuple[Path, Path, set[str]]] = []
    for path_data, paths in groups.items():
        basepath, suffix = path_data
        if (master := basepath.parent / f"{basepath.name}.en{suffix}").exists():
            tasks.extend((master, path, whitelist) for path in paths if path != master)
        else:
            logger.warning(
                "No english translation of %s with suffix %s exists - skipping",
                basepath,
                suffix,
            )

    filtered_results = [
        result for result in pool.starmap(_job, tasks) if result is not None
    ]
    return len(filtered_results) == 0, "\n".join(filtered_results)
