<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:import href="../../fsfe.xsl" />
  <xsl:output method="html" encoding="utf-8" indent="yes" doctype-system="about:legacy-compat" />

  <!-- In /html/body node, append dynamic content -->
  <xsl:template match="tagged-docs">
    
    <xsl:call-template name="fetch-news">
      <xsl:with-param name="tag" select="'avmgplviolation'" />
      <xsl:with-param name="show-date" select="'yes'" />
      <xsl:with-param name="display-year" select="'yes'" />
      <xsl:with-param name="compact-view" select="'yes'" />
    </xsl:call-template>
    
  </xsl:template>
</xsl:stylesheet>
