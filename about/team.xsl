<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:import href="../tools/xsltsl/countries.xsl" />
  <xsl:import href="../fsfe.xsl" />
  <xsl:output method="html" encoding="utf-8" indent="yes" doctype-system="about:legacy-compat" />
  
  <!-- 
    For documentation on tagging (e.g. display a people list), take a
    look at the documentation under
      /tools/xsltsl/documentation-tagging.txt
  -->
  
  <!-- Fill dynamic content -->
  <!-- All people with main tag -->
  <xsl:template match="main-members">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'main'" />
    </xsl:call-template>
  </xsl:template>
  
  <!-- All people with council tag -->
  <xsl:template match="council-members">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'council'" />
    </xsl:call-template>
  </xsl:template>
  
  <!-- All people with ga tag -->
  <xsl:template match="ga-members">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'ga'" />
    </xsl:call-template>
  </xsl:template>
  
  <!-- All people with staff tag -->
  <xsl:template match="staff-members">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'staff'" />
    </xsl:call-template>
  </xsl:template>
  
  <!-- All people with coordinator tag -->
  <xsl:template match="coordinator-members">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'coordinator'" />
    </xsl:call-template>
  </xsl:template>
  
  <!-- All people with team tag -->
  <xsl:template match="team-members">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'team'" />
    </xsl:call-template>
  </xsl:template>


</xsl:stylesheet>
