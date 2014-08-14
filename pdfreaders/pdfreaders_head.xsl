<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" encoding="UTF-8" indent="yes" />

  <xsl:template name="pdfreaders-head" match="head">
    <xsl:element name="head">
      <!-- Don't let search engine robots index untranslated pages -->
      <xsl:element name="meta">
        <xsl:attribute name="name">robots</xsl:attribute>
        <xsl:attribute name="content">
          <xsl:choose>
            <xsl:when test="/buildinfo/@language=/buildinfo/document/@language">index, follow</xsl:when>
            <xsl:otherwise>noindex</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </xsl:element>

      <xsl:element name="link">
        <xsl:attribute name="rel">stylesheet</xsl:attribute>
        <xsl:attribute name="media">all</xsl:attribute>
        <xsl:attribute name="href">pdfreaders.css</xsl:attribute>
        <xsl:attribute name="type">text/css</xsl:attribute>
      </xsl:element>

      <xsl:element name="link">
        <xsl:attribute name="rel">icon</xsl:attribute>
        <xsl:attribute name="href">/graphics/fsfe.ico</xsl:attribute>
        <xsl:attribute name="type">image/x-icon</xsl:attribute>
      </xsl:element>

      <link rel="apple-touch-icon" href="/graphics/touch-icon.png" type="image/png" />
      <link rel="apple-touch-icon-precomposed" href="/graphics/touch-icon.png" type="image/png" />

      <xsl:for-each select="/buildinfo/trlist/tr">
        <xsl:sort select="@id"/>
        <xsl:element name="link">
          <xsl:attribute name="type">text/html</xsl:attribute>
          <xsl:attribute name="rel">alternate</xsl:attribute>
          <xsl:attribute name="hreflang"><xsl:value-of select="@id" /></xsl:attribute>
          <xsl:attribute name="lang"><xsl:value-of select="@id" /></xsl:attribute>
          <xsl:attribute name="href"><xsl:value-of select="/buildinfo/@filename"/>.<xsl:value-of select="@id"/>.html</xsl:attribute>
          <xsl:attribute name="title"><xsl:value-of select="."  disable-output-escaping="yes" /></xsl:attribute>
        </xsl:element>
      </xsl:for-each>

      <xsl:apply-templates />
      <!-- xsl:apply-templates select="@*|node()"/ -->
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
