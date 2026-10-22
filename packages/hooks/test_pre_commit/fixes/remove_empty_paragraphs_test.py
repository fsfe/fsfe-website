# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
from typing import TYPE_CHECKING

import pytest
from fsfe_website_hooks.fixes.stage1_general.remove_empty_paragraphs import fix
from fsfe_website_hooks.lib.misc import FixError

if TYPE_CHECKING:
    from pathlib import Path


def removes_empty_paragraphs_test(tmp_path: Path) -> None:
    file = tmp_path / "page.en.xhtml"
    file.write_text("<html><p> </p><p><img/></p><p>text</p></html>")
    fix([file])
    assert "<p> </p>" not in file.read_text()
    assert "<p><img/></p><p>text</p>" in file.read_text()


def malformed_changes_nothing_test(tmp_path: Path) -> None:
    good = tmp_path / "good.en.xhtml"
    bad = tmp_path / "bad.en.xhtml"
    good.write_text("<html><p></p></html>")
    bad.write_text("<html><p></div></html>")
    with pytest.raises(FixError, match=r"bad\.en\.xhtml is not well-formed XML"):
        fix([good, bad])
    assert good.read_text() == "<html><p></p></html>"
