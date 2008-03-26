<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

  <!-- Fill dynamic content -->
  <xsl:template match="dynamic-content">
    <xsl:variable name="type"><xsl:value-of select="@type"/></xsl:variable>
    <xsl:variable name="text-online"><xsl:value-of select="text[@id='online']"/></xsl:variable>
    <xsl:variable name="text-pdf"><xsl:value-of select="text[@id='pdf']"/></xsl:variable>
    <xsl:variable name="text-pdf1"><xsl:value-of select="text[@id='pdf1']"/></xsl:variable>
    <xsl:variable name="text-pdf2"><xsl:value-of select="text[@id='pdf2']"/></xsl:variable>

    <xsl:for-each select="/html/set/publication[@type=$type]">
      <xsl:sort select="@id"/>
      <xsl:variable name="id"><xsl:value-of select="@id"/></xsl:variable>

      <!-- Header -->
      <xsl:element name="h3">
        <xsl:choose>
          <xsl:when test="translation[@lang=/html/@lang]!=''">
            <xsl:value-of select="translation[@lang=/html/@lang]"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="translation[@lang='en']"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:element>
      <xsl:element name="ul">

        <!-- Link to online version -->
        <xsl:element name="li">
          <xsl:element name="a">
            <xsl:attribute name="href">
              <xsl:value-of select="$id"/>
              <xsl:text>.html</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="$text-online"/>
          </xsl:element>
        </xsl:element>

        <!-- List of translations -->
        <xsl:element name="li">
          <xsl:value-of select="$text-pdf"/>
          <xsl:element name="ul">
            <xsl:for-each select="translation">
              <xsl:sort select="@lang"/>
              <xsl:element name="li">
                <xsl:value-of select="@langname"/>
                <xsl:text>: </xsl:text>
                <xsl:value-of select="node()"/>
                <xsl:text> [</xsl:text>
                <xsl:element name="a">
                  <xsl:attribute name="href">
                    <xsl:value-of select="$id"/>
                    <xsl:text>.</xsl:text>
                    <xsl:value-of select="@lang"/>
                    <xsl:text>.G.pdf</xsl:text>
                  </xsl:attribute>
                  <xsl:value-of select="$text-pdf1"/>
                </xsl:element>
                <xsl:text>] [</xsl:text>
                <xsl:element name="a">
                  <xsl:attribute name="href">
                    <xsl:value-of select="$id"/>
                    <xsl:text>.</xsl:text>
                    <xsl:value-of select="@lang"/>
                    <xsl:text>.0.pdf</xsl:text>
                  </xsl:attribute>
                  <xsl:value-of select="$text-pdf2"/>
                </xsl:element>
                <xsl:text>]</xsl:text>
              </xsl:element>
            </xsl:for-each>
          </xsl:element>
        </xsl:element>

      </xsl:element>
    </xsl:for-each>
  </xsl:template>
  
  <!-- Do not copy <set> to output at all -->
  <xsl:template match="set" />

  <!-- For all other nodes, copy verbatim -->
  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
