<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template name="fsfe_pageheader">
    <xsl:element name="header">
      <xsl:attribute name="id">top</xsl:attribute>

      <xsl:element name="div">
        <xsl:attribute name="id">masthead</xsl:attribute>

        <xsl:element name="a">
          <xsl:attribute name="id">logo</xsl:attribute>
          <xsl:attribute name="href"><xsl:value-of select="$urlprefix"/>/</xsl:attribute>
          <xsl:element name="span">
            <xsl:call-template name="fsfe-gettext">
              <xsl:with-param name="id" select="'fsfeurope'"/>
            </xsl:call-template>
          </xsl:element>
        </xsl:element>
        <!--/a#logo-->

        <xsl:element name="div">
          <xsl:attribute name="id">motto</xsl:attribute>
          <xsl:text>empowering users </xsl:text>
          <xsl:element name="br"/>
          <xsl:text>to control technology</xsl:text>
        </xsl:element>
        <!--/div#motto-->

      </xsl:element>
      <!--/div#masthead-->

      <xsl:element name="nav">
        <xsl:attribute name="id">menu</xsl:attribute>

        <xsl:element name="div">
          <xsl:attribute name="id">direct-links</xsl:attribute>

          <xsl:element name="span">
            <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'go-to'" /></xsl:call-template>
          </xsl:element>

          <xsl:element name="a">
            <xsl:attribute name="href">#menu-list</xsl:attribute>
            <xsl:attribute name="id">direct-to-menu-list</xsl:attribute>
            <xsl:element name="i">
              <xsl:attribute name="class">fa fa-bars fa-lg</xsl:attribute>
            </xsl:element>
            <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'menu'" /></xsl:call-template>
          </xsl:element>

          <xsl:element name="a">
            <xsl:attribute name="href">#content</xsl:attribute>
            <xsl:attribute name="id">direct-to-content</xsl:attribute>
            <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'content'" /></xsl:call-template>
          </xsl:element>

          <xsl:element name="a">
            <xsl:attribute name="href">#full-menu</xsl:attribute>
            <xsl:attribute name="id">direct-to-full-menu</xsl:attribute>
            <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'sitemap'" /></xsl:call-template>
          </xsl:element>

          <xsl:element name="a">
            <xsl:attribute name="href">#source</xsl:attribute>
            <xsl:attribute name="id">direct-to-source</xsl:attribute>
            <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'page-info'" /></xsl:call-template>
          </xsl:element>

          <xsl:if test="not(/buildinfo/document/@external)">
            <xsl:element name="a">
              <xsl:attribute name="href">https://my.fsfe.org/</xsl:attribute>
              <xsl:attribute name="id">direct-to-login</xsl:attribute>
              <xsl:element name="i">
                <xsl:attribute name="class">fa fa-sign-in fa-lg</xsl:attribute>
              </xsl:element>
              <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'fellowship/login'" /></xsl:call-template>
            </xsl:element>

            <xsl:element name="a">
              <xsl:attribute name="href">#translations</xsl:attribute>
              <xsl:attribute name="id">direct-to-translations</xsl:attribute>
              <xsl:attribute name="data-toggle">collapse</xsl:attribute>
              <xsl:attribute name="data-target">#translations</xsl:attribute>
              <xsl:element name="i">
                <xsl:attribute name="class">fa fa-globe fa-lg</xsl:attribute>
              </xsl:element>
              <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'change-lang'" /></xsl:call-template>
            </xsl:element>
          </xsl:if>

        </xsl:element>
        <!--/div#direct-links-->

        <xsl:if test="not(/buildinfo/document/@external)">
          <xsl:element name="ul">
            <xsl:attribute name="id">menu-list</xsl:attribute>
            <xsl:element name="li">
              <xsl:element name="a">
                <xsl:attribute name="href"><xsl:value-of select="$urlprefix"/>/about/about.html</xsl:attribute>
                <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'fsfe/about'" /></xsl:call-template>
              </xsl:element>
            </xsl:element>
            <xsl:element name="li">
              <xsl:element name="a">
                <xsl:attribute name="href"><xsl:value-of select="$urlprefix"/>/work.html</xsl:attribute>
                <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'fsfe/projects'" /></xsl:call-template>
              </xsl:element>
            </xsl:element>
            <xsl:element name="li">
              <xsl:element name="a">
                <xsl:attribute name="href"><xsl:value-of select="$urlprefix"/>/campaigns/campaigns.html</xsl:attribute>
                <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'fsfe/campaigns'" /></xsl:call-template>
              </xsl:element>
            </xsl:element>
            <xsl:element name="li">
              <xsl:attribute name="class">hidden-lg</xsl:attribute>
              <xsl:attribute name="style">display: block;</xsl:attribute>
            </xsl:element>
            <xsl:element name="li">
              <xsl:element name="a">
                <xsl:attribute name="href"><xsl:value-of select="$urlprefix"/>/contribute/contribute.html</xsl:attribute>
                <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'fsfe/help'" /></xsl:call-template>
              </xsl:element>
            </xsl:element>
            <xsl:element name="li">
              <xsl:element name="a">
                <xsl:attribute name="href"><xsl:value-of select="$urlprefix"/>/press/press.html</xsl:attribute>
                <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'fsfe/press'" /></xsl:call-template>
              </xsl:element>
            </xsl:element>
            <xsl:element name="li">
              <xsl:element name="a">
                <xsl:attribute name="href">https://my.fsfe.org/donate</xsl:attribute>
                <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'donate'" /></xsl:call-template>
              </xsl:element>
            </xsl:element>
          </xsl:element>
          <!--/ul#menu-list-->
        </xsl:if>

      </xsl:element>
      <!--/nav#menu-->

    </xsl:element>
    <!--/header#top-->
  </xsl:template>

</xsl:stylesheet>
