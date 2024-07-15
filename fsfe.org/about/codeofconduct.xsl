<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../fsfe.xsl" />
  <xsl:import href="../build/xslt/people.xsl" />

  <!-- All people with council tag -->
  <xsl:template match="care-team-list">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'care'" />
    </xsl:call-template>
  </xsl:template>
</xsl:stylesheet>
