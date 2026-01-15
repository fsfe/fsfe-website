# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
from typing import TYPE_CHECKING

from fsfe_website_build.build import build

if TYPE_CHECKING:
    from pathlib import Path

    from pytest_mock import MockFixture


def no_rebuild_twice_test(mocker: MockFixture) -> None:
    cli_args = ["--languages", "en", "--log-level", "CRITICAL"]
    # first, run a full build
    build([*cli_args, "--full"])

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
    build(cli_args)
