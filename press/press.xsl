<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../fsfe.xsl" />

  <!-- Fill dynamic content -->
  <xsl:template match="dynamic-content">
    <xsl:element name="dl">
      <xsl:attribute name="id">press-releases</xsl:attribute>

      <!-- Show news except those in the future -->
      <xsl:for-each select="/buildinfo/document/set/news[
          translate(@date, '-', '') &lt;= translate(/buildinfo/@date, '-', '')
        ]">
        <xsl:sort select="@date" order="descending" />

        <!-- A news entry -->
        <xsl:if test="position()&lt;4">
          <xsl:element name="dt">
            <xsl:value-of select="@date"/>
          </xsl:element>
          <xsl:element name="dd">
            <xsl:element name="a">
              <xsl:attribute name="href"><xsl:value-of select="link"/></xsl:attribute>
              <xsl:value-of select="title"/>
            </xsl:element>
          </xsl:element>
        </xsl:if>

      </xsl:for-each>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
