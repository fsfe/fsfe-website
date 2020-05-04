<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template name="fsfe_pagefooter">
    <!-- Go to top -->
    <xsl:element name="nav">
      <xsl:attribute name="id">direct-to-top</xsl:attribute>
      <xsl:element name="a">
        <xsl:attribute name="href">#top</xsl:attribute>
        <xsl:call-template name="fsfe-gettext">
          <xsl:with-param name="id" select="'go-top'"/>
        </xsl:call-template>
      </xsl:element>
    </xsl:element>

    <xsl:element name="footer">
      <xsl:attribute name="id">bottom</xsl:attribute>

      <xsl:element name="div">
        <xsl:attribute name="id">page-info</xsl:attribute>

        <xsl:element name="div">

          <!-- Copyright notice -->
          <xsl:element name="p">
            <xsl:text>Copyright © 2001-2020 </xsl:text>
            <xsl:element name="a">
              <xsl:attribute name="href">
                <xsl:value-of select="$urlprefix"/>
                <xsl:text>/</xsl:text>
              </xsl:attribute>
              <xsl:call-template name="fsfe-gettext">
                <xsl:with-param name="id" select="'fsfeurope'"/>
              </xsl:call-template>
            </xsl:element>
            <xsl:text>.</xsl:text>
          </xsl:element>

          <!-- Usage permission -->
          <xsl:element name="p">
            <xsl:call-template name="fsfe-gettext">
              <xsl:with-param name="id" select="'permission'"/>
            </xsl:call-template>
          </xsl:element>

          <!-- Javascript licenses -->
          <xsl:element name="p">
            <xsl:element name="a">
              <xsl:attribute name="href">
                <xsl:value-of select="$urlprefix"/>
                <xsl:text>/about/js-licences.html</xsl:text>
              </xsl:attribute>
              <xsl:attribute name="data-jslicense">1</xsl:attribute>
              <xsl:call-template name="fsfe-gettext">
                <xsl:with-param name="id" select="'js-licences'"/>
              </xsl:call-template>
            </xsl:element>
          </xsl:element>

        </xsl:element>

        <xsl:element name="div">

          <!-- Contact -->
          <xsl:element name="p">
            <xsl:element name="a">
              <xsl:attribute name="href">
                <xsl:value-of select="$urlprefix"/>
                <xsl:text>/contact/contact.html</xsl:text>
              </xsl:attribute>
              <xsl:call-template name="fsfe-gettext">
                <xsl:with-param name="id" select="'contact-us'"/>
              </xsl:call-template>
            </xsl:element>
          </xsl:element>

          <!-- Imprint and other legal stuff -->
          <xsl:element name="p">
            <xsl:element name="a">
              <xsl:attribute name="href">
                <xsl:value-of select="$urlprefix"/>
                <xsl:text>/about/legal/imprint.html</xsl:text>
              </xsl:attribute>
              <xsl:call-template name="fsfe-gettext">
                <xsl:with-param name="id" select="'imprint'"/>
              </xsl:call-template>
            </xsl:element>
            <xsl:text> / </xsl:text>
            <xsl:element name="a">
              <xsl:attribute name="href">
                <xsl:value-of select="$urlprefix"/>
                <xsl:text>/about/legal/imprint.html#id-privacy-policy</xsl:text>
              </xsl:attribute>
              <xsl:call-template name="fsfe-gettext">
                <xsl:with-param name="id" select="'privacy-policy'"/>
              </xsl:call-template>
            </xsl:element>
            <xsl:text> / </xsl:text>
            <xsl:element name="a">
              <xsl:attribute name="href">
                <xsl:value-of select="$urlprefix"/>
                <xsl:text>/about/transparency-commitment.html</xsl:text>
              </xsl:attribute>
              <xsl:call-template name="fsfe-gettext">
                <xsl:with-param name="id" select="'transparency-commitment'"/>
              </xsl:call-template>
            </xsl:element>
          </xsl:element>

          <!-- Sister organisations -->
          <xsl:element name="p">
            <xsl:call-template name="fsfe-gettext">
              <xsl:with-param name="id" select="'fsfnetwork'"/>
            </xsl:call-template>
          </xsl:element>

        </xsl:element>

        <xsl:element name="div">

          <!-- Link to the XHTML source -->
          <xsl:element name="p">
            <xsl:element name="a">
              <xsl:attribute name="rel">nofollow</xsl:attribute>
              <xsl:attribute name="href">
                <xsl:value-of select="$urlprefix"/>
                <xsl:text>/source</xsl:text>
                <xsl:value-of select="/buildinfo/@filename"/>
                <xsl:text>.</xsl:text>
                <xsl:value-of select="/buildinfo/document/@language"/>
                <xsl:text>.xhtml</xsl:text>
              </xsl:attribute>
              <xsl:call-template name="fsfe-gettext">
                <xsl:with-param name="id" select="'source'"/>
              </xsl:call-template>
            </xsl:element>
          </xsl:element>

          <!-- Contribute to website -->
          <xsl:element name="p">
            <xsl:element name="a">
              <xsl:attribute name="href">
                <xsl:value-of select="$urlprefix"/>/contribute/web/
              </xsl:attribute>
              <xsl:call-template name="fsfe-gettext">
                <xsl:with-param name="id" select="'contribute-web'"/>
              </xsl:call-template>
            </xsl:element>
          </xsl:element>

          <!-- Contribute to translations -->
          <xsl:element name="p">
            <xsl:element name="a">
              <xsl:attribute name="href">
                <xsl:value-of select="$urlprefix"/>
                <xsl:text>/contribute/translators/</xsl:text>
              </xsl:attribute>
              <xsl:call-template name="fsfe-gettext">
                <xsl:with-param name="id" select="'translate'"/>
              </xsl:call-template>
            </xsl:element>
          </xsl:element>

          <!-- Appropriate translation notice -->
          <xsl:element name="p">
            <xsl:if test="/buildinfo/document/@language!=/buildinfo/@original">
              <xsl:choose>
                <xsl:when test="/buildinfo/document/translator">
                  <xsl:call-template name="fsfe-gettext">
                    <xsl:with-param name="id" select="'translator1a'"/>
                  </xsl:call-template>
                  <xsl:value-of select="/buildinfo/document/translator"/>
                  <xsl:call-template name="fsfe-gettext">
                    <xsl:with-param name="id" select="'translator1b'"/>
                  </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="fsfe-gettext">
                    <xsl:with-param name="id" select="'translator2'"/>
                  </xsl:call-template>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:call-template name="fsfe-gettext">
                <xsl:with-param name="id" select="'translator3a'"/>
              </xsl:call-template>
              <xsl:element name="a">
                <xsl:attribute name="href">
                  <xsl:value-of select="$urlprefix"/>
                  <xsl:value-of select="/buildinfo/@filename"/>
                  <xsl:text>.en.html</xsl:text>
                </xsl:attribute>
                <xsl:call-template name="fsfe-gettext">
                  <xsl:with-param name="id" select="'translator3b'"/>
                </xsl:call-template>
              </xsl:element>
              <xsl:call-template name="fsfe-gettext">
                <xsl:with-param name="id" select="'translator3c'"/>
              </xsl:call-template>
            </xsl:if>
          </xsl:element>

        </xsl:element>

      </xsl:element>

    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
