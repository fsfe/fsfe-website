# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

import textwrap
from pathlib import Path
from tempfile import TemporaryDirectory
from typing import TYPE_CHECKING

import pytest
from fsfe_website_build.lib.process_file import process_file
from lxml import etree

if TYPE_CHECKING:
    from pytest_mock import MockFixture


@pytest.fixture
def sample_xsl_transformer(tmp_path: Path) -> etree.XSLT:
    """Minimal XSLT that just copies the input through."""
    xsl_path = tmp_path / "sample.xsl"
    xsl_path.write_text(
        textwrap.dedent(
            """
            <?xml version="1.0" encoding="UTF-8"?>
            <xsl:stylesheet version="1.0"
                            xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
              <xsl:output method="xml" indent="no"/>
              <xsl:template match="/|node()|@*">
                <xsl:copy>
                  <xsl:apply-templates select="node()|@*"/>
                </xsl:copy>
              </xsl:template>
            </xsl:stylesheet>
            """,
        ).strip(),
    )
    parser = etree.XMLParser(remove_blank_text=True, remove_comments=True)
    xslt_tree = etree.parse(xsl_path.resolve(), parser)
    return etree.XSLT(xslt_tree)


@pytest.mark.parametrize(
    ("lang", "link_in", "link_out"),
    [
        ("en", "foo/bar.html", "foo/bar.en.html"),
        ("en", "/foo/bar.html", "/foo/bar.en.html"),
        ("de", "news.rss", "news.de.rss"),
        ("fr", "events.ics", "events.fr.ics"),
        ("en", "folder/", "folder/index.en.html"),
        ("es", "/folder/", "/folder/index.es.html"),
        ("en", "https://example.com/page.html", "https://example.com/page.html"),
        ("en", "mailto:someone@example.com", "mailto:someone@example.com"),
    ],
)
def process_file_link_rewrites_test(
    tmp_path: Path,
    sample_xsl_transformer: etree.XSLT,
    lang: str,
    link_in: str,
    link_out: str,
) -> None:
    """Check that all link transformations work as expected."""
    xml_path = tmp_path / f"dummy.{lang}.xml"
    xml_path.write_text(
        textwrap.dedent(
            f"""
            <?xml version="1.0" encoding="UTF-8"?>
            <root>
              <a href="{link_in}" test_url="true">link</a>
            </root>
            """,
        ).strip(),
    )
    assert isinstance(sample_xsl_transformer, etree.XSLT)

    result_doc = process_file(Path(), xml_path, sample_xsl_transformer)
    assert isinstance(result_doc, str)
    # We get a list, but as we have only one link in the above sample
    # we only need to care about the first one
    link_node = etree.fromstring(result_doc).xpath("//a[@href and @test_url]")[0]
    assert link_node.get("href") == link_out


def xmllist_processing_test(sample_xsl_transformer: etree.XSLT) -> None:
    """Process something that has an XMLLIST."""
    with TemporaryDirectory() as tmp:
        source = Path(tmp) / "source"
        source.mkdir()

        lang_folder = source / "global" / "languages"
        lang_folder.mkdir(parents=True, exist_ok=True)

        en_lang_file = lang_folder / "en"
        en_lang_file.write_text("English\n")

        action_dir = source / "news"
        action_dir.mkdir()

        action_file = action_dir / "news.en.xhtml"
        action_file.write_text("<html><body>News</body></html>")

        list_file = action_dir / ".news.xmllist"
        list_file.write_text("global/data/sidebar\n")

        sidebar_dir = source / "global" / "data" / "sidebar"
        sidebar_dir.mkdir(parents=True)
        sidebar_en = sidebar_dir / ".sidebar.en.xml"
        sidebar_en.write_text("<sidebar><item>Link</item></sidebar>")

        infile = action_dir / "news.de.xhtml"

        result = process_file(source, infile, sample_xsl_transformer)
        assert result is not None


def missing_translation_fallback_test(sample_xsl_transformer: etree.XSLT) -> None:
    """Process a file where it does not exist in the correct language."""
    with TemporaryDirectory() as tmp:
        source = Path(tmp) / "source"
        source.mkdir()

        lang_folder = source / "global" / "languages"
        lang_folder.mkdir(parents=True, exist_ok=True)

        en_lang_file = lang_folder / "en"
        en_lang_file.write_text("English\n")

        de_lang_file = lang_folder / "de"
        de_lang_file.write_text("Deutsch\n")

        action_dir = source / "news"
        action_dir.mkdir()

        en_file = action_dir / "news.en.xhtml"
        en_file.write_text("<html><body>News</body></html>")

        infile = action_dir / "news.de.xhtml"

        result = process_file(source, infile, sample_xsl_transformer)
        assert result is not None


def detect_invalid_xml_from_transformation_test(mocker: MockFixture) -> None:
    """Check that it detects invalid XML being returned"""
    with TemporaryDirectory() as tmp:
        source = Path(tmp) / "source"
        source.mkdir()
        lang_folder = source / "global" / "languages"
        lang_folder.mkdir(parents=True, exist_ok=True)

        en_lang_file = lang_folder / "en"
        en_lang_file.write_text("English\n")

        action_dir = source / "news"
        action_dir.mkdir()

        infile = action_dir / "news.en.xhtml"
        infile.write_text("<html><body>News</body></html>")

        mock_result = mocker.MagicMock()
        mock_result.xpath.side_effect = AssertionError("bad xml")

        mock_transform = mocker.MagicMock()
        mock_transform.return_value = mock_result

        result = process_file(source, infile, mock_transform)
        assert result == str(mock_result)
