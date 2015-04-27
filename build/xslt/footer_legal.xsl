<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template name="footer_legal">
    <xsl:element name="section">
      <xsl:attribute name="id">legal-info</xsl:attribute>
  
      <p>Copyright © 2001-2015 <xsl:element name="a">
        <xsl:attribute name="href"><xsl:value-of select="$linkresources"/>/</xsl:attribute>
        <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'fsfeurope'" /></xsl:call-template>
      </xsl:element>.</p>
      <ul><li>
        <xsl:element name="a">
          <xsl:attribute name="href"><xsl:value-of select="$linkresources"/>/contact/contact.html</xsl:attribute>
          <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'contact-us'" /></xsl:call-template>
        </xsl:element>
      </li><li>
        <xsl:element name="a">
          <xsl:attribute name="href"><xsl:value-of select="$linkresources"/>/about/legal/imprint.html</xsl:attribute>
          <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'imprint'" /></xsl:call-template>
        </xsl:element> / <xsl:element name="a">
          <xsl:attribute name="href"><xsl:value-of select="$linkresources"/>/about/legal/imprint.html#id-privacy-policy</xsl:attribute>
          <xsl:attribute name="class">privacy-policy</xsl:attribute>
          <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'privacy-policy'" /></xsl:call-template>
        </xsl:element>
      </li></ul>
      <p><xsl:call-template name="fsfe-gettext"><xsl:with-param name="id"
            select="'permission'" /></xsl:call-template></p>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
