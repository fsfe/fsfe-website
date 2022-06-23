<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />
  <xsl:template match="/itemset">
    <xsl:for-each select="item">
      <xsl:variable name="prefix"><xsl:value-of select="@id"/></xsl:variable>
      <xsl:variable name="price"><xsl:value-of select="@price"/></xsl:variable>
      <xsl:for-each select="available">
        <xsl:element name="item">
          <xsl:attribute name="id"><xsl:value-of select="$prefix"/><xsl:text>_</xsl:text><xsl:value-of select="@size"/></xsl:attribute>
          <xsl:attribute name="price"><xsl:value-of select="$price"/></xsl:attribute>
        </xsl:element>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
