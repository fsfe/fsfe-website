<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../fsfe.xsl" />
  <xsl:import href="../build/xslt/people.xsl" />

  <xsl:template match="care-team-list">
    <xsl:copy-of select="document('codeofconduct-careteam.en.xml')"/>
  </xsl:template>
</xsl:stylesheet>
