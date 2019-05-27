<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../../fsfe.xsl" />
  <xsl:output method="html" encoding="utf-8" indent="yes" doctype-system="about:legacy-compat" />

  <!-- Fill dynamic content -->
  <xsl:template match="dynamic-content">
    <xsl:element name="ul">
      <xsl:for-each select="/buildinfo/document/set/document">
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

</xsl:stylesheet>
