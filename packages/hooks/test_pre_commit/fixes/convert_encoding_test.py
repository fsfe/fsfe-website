# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
from typing import TYPE_CHECKING

import pytest
from fsfe_website_hooks.fixes.stage0_encoding.convert_encoding import fix
from fsfe_website_hooks.lib.misc import FixError

if TYPE_CHECKING:
    from pathlib import Path


@pytest.mark.parametrize(
    ("declaration", "encoding"),
    [
        ('<?xml version="1.0" encoding="iso-8859-2"?>\n', "iso-8859-2"),
        ("<?xml version='1.0' encoding='utf-16'?>\n", "utf-16"),
    ],
)
def converts_declared_encoding_test(
    tmp_path: Path, declaration: str, encoding: str
) -> None:
    text = declaration + "<p>Zażółć gęślą jaźń</p>\n"
    file = tmp_path / "page.en.xhtml"
    file.write_bytes(text.encode(encoding))
    fix([file])
    assert file.read_text(encoding="utf-8") == text.replace(encoding, "utf-8")


@pytest.mark.parametrize(
    "declaration",
    [
        "",
        '<?xml version="1.0" encoding="UTF-8"?>\n',
        '<?xml version="1.0" encoding="no-such-encoding"?>\n',
    ],
)
def misdeclared_raises_test(tmp_path: Path, declaration: str) -> None:
    content = (declaration + "<p>Café</p>\n").encode("latin-1")
    file = tmp_path / "page.en.xhtml"
    file.write_bytes(content)
    with pytest.raises(FixError, match=r"page\.en\.xhtml is not in its declared"):
        fix([file])
    assert file.read_bytes() == content


def leaves_utf8_alone_test(tmp_path: Path) -> None:
    file = tmp_path / "page.en.xhtml"
    file.write_text("<p>Zażółć gęślą jaźń</p>\n", encoding="utf-8")
    mtime = file.stat().st_mtime_ns
    fix([file])
    assert file.stat().st_mtime_ns == mtime
