<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../../fsfe.xsl" />

  <xsl:template match="sigtable">
    <xsl:copy-of select="document('sigtable.en.xml')"/>
  </xsl:template>

</xsl:stylesheet>
