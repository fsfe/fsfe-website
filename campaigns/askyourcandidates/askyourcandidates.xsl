<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:import href="../../tools/xsltsl/tagging.xsl" />
  
  <xsl:output method="xml" encoding="UTF-8" indent="yes" />
  
  
  <xsl:template match="fetch-news">
    <xsl:call-template name="fetch-news">
      <xsl:with-param name="tag" select="'ayc'"/>
      <xsl:with-param name="nb-items" select="5"/>
    </xsl:call-template>
  </xsl:template>
  
  
  <!-- Do not copy <set> and <text> to output at all -->
  <xsl:template match="/html/set" />
  <xsl:template match="/html/text" />
  
  <!-- How to show a link -->
  <xsl:template match="/html/set/news/link">
    <xsl:element name="a">
      <xsl:attribute name="href">
        <xsl:value-of select="text()" />
      </xsl:attribute>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="/html/text[@id='more']" />
      <xsl:text>]</xsl:text>
    </xsl:element>
  </xsl:template>

  <!-- For all other nodes, copy verbatim -->
  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>
