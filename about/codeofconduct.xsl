<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dt="http://xsltsl.org/date-time">
  
  <xsl:import href="../build/xslt/people.xsl" />
  <xsl:import href="../fsfe.xsl" />
  
  <xsl:template match="care-team-list">
    <xsl:copy-of select="document('codeofconduct-careteam.en.xml')"/>
  </xsl:template>

</xsl:stylesheet>
