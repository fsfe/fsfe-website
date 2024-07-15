<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../fsfe.xsl" />

  <!-- Fill dynamic content -->
  <xsl:template match="dynamic-content">
    <xsl:variable name="type"><xsl:value-of select="@type"/></xsl:variable>

    <!-- Iterate through all items -->
    <xsl:for-each select="/buildinfo/document/set/item[@type=$type]">
      <xsl:sort select="@date" order="descending"/>
      <xsl:variable name="id"><xsl:value-of select="@id"/></xsl:variable>
      <xsl:variable name="name">
        <xsl:value-of select="/buildinfo/document/set/info[@id=$id]/name"/>
      </xsl:variable>

      <!-- Iterate through all sizes -->
      <xsl:for-each select="available">
        <xsl:element name="tr">
          <xsl:element name="td">
            <xsl:value-of select="$name"/>
          </xsl:element>
          <xsl:element name="td">
            <xsl:value-of select="@size"/>
          </xsl:element>
          <xsl:element name="td">
            <xsl:value-of select="@a"/>
          </xsl:element>
          <xsl:element name="td">
            <xsl:value-of select="@b"/>
          </xsl:element>
          <xsl:if test="$type='hooded'">
            <xsl:element name="td">
              <xsl:value-of select="@c"/>
            </xsl:element>
          </xsl:if>
        </xsl:element>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
