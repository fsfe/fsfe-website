<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="text" encoding="UTF-8"/>

  <xsl:template match="h1">
    <xsl:value-of select="."/>
    <!-- Add dashes between multiple h1 headings -->
    <xsl:if test="../@id='fsfe'"> - </xsl:if>
    <xsl:if test="../@id='free_software'"> - </xsl:if>
  </xsl:template>
  
  <xsl:template match="@*|node()" priority="-1">
    <xsl:apply-templates select="@*|node()"/>
  </xsl:template>
</xsl:stylesheet>
