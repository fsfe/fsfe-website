<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dt="http://xsltsl.org/date-time">
  
  <xsl:import href="../../tools/xsltsl/people.xsl" />
  <xsl:import href="../../fsfe.xsl" />
  <xsl:output method="html" encoding="utf-8" indent="yes" doctype-system="about:legacy-compat" />

  <xsl:template match="translation-coordinators-list">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'translation-coordinators'" />
    </xsl:call-template>
  </xsl:template>

</xsl:stylesheet>
