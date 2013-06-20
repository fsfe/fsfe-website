<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../tools/xsltsl/tagging.xsl" />
  
  <xsl:output method="xml" encoding="UTF-8" indent="yes" />
  
  <xsl:template match="/">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="legal-news">
    <xsl:call-template name="fetch-news">
      <xsl:with-param name="tag" select="'legal-news'" />
    </xsl:call-template>
  </xsl:template>
  
  <!-- Do not copy <set> and <text> to output at all -->
  <xsl:template match="/html/set" />
  <xsl:template match="/html/text" />
  
  <!-- For all other nodes, copy verbatim -->
  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>
