# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
"""Classes for holding build process config."""

from dataclasses import dataclass
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    import multiprocessing.pool
    from pathlib import Path


@dataclass(frozen=True)
class GlobalBuildConfig:
    """Immutable global configuration as part of a build."""

    source: Path
    pool: multiprocessing.pool.Pool
    processes: int
    working_target: Path


@dataclass(frozen=True)
class SiteBuildConfig:
    """Immutable Build config specific to a site."""

    site: Path
    languages: list[str]
