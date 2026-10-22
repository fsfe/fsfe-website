# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
from pathlib import Path
from typing import TYPE_CHECKING

import pytest
from fsfe_website_hooks.checks.stage1_general.check_name_newsdate_match import check

if TYPE_CHECKING:
    from multiprocessing.pool import ThreadPool


@pytest.mark.parametrize(
    ("name", "newsdate", "passed"),
    [
        ("news-20261022-01.en.xhtml", "2026-10-22", True),
        ("my-news.en.xhtml", "2026-10-22", False),
        ("news-20261022-01.en.xhtml", "22.10.2026", False),
    ],
)
@pytest.mark.usefixtures("in_tmp_path")
def name_newsdate_test(
    pool: ThreadPool,
    name: str,
    newsdate: str,
    passed: bool,
) -> None:
    file = Path("fsfe.org/news/2026") / name
    file.parent.mkdir(parents=True)
    file.write_text(f'<html newsdate="{newsdate}"/>')
    assert check([file], pool)[0] is passed
