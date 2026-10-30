# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
import io
from pathlib import Path
from typing import TYPE_CHECKING

import pytest
from fsfe_website_hooks.checks.stage1_general.check_image_ratio import check
from PIL import Image

if TYPE_CHECKING:
    from multiprocessing.pool import ThreadPool

    from pytest_mock import MockerFixture

NEWS = Path("fsfe.org/news/2026/news-20261022-01.en.xhtml")


def _png(width: int, height: int) -> bytes:
    image = io.BytesIO()
    Image.new("RGB", (width, height)).save(image, format="PNG")
    return image.getvalue()


@pytest.fixture
def news(tmp_path: Path, monkeypatch: pytest.MonkeyPatch) -> Path:
    monkeypatch.chdir(tmp_path)
    NEWS.parent.mkdir(parents=True)
    NEWS.write_text('<html><image url="https://example.org/preview.png"/></html>')
    return NEWS


@pytest.mark.parametrize(("size", "passed"), [((1600, 900), True), ((900, 900), False)])
def ratio_test(
    news: Path,
    pool: ThreadPool,
    mocker: MockerFixture,
    size: tuple[int, int],
    passed: bool,
) -> None:
    mocker.patch("requests.get").return_value.content = _png(*size)
    assert check([news], pool)[0] is passed


def failed_fetch_raises_test(
    news: Path, pool: ThreadPool, mocker: MockerFixture
) -> None:
    mocker.patch("requests.get").return_value.ok = False
    with pytest.raises(RuntimeError, match="Failed to fetch image"):
        check([news], pool)


def local_image_raises_test(news: Path, pool: ThreadPool) -> None:
    news.write_text('<html><image url="/graphics/preview.png"/></html>')
    with pytest.raises(RuntimeError, match="requires remote images"):
        check([news], pool)
