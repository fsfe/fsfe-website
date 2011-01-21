<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

  <!-- Fill dynamic content -->
  <xsl:template match="dynamic-content">
    <xsl:variable name="type"><xsl:value-of select="@type"/></xsl:variable>
    <xsl:for-each select="/html/set/item[@type=$type]">
      <xsl:element name="li">
        <xsl:apply-templates select="node()"/>
      </xsl:element>
    </xsl:for-each>
  </xsl:template>

  <!-- Do not copy <set> or <text> to output at all -->
  <xsl:template match="set | tags"/>

  <!-- For all other nodes, copy verbatim -->
  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
