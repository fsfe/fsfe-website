<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="../../fsfe.xsl"/>
  <xsl:template match="individual-sigtable">
    <xsl:copy-of select="document('individual-sigtable.en.xml')"/>
  </xsl:template>
</xsl:stylesheet>
