<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Prefix for links to FSFE's main website -->
  <xsl:variable name="urlprefix">https://fsfe.org</xsl:variable>

  <xsl:include href="../../build/xslt/notifications.xsl" />
  <xsl:include href="../../build/xslt/translation_list.xsl" />
  <xsl:include href="../../build/xslt/fsfe_pagefooter.xsl" />
  <xsl:include href="../../build/xslt/gettext.xsl" />
  <xsl:include href="../../build/xslt/static-elements.xsl" />

  <xsl:template name="page-body">
    <xsl:element name="body">
      <xsl:element name="header">
        <xsl:attribute name="id">top</xsl:attribute>

        <xsl:element name="div">
          <xsl:attribute name="id">logo</xsl:attribute>
          <xsl:element name="a">
            <xsl:attribute name="href">http://pdfreaders.org</xsl:attribute>
            <xsl:element name="img">
              <xsl:attribute name="src">graphics/pdfreaders-logo.png</xsl:attribute>
              <xsl:attribute name="alt">PDFreaders.org</xsl:attribute>
            </xsl:element>
          </xsl:element>
        </xsl:element>

        <xsl:element name="div">
          <xsl:attribute name="id">fsfe-logo</xsl:attribute>
          <xsl:element name="a">
            <xsl:attribute name="href">https://fsfe.org</xsl:attribute>
            <xsl:element name="img">
              <xsl:attribute name="src">//fsfe.org//graphics/logo_transparent.svg</xsl:attribute>
            </xsl:element>
          </xsl:element>
        </xsl:element>

        <xsl:call-template name="translation_list" />

        <xsl:element name="div">
          <xsl:attribute name="id">menu</xsl:attribute>
          <xsl:element name="ul">
            <xsl:element name="li">
              <xsl:element name="a">
                <xsl:attribute name="href">pdfreaders.html</xsl:attribute>
                <xsl:call-template name="fsfe-gettext">
                  <xsl:with-param name="id" select="'pdfreaders-head-readers'" />
                </xsl:call-template>
              </xsl:element>
            </xsl:element>
            <xsl:element name="li">
              <xsl:element name="a">
                <xsl:attribute name="href">os.html</xsl:attribute>
                <xsl:call-template name="fsfe-gettext">
                  <xsl:with-param name="id" select="'pdfreaders-head-standards'" />
                </xsl:call-template>
              </xsl:element>
            </xsl:element>
            <xsl:element name="li">
              <xsl:element name="a">
                <xsl:attribute name="href">graphics.html</xsl:attribute>
                <xsl:call-template name="fsfe-gettext">
                  <xsl:with-param name="id" select="'pdfreaders-head-graphics'" />
                </xsl:call-template>
              </xsl:element>
            </xsl:element>
            <xsl:element name="li">
              <xsl:element name="a">
                <xsl:attribute name="href">about.html</xsl:attribute>
                <xsl:call-template name="fsfe-gettext">
                  <xsl:with-param name="id" select="'pdfreaders-head-about'" />
                </xsl:call-template>
              </xsl:element>
            </xsl:element>
          </xsl:element>
        </xsl:element>

      </xsl:element>

      <xsl:call-template name="notifications" />

      <xsl:element name="main">
        <xsl:apply-templates select="body/node()" />
      </xsl:element>

      <xsl:call-template name="fsfe_pagefooter" />
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
