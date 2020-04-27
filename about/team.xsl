<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../fsfe.xsl" />
  <xsl:import href="../build/xslt/people.xsl" />

  <!-- Fill dynamic content -->

  <!-- All people with council tag -->
  <xsl:template match="council-members">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'council'" />
    </xsl:call-template>
  </xsl:template>

  <!-- All people from council, ga or core -->
  <xsl:template match="core-members">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'council,ga,core'" />
      <!-- class "filter" is used to limit filter-teams.js to this div -->
      <xsl:with-param name="extraclass" select="'filter'" />
    </xsl:call-template>
  </xsl:template>

</xsl:stylesheet>
