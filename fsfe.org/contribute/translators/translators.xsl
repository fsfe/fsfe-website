<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="../../fsfe.xsl"/>
  <xsl:import href="../../../global/xslt/internal/people.xsl"/>
  <xsl:template match="translation-coordinators-list">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'translation-coordinators'"/>
    </xsl:call-template>
  </xsl:template>
</xsl:stylesheet>
