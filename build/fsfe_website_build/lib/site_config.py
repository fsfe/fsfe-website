# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
"""Classes for per site config."""

from dataclasses import dataclass, field

# allow Path when not typechecking to allow dacite loading
from pathlib import Path  # noqa: TC003


@dataclass(frozen=True)
class FileSet:
    """File set type."""

    source: Path
    target: Path


@dataclass(frozen=True)
class Dependency:
    """Dependency type."""

    repo: str
    rev: str
    file_sets: list[FileSet]


@dataclass(frozen=True)
class Deployment:
    """Schema for settings for deployment."""

    required_files: list[str] = field(default_factory=list[str])


@dataclass(frozen=True)
class SiteConfig:
    """Schema for per site config."""

    dependencies: list[Dependency] = field(default_factory=list[Dependency])
    deployment: Deployment = field(default_factory=Deployment)
