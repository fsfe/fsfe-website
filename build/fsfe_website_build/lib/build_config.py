# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
"""Classes for holding build process config."""

from dataclasses import dataclass
from typing import TYPE_CHECKING, Literal

if TYPE_CHECKING:
    from pathlib import Path


@dataclass(frozen=True)
class GlobalBuildConfig:
    """Immutable global configuration as part of a build."""

    all_languages: list[str]
    clean_cache: bool
    full: bool
    languages: list[str]
    log_level: Literal["DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"]
    processes: int
    serve: bool
    sites: list[Path]
    source: Path
    stage: bool
    targets: list[str]
    working_target: Path

    def __post_init__(self) -> None:
        """Validate build settings."""
        # Language validation
        if self.languages:
            # All languages are two letter codes
            for lang in self.languages:
                if len(lang) != 2 or not lang.isalpha():  # noqa: PLR2004
                    message = (
                        f"Language code '{lang}'"
                        " must be a two-letter alphabetic string."
                    )
                    raise ValueError(message)

            # All languages should exist in the global config
            if any(lang not in self.all_languages for lang in self.languages):
                message = "All languages must be in the 'all_languages' list."
                raise ValueError(message)


@dataclass(frozen=True)
class SiteBuildConfig:
    """Immutable Build config specific to a site."""

    languages: list[str]
    site: Path
