<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../../../fsfe.xsl" />

  <!-- Fill dynamic content -->
  <xsl:template match="dynamic-content">
    <xsl:variable name="type"><xsl:value-of select="@type"/></xsl:variable>
    <xsl:for-each select="/buildinfo/document/set/item[@type=$type]">
      <xsl:element name="li">
        <xsl:apply-templates select="node()"/>
      </xsl:element>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
