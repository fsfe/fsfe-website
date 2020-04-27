<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- For pages used on external web servers, load the CSS from absolute URL -->
  <xsl:variable name="urlprefix">
    <xsl:if test="/buildinfo/document/@external">https://fsfe.org</xsl:if>
  </xsl:variable>

  <xsl:template match="/">
    <xsl:apply-templates select="buildinfo/document"/>
  </xsl:template>

  <!-- The actual HTML tree is in "buildinfo/document" -->
  <xsl:template match="buildinfo/document">
    <xsl:element name="html">
      <xsl:attribute name="lang">
        <xsl:value-of select="/buildinfo/@language"/>
      </xsl:attribute>
      <xsl:attribute name="class">
        <xsl:value-of select="/buildinfo/@language" /> no-js
      </xsl:attribute>
      <xsl:if test="/buildinfo/@language = 'ar' or /buildinfo/@language = 'fa' or /buildinfo/@language = 'he'">
        <xsl:attribute name="dir">rtl</xsl:attribute>
      </xsl:if>

      <xsl:call-template name="page-head" />
      <xsl:call-template name="page-body" />
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
