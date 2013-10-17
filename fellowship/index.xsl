<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="default.xsl" />
  <xsl:import href="xsl/quotes.xsl" />

  <xsl:output method="html" encoding="utf-8" indent="yes" doctype-system="about:legacy-compat" />

  <xsl:template match="body">
    <!-- xsl:attribute name="id">fellowship</xsl:attribute -->
      <div id="fellowship">
        <xsl:apply-templates />
      </div>
  </xsl:template>

	<!-- rotating quotes -->
  <xsl:template match="quote-box">
    <xsl:call-template name="quote-box">
      <xsl:with-param name="tag" select="string(@tag)" />
    </xsl:call-template>
  </xsl:template>

<!-- News -->
  <xsl:template match="fellowship-news">
    <xsl:call-template name="fetch-news">
      <xsl:with-param name="tag">front-page</xsl:with-param>
      <xsl:with-param name="nb-items" select="5" />
      <xsl:with-param name="show-date" select="'no'" />
    </xsl:call-template>
    
    <xsl:element name="p">
      <xsl:element name="a">
        <xsl:attribute name="href">/news/news.html</xsl:attribute>
        <xsl:call-template name="more-label" /><xsl:text>…</xsl:text>
      </xsl:element>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
