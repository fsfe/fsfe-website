<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" encoding="UTF-8" indent="yes" />

  <!--Apply appopriate styles for the whole page -->
  <xsl:if test="/buildinfo/document/body/@class">
    <xsl:attribute name="class">
      <xsl:value-of select="/buildinfo/document/body/@class" />
    </xsl:attribute>
  </xsl:if>
  <xsl:if test="/buildinfo/document/body/@id">
    <xsl:attribute name="id"><xsl:value-of select="/buildinfo/document/body/@id" /></xsl:attribute>
  </xsl:if>
  <xsl:if test="string(/buildinfo/document/@newsdate) and count(/buildinfo/document/@type) = 0">
    <xsl:attribute name="class">
      <xsl:value-of select="/buildinfo/document/body/@class" /> press release</xsl:attribute>
  </xsl:if>
  <xsl:if test="string(/buildinfo/document/@newsdate) and /buildinfo/document/@type = 'newsletter'">
    <xsl:attribute name="class">
      <xsl:value-of select="/buildinfo/document/body/@class" /> newsletter article</xsl:attribute>
  </xsl:if>
</xsl:stylesheet>
