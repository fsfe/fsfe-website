<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../../fsfe.xsl" />
  <xsl:output method="html" encoding="utf-8" indent="yes" doctype-system="about:legacy-compat" />

  <!-- Fill dynamic content -->
  <xsl:template match="dynamic-content">
    <xsl:variable name="type"><xsl:value-of select="@type"/></xsl:variable>
    <xsl:variable name="text-online"><xsl:value-of select="text[@id='online']"/></xsl:variable>
    <xsl:variable name="text-pdf-F"><xsl:value-of select="text[@id='pdf-F']"/></xsl:variable>
    <xsl:variable name="text-pdf-G"><xsl:value-of select="text[@id='pdf-G']"/></xsl:variable>
    <xsl:variable name="text-pdf-0"><xsl:value-of select="text[@id='pdf-0']"/></xsl:variable>
    <xsl:variable name="text-moreinfo"><xsl:value-of select="text[@id='moreinfo']"/></xsl:variable>

    <xsl:for-each select="/buildinfo/document/set/printable[@type=$type]">
      <xsl:sort select="@id"/>
      <xsl:variable name="id"><xsl:value-of select="@id"/></xsl:variable>

      <!-- Header -->
      <xsl:element name="h3">
        <xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
        <xsl:choose>
          <xsl:when test="translation[@lang=/buildinfo/@language]!=''">
            <xsl:value-of select="translation[@lang=/buildinfo/@language]"/>
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

        <!-- A3 PDF versions -->
        <xsl:if test="$type='folder'">
          <xsl:element name="li">
            <xsl:value-of select="$text-pdf-F"/>
            <xsl:element name="ul">
              <xsl:for-each select="translation">
                <xsl:sort select="@lang"/>
                <xsl:element name="li">
                  <xsl:value-of select="@langname"/>
                  <xsl:text>: </xsl:text>
                  <xsl:element name="a">
                    <xsl:attribute name="href">
                      <xsl:value-of select="$id"/>
                      <xsl:text>.</xsl:text>
                      <xsl:value-of select="@lang"/>
                      <xsl:text>.F.pdf</xsl:text>
                    </xsl:attribute>
                    <xsl:value-of select="node()"/>
                  </xsl:element>
                </xsl:element>
              </xsl:for-each>
            </xsl:element>
          </xsl:element>
        </xsl:if>

        <!-- A4 PDF versions with graphics -->
        <xsl:element name="li">
          <xsl:value-of select="$text-pdf-G"/>
          <xsl:element name="ul">
            <xsl:for-each select="translation">
              <xsl:sort select="@lang"/>
              <xsl:element name="li">
                <xsl:value-of select="@langname"/>
                <xsl:text>: </xsl:text>
                <xsl:element name="a">
                  <xsl:attribute name="href">
                    <xsl:value-of select="$id"/>
                    <xsl:text>.</xsl:text>
                    <xsl:value-of select="@lang"/>
                    <xsl:text>.G.pdf</xsl:text>
                  </xsl:attribute>
                  <xsl:value-of select="node()"/>
                </xsl:element>
              </xsl:element>
            </xsl:for-each>
          </xsl:element>
        </xsl:element>

        <!-- A4 PDF versions without graphics -->
        <xsl:element name="li">
          <xsl:value-of select="$text-pdf-0"/>
          <xsl:element name="ul">
            <xsl:for-each select="translation">
              <xsl:sort select="@lang"/>
              <xsl:element name="li">
                <xsl:value-of select="@langname"/>
                <xsl:text>: </xsl:text>
                <xsl:element name="a">
                  <xsl:attribute name="href">
                    <xsl:value-of select="$id"/>
                    <xsl:text>.</xsl:text>
                    <xsl:value-of select="@lang"/>
                    <xsl:text>.0.pdf</xsl:text>
                  </xsl:attribute>
                  <xsl:value-of select="node()"/>
                </xsl:element>
              </xsl:element>
            </xsl:for-each>
          </xsl:element>
        </xsl:element>

        <!-- Further information -->
        <xsl:if test="$type='leaflet'">
          <xsl:element name="li">
            <xsl:element name="a">
              <xsl:attribute name="href">
                <xsl:value-of select="@moreinfo"/>
              </xsl:attribute>
              <xsl:value-of select="$text-moreinfo"/>
            </xsl:element>
          </xsl:element>
        </xsl:if>

      </xsl:element>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
