<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" encoding="UTF-8" indent="yes" />

  <!-- The actual HTML tree is in "buildinfo/document" -->
  <xsl:template match="buildinfo/document">
    <xsl:element name="html">
      <xsl:attribute name="lang">
        <xsl:value-of select="/buildinfo/@language"/>
      </xsl:attribute>
      <xsl:attribute name="class">
        <xsl:value-of select="/buildinfo/@language" /> no-js
      </xsl:attribute>
  
      <!-- xsl:apply-templates select="node()"/ -->
      <xsl:apply-templates select="head" />
      <xsl:call-template name="fsfe-body" />
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
