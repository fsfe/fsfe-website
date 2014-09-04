<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template name="translation_list">
    <xsl:element name="div">
      <xsl:attribute name="id">translations</xsl:attribute>
      <xsl:attribute name="class">alert</xsl:attribute>
  
      <xsl:element name="a">
        <xsl:attribute name="class">close</xsl:attribute>
        <xsl:attribute name="data-toggle">collapse</xsl:attribute>
        <xsl:attribute name="data-target">#translations</xsl:attribute>
        <xsl:attribute name="href">#</xsl:attribute>
        ×
      </xsl:element>
  
      <xsl:element name="a">
        <xsl:attribute name="class">contribute-translation</xsl:attribute>
        <xsl:attribute name="href">/contribute/translators/</xsl:attribute>
        <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'translate'" /></xsl:call-template>
      </xsl:element>
  
      <xsl:element name="ul">
        <xsl:for-each select="/buildinfo/trlist/tr">
          <xsl:sort select="@id" />
          <xsl:choose>
            <xsl:when test="@id=/buildinfo/@language">
              <xsl:element name="li">
                <xsl:value-of select="." disable-output-escaping="yes"/>
              </xsl:element>
            </xsl:when>
            <xsl:otherwise>
              <xsl:element name="li">
                <xsl:element name="a">
                  <xsl:attribute name="href"><xsl:value-of select="/buildinfo/@filename"/>.<xsl:value-of select="@id"/>.html</xsl:attribute>
                  <xsl:value-of select="." disable-output-escaping="yes"/>
                </xsl:element>
              </xsl:element>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:element>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
