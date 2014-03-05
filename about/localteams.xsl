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
  <!-- Berlin -->
  <xsl:template match="berlin-members">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'berlin'" />
    </xsl:call-template>
  </xsl:template>
  
  <!-- Paris -->
  <xsl:template match="paris-members">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'paris'" />
    </xsl:call-template>
  </xsl:template>


</xsl:stylesheet>
