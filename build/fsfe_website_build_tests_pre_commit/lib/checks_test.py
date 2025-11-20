# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
import tempfile
from pathlib import Path
from typing import TYPE_CHECKING

import pytest
from fsfe_website_build.lib.checks import compare_elements, compare_files
from lxml import etree

if TYPE_CHECKING:
    from collections.abc import Generator


class TestCompareFiles:
    """Smoke tests for the high-level entry point."""

    @pytest.fixture
    def two_files(self) -> Generator[tuple[Path, Path]]:
        """Yield two temporary XML files with different content."""
        with tempfile.TemporaryDirectory() as tmpdir:
            a = Path(tmpdir) / "a.xml"
            b = Path(tmpdir) / "b.xml"
            a.write_text("<root><x/></root>")
            b.write_text("<root><y/></root>")
            yield a, b

    def test_compare_files_returns_list(self, two_files: tuple[Path, Path]) -> None:
        a, b = two_files
        assert isinstance(compare_files(a, b), list)

    def test_compare_files_finds_difference(self, two_files: tuple[Path, Path]) -> None:
        a, b = two_files
        diff = compare_files(a, b)
        assert len(diff) == 1


class TestCompareElements:
    """Unit tests for the xml comparator function"""

    def identical_elements_test(self) -> None:
        e1 = etree.Element("root")
        e2 = etree.Element("root")
        assert compare_elements(e1, e2) == []

    def tag_mismatch_test(self) -> None:
        e1 = etree.Element("root")
        e2 = etree.Element("other")
        diff = compare_elements(e1, e2)
        assert len(diff) == 1

    def attribute_delta_test(self) -> None:
        e1 = etree.Element("root", a="1")
        e2 = etree.Element("root", b="1")
        diff = compare_elements(e1, e2)
        assert len(diff) == 1

    def attribute_value_diff_test(self) -> None:
        e1 = etree.Element("root", x="1")
        e2 = etree.Element("root", x="2")
        diff = compare_elements(e1, e2)
        assert len(diff) == 1

    def whitelisted_attribute_ignored_test(self) -> None:
        e1 = etree.Element("root")
        etree.SubElement(e1, "test", x="1")
        e2 = etree.Element("root")
        etree.SubElement(e2, "test", x="2")
        assert compare_elements(e1, e2, ["//*[@x]"]) == []

    def child_count_mismatch_test(self) -> None:
        e1 = etree.Element("root")
        e1.append(etree.Element("a"))
        e2 = etree.Element("root")
        e2.extend([etree.Element("a"), etree.Element("b")])
        diff = compare_elements(e1, e2)
        assert len(diff) == 1

    def deep_path_reporting_test(self) -> None:
        root1 = etree.Element("root")
        root1.append(etree.Element("child"))
        root2 = etree.Element("root")
        root2.append(etree.Element("other"))
        diff = compare_elements(root1, root2)
        assert len(diff) == 1
