<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../fsfe.xsl" />

  <!-- Fill dynamic content -->
  <xsl:template match="dynamic-content">
    <xsl:for-each select="/buildinfo/document/set/project [@status = 'inactive']">
      <xsl:sort select="@date" order="descending"/>

      <!-- Title -->
      <xsl:element name="h3">
        <xsl:element name="a">
          <xsl:attribute name="href">
            <xsl:value-of select="link"/>
          </xsl:attribute>
          <xsl:value-of select="title"/>
        </xsl:element>
      </xsl:element>

      <!-- Description -->
      <xsl:element name="p">
        <xsl:apply-templates select="description/node()"/>
      </xsl:element>

    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
