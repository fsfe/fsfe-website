<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:import href="../../../fsfe.xsl" />
  
  <xsl:template match="fetch-news">
    <xsl:call-template name="fetch-news">
      <xsl:with-param name="nb-items" select="2"/>
    </xsl:call-template>
  </xsl:template>
  
</xsl:stylesheet>
