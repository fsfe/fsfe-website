# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
import dataclasses
from pathlib import Path
from typing import TYPE_CHECKING

from fsfe_website_build.build import build
from fsfe_website_build.lib.build_config import GlobalBuildConfig

if TYPE_CHECKING:
    from pytest_mock import MockFixture


def no_rebuild_twice_test(mocker: MockFixture) -> None:
    # first, run a full build
    gbc = GlobalBuildConfig(
        all_languages=[
            "en",
            "de",
            "fr",
        ],
        clean_cache=False,
        full=True,
        languages=[
            "en",
        ],
        log_level="CRITICAL",
        processes=8,
        serve=False,
        sites=[
            Path("drm.info"),
            Path("fsfe.org"),
            Path("pdfreaders.org"),
            Path("status.fsfe.org"),
        ],
        source=Path(),
        stage=False,
        target="output/final",
        working_target=Path("output/final"),
    )
    build(gbc)

    # replace update_if_changed with
    # mocked one that exceptions if the file would be changed
    def fail_if_update(path: Path, content: str) -> None:
        if not path.exists() or path.read_text() != content:
            raise AssertionError(
                f"File {path} would have been updated on incremental build."
            )

    mocker.patch(
        "fsfe_website_build.lib.misc.update_if_changed", side_effect=fail_if_update
    )
    # now, run a normal build
    args_dict = dataclasses.asdict(gbc)
    args_dict["full"] = False
    new_gbc = GlobalBuildConfig(**args_dict)
    build(new_gbc)
