<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="pdfreaders_head.xsl" />
  <xsl:import href="pdfreaders_body.xsl" />
  <!-- xsl:import href="../fsfe.xsl" / -->

  <xsl:output method="html" encoding="utf-8" indent="yes" doctype-system="about:legacy-compat" />

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
  
      <xsl:apply-templates select="head" />
      <xsl:call-template name="pdfreaders-body" />
    </xsl:element>
  </xsl:template>
  
</xsl:stylesheet>
