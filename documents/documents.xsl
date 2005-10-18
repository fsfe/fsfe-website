<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" encoding="ISO-8859-1" indent="yes" />

  <!-- Fill dynamic content -->
  <xsl:template match="dynamic-content">
    <xsl:variable name="type"><xsl:value-of select="@type" /></xsl:variable>
    <xsl:element name="ul">
      <xsl:for-each select="/html/set/document [@type = $type]">
        <xsl:sort select="@date" order="descending" />
        <xsl:element name="li">
          <xsl:element name="p">

            <!-- Title as link -->
            <xsl:element name="b">
              <xsl:element name="a">
                <xsl:attribute name="href">
                  <xsl:value-of select="link" />
                </xsl:attribute>
                <xsl:value-of select="title" />
              </xsl:element>
            </xsl:element>

            <!-- Date -->
            <xsl:text> (</xsl:text>
            <xsl:value-of select="@date" />
            <xsl:text>)</xsl:text>

            <!-- Line break -->
            <xsl:element name="br" />

            <!-- Description text -->
            <xsl:apply-templates select="description/node()" />

          </xsl:element>
        </xsl:element>
      </xsl:for-each>
    </xsl:element>
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
