# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later


from pathlib import Path
from typing import Any

import pytest
from fsfe_website_build.lib.build_config import GlobalBuildConfig, SiteBuildConfig


class TestGlobalBuildConfig:
    def _base_kwargs(self) -> dict[str, Any]:
        return {
            "all_languages": ["en", "de", "fr", "it"],
            "clean_cache": False,
            "full": False,
            "languages": [],
            "log_level": "INFO",
            "processes": 4,
            "serve": False,
            "sites": [Path("fsfe.org")],
            "source": Path("src-sites"),
            "stage": False,
            "targets": ["output"],
            "working_target": Path("output"),
            "completion_notification": False,
        }

    def valid_empty_languages_test(self) -> None:
        kwargs = self._base_kwargs()
        config = GlobalBuildConfig(**kwargs)
        assert config.languages == []

    def valid_languages_test(self) -> None:
        kwargs = self._base_kwargs()
        kwargs["languages"] = ["en", "de"]
        config = GlobalBuildConfig(**kwargs)
        assert config.languages == ["en", "de"]

    def invalid_language_too_short_test(self) -> None:
        kwargs = self._base_kwargs()
        kwargs["languages"] = ["e"]
        with pytest.raises(ValueError, match="two-letter"):
            GlobalBuildConfig(**kwargs)

    def invalid_language_too_long_test(self) -> None:
        kwargs = self._base_kwargs()
        kwargs["languages"] = ["eng"]
        with pytest.raises(ValueError, match="two-letter"):
            GlobalBuildConfig(**kwargs)

    def invalid_language_non_alpha_test(self) -> None:
        kwargs = self._base_kwargs()
        kwargs["languages"] = ["e1"]
        with pytest.raises(ValueError, match="two-letter"):
            GlobalBuildConfig(**kwargs)

    def invalid_language_not_in_all_languages_test(self) -> None:
        kwargs = self._base_kwargs()
        # check https://en.wikipedia.org/wiki/List_of_ISO_639_language_codes
        # to ensure that it is not an actual lang code
        kwargs["languages"] = ["zz"]
        with pytest.raises(ValueError, match="all_languages"):
            GlobalBuildConfig(**kwargs)


class TestSiteBuildConfig:
    def creation_test(self) -> None:
        config = SiteBuildConfig(
            languages=["en", "de"],
            site=Path("/sites/example"),
        )
        assert config.languages == ["en", "de"]
        assert config.site == Path("/sites/example")
