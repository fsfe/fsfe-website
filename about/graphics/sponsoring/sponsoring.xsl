<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../../../fsfe.xsl" />

  <xsl:template match="buttons">
    <xsl:for-each select="/buildinfo/document/set/year"> <!-- loop years -->
      <xsl:variable name="year"><xsl:value-of select="@id"/></xsl:variable>

      <xsl:element name="h2">
        <xsl:value-of select="$year" />
        <xsl:text> </xsl:text><xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'donation-buttons'" /></xsl:call-template>
      </xsl:element>
      <xsl:for-each select="button"> <!-- loop donation levels -->
        <xsl:element name="h3">
          <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="@type" /></xsl:call-template>
          <xsl:text> </xsl:text>
          <xsl:value-of select="$year" /></xsl:element>
        <xsl:element name="div">
          <!-- image -->
          <xsl:element name="img">
            <xsl:attribute name="border">0</xsl:attribute>
            <xsl:attribute name="alt">
              <xsl:value-of select="@type" /> <xsl:value-of select="$year" />
            </xsl:attribute>
            <xsl:attribute name="src"><xsl:value-of select="$year" />/<xsl:value-of select="@type" /><xsl:value-of select="$year" />_w_medium.png</xsl:attribute>
          </xsl:element>
          <!-- white background -->
          <xsl:element name="p"><xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'background/white'" /></xsl:call-template>: 
            <xsl:text>[</xsl:text>
            <xsl:element name="a">
              <xsl:attribute name="href"><xsl:value-of select="$year" />/<xsl:value-of select="@type" /><xsl:value-of select="$year" />_w_huge.png</xsl:attribute>
              <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'size/huge'" /></xsl:call-template>
            </xsl:element>
            <xsl:text>], </xsl:text>
            <xsl:text>[</xsl:text>
            <xsl:element name="a">
              <xsl:attribute name="href"><xsl:value-of select="$year" />/<xsl:value-of select="@type" /><xsl:value-of select="$year" />_w_large.png</xsl:attribute>
              <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'size/large'" /></xsl:call-template>
            </xsl:element>
            <xsl:text>], </xsl:text>
            <xsl:text>[</xsl:text>
            <xsl:element name="a">
              <xsl:attribute name="href"><xsl:value-of select="$year" />/<xsl:value-of select="@type" /><xsl:value-of select="$year" />_w_medium.png</xsl:attribute>
              <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'size/medium'" /></xsl:call-template>
            </xsl:element>
            <xsl:text>], </xsl:text>
            <xsl:text>[</xsl:text>
            <xsl:element name="a">
              <xsl:attribute name="href"><xsl:value-of select="$year" />/<xsl:value-of select="@type" /><xsl:value-of select="$year" />_w_small.png</xsl:attribute>
              <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'size/small'" /></xsl:call-template>
            </xsl:element>
            <xsl:text>]</xsl:text>
          </xsl:element>
          <!-- transparent background -->
          <xsl:element name="p"><xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'background/transparent'" /></xsl:call-template>: 
            <xsl:text>[</xsl:text>
            <xsl:element name="a">
              <xsl:attribute name="href"><xsl:value-of select="$year" />/<xsl:value-of select="@type" /><xsl:value-of select="$year" />_t_huge.png</xsl:attribute>
              <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'size/huge'" /></xsl:call-template>
            </xsl:element>
            <xsl:text>], </xsl:text>
            <xsl:text>[</xsl:text>
            <xsl:element name="a">
              <xsl:attribute name="href"><xsl:value-of select="$year" />/<xsl:value-of select="@type" /><xsl:value-of select="$year" />_t_large.png</xsl:attribute>
              <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'size/large'" /></xsl:call-template>
            </xsl:element>
            <xsl:text>], </xsl:text>
            <xsl:text>[</xsl:text>
            <xsl:element name="a">
              <xsl:attribute name="href"><xsl:value-of select="$year" />/<xsl:value-of select="@type" /><xsl:value-of select="$year" />_t_medium.png</xsl:attribute>
              <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'size/medium'" /></xsl:call-template>
            </xsl:element>
            <xsl:text>], </xsl:text>
            <xsl:text>[</xsl:text>
            <xsl:element name="a">
              <xsl:attribute name="href"><xsl:value-of select="$year" />/<xsl:value-of select="@type" /><xsl:value-of select="$year" />_t_small.png</xsl:attribute>
              <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'size/small'" /></xsl:call-template>
            </xsl:element>
            <xsl:text>]</xsl:text>
          </xsl:element>
        </xsl:element>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
