<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../tools/xsltsl/tagging.xsl" />
  
  <xsl:import href="../fsfe.xsl" />
  <xsl:output method="html" encoding="utf-8" indent="yes" doctype-system="about:legacy-compat" />
  
  <xsl:template match="legal-news">
    <xsl:call-template name="fetch-news">
      <xsl:with-param name="tag" select="'legal-news'" />
    </xsl:call-template>
  </xsl:template>
  
</xsl:stylesheet>
