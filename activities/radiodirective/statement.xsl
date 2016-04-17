<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:import href="../../tools/xsltsl/tagging.xsl" />
  <xsl:import href="../../fsfe.xsl" />
  
  <xsl:output method="html" encoding="utf-8" indent="yes" doctype-system="about:legacy-compat" />

  <xsl:template match="sigtable">
    <xsl:copy-of select="document('sigtable.txt')"/>
  </xsl:template>
  
  <xsl:template name="sigtable">
    <xsl:call-template name="sigtable">
    </xsl:call-template>
  </xsl:template>
  
</xsl:stylesheet>
