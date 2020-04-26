<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../fsfe.xsl" />

  <xsl:template match="taglist">
    <xsl:variable name="section">
      <xsl:value-of select="@section"/>
    </xsl:variable>

    <xsl:element name="ul">
      <xsl:attribute name="class">taglist</xsl:attribute>

      <xsl:for-each select="/buildinfo/document/set/tag[@section=$section]">
        <xsl:sort select="."/>

        <xsl:element name="li">
          <xsl:element name="a">
            <xsl:attribute name="href">
              <xsl:text>tagged-</xsl:text>
              <xsl:value-of select="@key"/>
              <xsl:text>.</xsl:text>
              <xsl:value-of select="/buildinfo/@language"/>
              <xsl:text>.html</xsl:text>
            </xsl:attribute>

            <xsl:value-of select="."/>
            <xsl:text> </xsl:text>
            <xsl:element name="span">
              <xsl:attribute name="class">badge</xsl:attribute>
              <xsl:value-of select="@count"/>
            </xsl:element><!-- /span -->
          </xsl:element><!-- /a -->
        </xsl:element><!-- /li -->
      </xsl:for-each>
    </xsl:element><!-- /ul -->
  </xsl:template>

</xsl:stylesheet>
