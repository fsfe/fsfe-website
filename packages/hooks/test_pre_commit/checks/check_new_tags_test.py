# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
from pathlib import Path
from typing import TYPE_CHECKING

import pytest
from fsfe_website_hooks.checks.stage1_general.check_new_tags import check

if TYPE_CHECKING:
    from multiprocessing.pool import ThreadPool


@pytest.mark.parametrize(("key", "passed"), [("existing", True), ("brand-new", False)])
@pytest.mark.usefixtures("in_tmp_path")
def new_tags_test(
    pool: ThreadPool,
    key: str,
    passed: bool,
) -> None:
    old = Path("fsfe.org/news/2025/news-20250101-01.en.xhtml")
    new = Path("fsfe.org/news/2026/news-20261022-01.en.xhtml")
    for file in (old, new):
        file.parent.mkdir(parents=True)
    old.write_text('<html><tags><tag key="existing"/></tags></html>')
    new.write_text(f'<html><tags><tag key="{key}"/></tags></html>')
    assert check([new], pool)[0] is passed


def ignores_other_pages_test(tmp_path: Path, pool: ThreadPool) -> None:
    page = tmp_path / "page.en.xhtml"
    page.write_text('<html><tags><tag key="brand-new"/></tags></html>')
    assert check([page], pool)[0]
