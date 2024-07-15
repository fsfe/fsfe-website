<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../../fsfe.xsl" />
  <xsl:import href="../../build/xslt/countries.xsl" />

  <!-- Dropdown list of countries requiring a choice -->
  <!-- when copying this, remember importing the xsl, and editing the .source file -->
  <xsl:template match="country-list">
    <xsl:call-template name="country-list">
      <xsl:with-param name="required" select="'yes'"/>
      <xsl:with-param name="class" select="'form-control'"/>
    </xsl:call-template>
  </xsl:template>
</xsl:stylesheet>
