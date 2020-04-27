<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../../fsfe.xsl" />
  <xsl:import href="../../tools/xsltsl/tagging.xsl" />

  <xsl:template match="sigtable-orgs">
    <xsl:copy-of select="document('sigtable-orgs.en.xml')"/>
  </xsl:template>

  <xsl:template match="sigtable">
    <xsl:copy-of select="document('sigtable.en.xml')"/>
  </xsl:template>
  
  <xsl:template match="fetch-news">
    <xsl:call-template name="fetch-news">
      <xsl:with-param name="nb-items" select="5"/>
      <xsl:with-param name="sidebar" select="'yes'"/>
    </xsl:call-template>
  </xsl:template>
  
</xsl:stylesheet>
