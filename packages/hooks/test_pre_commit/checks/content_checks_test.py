# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
from typing import TYPE_CHECKING

import pytest
from fsfe_website_hooks.checks.stage0_encoding import check_encoding
from fsfe_website_hooks.checks.stage1_general import (
    check_absolute_links,
    check_fixed_languages,
    check_image_alt,
    check_plain_email,
    check_style_attrib,
    check_style_elem,
    check_translators,
    check_versions,
)

if TYPE_CHECKING:
    from multiprocessing.pool import ThreadPool
    from pathlib import Path
    from types import ModuleType

GOOD = b"""<html>
  <version>1</version>
  <body>
    <p>Write to <email>contact@fsfe.org</email>.</p>
    <a href="/about/about.html">About</a>
    <img src="/graphics/logo.png" alt="FSFE logo"/>
  </body>
  <translator>Jane</translator>
</html>"""

BAD = [
    (check_encoding, b"<html><p>Caf\xe9</p></html>"),
    (check_absolute_links, b'<html><a href="https://fsfe.org/about/">a</a></html>'),
    (check_fixed_languages, b'<html><a href="/about/about.en.html">a</a></html>'),
    (check_image_alt, b'<html><img src="/logo.png" alt=" "/></html>'),
    (check_image_alt, b'<html><image url="/logo.png"/></html>'),
    (check_plain_email, b"<html><p>contact@fsfe.org</p></html>"),
    (check_style_attrib, b'<html><p style="color: red;">a</p></html>'),
    (check_style_elem, b"<html><style>p {}</style></html>"),
    (check_translators, b"<html><translator>Jane</translator><body/></html>"),
    (check_versions, b"<html><version>one</version></html>"),
]


@pytest.mark.parametrize("module", sorted({module for module, _ in BAD}, key=str))
def passes_good_page_test(tmp_path: Path, pool: ThreadPool, module: ModuleType) -> None:
    file = tmp_path / "page.en.xhtml"
    file.write_bytes(GOOD)
    assert module.check([file], pool)[0]


@pytest.mark.parametrize(("module", "content"), BAD)
def fails_bad_page_test(
    tmp_path: Path, pool: ThreadPool, module: ModuleType, content: bytes
) -> None:
    file = tmp_path / "page.en.xhtml"
    file.write_bytes(content)
    passed, message = module.check([file], pool)
    assert not passed
    assert str(file) in message
