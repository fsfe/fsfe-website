<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="../../fsfe.xsl"/>
  <xsl:template match="sigtable-orgs">
    <xsl:copy-of select="document('sigtable-orgs.en.xml')"/>
  </xsl:template>
  <xsl:template match="sigtable">
    <xsl:copy-of select="document('sigtable.en.xml')"/>
  </xsl:template>
</xsl:stylesheet>
