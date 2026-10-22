# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
from typing import TYPE_CHECKING

import pytest
from fsfe_website_hooks.checks.stage1_general.check_non_en_frontpage_news import check

if TYPE_CHECKING:
    from multiprocessing.pool import ThreadPool
    from pathlib import Path


@pytest.mark.parametrize("has_english", [True, False])
def frontpage_news_test(
    tmp_path: Path,
    pool: ThreadPool,
    has_english: bool,
) -> None:
    german = tmp_path / "news-20261022-01.de.xhtml"
    german.write_text('<html><tags><tag key="front-page"/></tags></html>')
    if has_english:
        (tmp_path / "news-20261022-01.en.xhtml").write_text("<html/>")
    assert check([german], pool)[0] is has_english
