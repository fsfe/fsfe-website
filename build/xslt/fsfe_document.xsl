<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" encoding="UTF-8" indent="yes" />

  <!-- The top level element of the input file is "buildinfo" -->
  <xsl:template match="/">
    <xsl:apply-templates select="buildinfo/document"/>
  </xsl:template>
  
  <!-- The actual HTML tree is in "buildinfo/document" -->
  <xsl:template match="buildinfo/document">
    <xsl:element name="html">
      <xsl:attribute name="lang">
        <xsl:value-of select="/buildinfo/@language"/>
      </xsl:attribute>
  
      <xsl:attribute name="class"><xsl:value-of select="/buildinfo/@language" /> no-js</xsl:attribute>
  
      <xsl:if test="/buildinfo/@language='ar'">
        <xsl:attribute name="dir">rtl</xsl:attribute>
      </xsl:if>
  
      <!--<xsl:apply-templates select="node()"/>-->
      <xsl:apply-templates select="head" />
      <xsl:call-template name="fsfe-body" />
    </xsl:element>
  </xsl:template>

  <!-- If no template matching <body> is found in the current page's XSL file, this one will be used -->
  <xsl:template match="body" priority="-1">
    <xsl:apply-templates />
  </xsl:template>

</xsl:stylesheet>
