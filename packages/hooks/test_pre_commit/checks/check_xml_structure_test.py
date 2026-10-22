# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
from typing import TYPE_CHECKING

import pytest
from fsfe_website_hooks.checks.stage1_general.check_xml_structure import check

if TYPE_CHECKING:
    from multiprocessing.pool import ThreadPool
    from pathlib import Path

ENGLISH = "<html><version>1</version><p>Hello</p></html>"


@pytest.mark.parametrize(
    ("translation", "passed"),
    [
        ("<html><version>1</version><p>Hallo</p></html>", True),
        ("<html><version>1</version><div>Hallo</div></html>", False),
        ("<html><version>0</version><div>Hallo</div></html>", True),
        ("<html><version>one</version></html>", False),
    ],
    ids=["same", "different", "outdated", "unreadable"],
)
def xml_structure_test(
    tmp_path: Path,
    pool: ThreadPool,
    translation: str,
    passed: bool,
) -> None:
    (tmp_path / "page.en.xhtml").write_text(ENGLISH)
    german = tmp_path / "page.de.xhtml"
    german.write_text(translation)
    assert check([german], pool)[0] is passed


def no_english_skips_test(tmp_path: Path, pool: ThreadPool) -> None:
    german = tmp_path / "page.de.xhtml"
    german.write_text("<html/>")
    assert check([german], pool)[0]
