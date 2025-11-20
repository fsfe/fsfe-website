# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
from argparse import Namespace
from pathlib import Path
from typing import TYPE_CHECKING

from fsfe_website_build.build import build

if TYPE_CHECKING:
    from pytest_mock import MockFixture


def no_rebuild_twice_test(mocker: MockFixture) -> None:
    # first, run a full build
    args = Namespace(
        full=True,
        languages=[
            "en",
            "nl",
            "de",
        ],
        log_level="CRITICAL",  # by only logging critical messages
        # the build should be faster, as evaluating less trhings to strings
        processes=8,
        source=Path(),
        serve=False,
        sites=[
            Path("drm.info"),
            Path("fsfe.org"),
            Path("pdfreaders.org"),
            Path("status.fsfe.org"),
        ],
        stage=False,
        target="output/final",
    )
    build(args)

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
    args.full = False
    build(args)
