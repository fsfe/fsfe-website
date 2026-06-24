<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="../fsfe.xsl"/>
  <xsl:import href="../../global/xslt/internal/countries.xsl"/>
  <!-- Dropdown list of countries requiring a choice -->
  <xsl:template match="country-list">
    <xsl:call-template name="country-list">
      <xsl:with-param name="class" select="'form-control'"/>
      <xsl:with-param name="required" select="'yes'"/>
    </xsl:call-template>
  </xsl:template>
</xsl:stylesheet>
