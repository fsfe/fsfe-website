import textwrap
from pathlib import Path

import pytest
from fsfe_website_build.lib.process_file import process_file
from lxml import etree


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

    result_doc = process_file(xml_path, sample_xsl_transformer)
    assert isinstance(result_doc, etree._XSLTResultTree)
    # We get a list, but as we have only one link in the above sample
    # we only need to care about the first one
    link_node = result_doc.xpath("//a[@href and @test_url]")[0]
    assert link_node.get("href") == link_out
