<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template name="fsfe_pageheader">
    <xsl:element name="header">
      <xsl:attribute name="id">top</xsl:attribute>
  
      <xsl:element name="nav">
        <xsl:attribute name="id">menu</xsl:attribute>
        <xsl:attribute name="role">navigation</xsl:attribute>
  
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

          <xsl:element name="a">
              <xsl:attribute name="href">https://my.fsfe.org/support</xsl:attribute>
              <xsl:attribute name="id">direct-to-join</xsl:attribute>
              <xsl:element name="i">
                <xsl:attribute name="class">fa fa-user-plus fa-lg</xsl:attribute>
              </xsl:element>
              <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'support/become'" /></xsl:call-template>
          </xsl:element>

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
  
          <xsl:element name="a">
            <xsl:attribute name="href">/</xsl:attribute>
            <xsl:attribute name="id">direct-to-home</xsl:attribute>
            <xsl:element name="i">
              <xsl:attribute name="class">fa fa-home fa-lg</xsl:attribute>
            </xsl:element>
            <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'fsfeurope'" /></xsl:call-template>
          </xsl:element>
  
        </xsl:element>
        <!--/div#direct-links-->
  
        <xsl:element name="ul">
          <xsl:attribute name="id">menu-list</xsl:attribute>
          <xsl:element name="li">
            <xsl:element name="a">
              <xsl:attribute name="href">/about/about.html</xsl:attribute>
              <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'fsfe/about'" /></xsl:call-template>
            </xsl:element>
          </xsl:element>
          <xsl:element name="li">
            <xsl:element name="a">
              <xsl:attribute name="href">/work.html</xsl:attribute>
              <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'fsfe/projects'" /></xsl:call-template>
            </xsl:element>
          </xsl:element>
          <xsl:element name="li">
            <xsl:element name="a">
              <xsl:attribute name="href">/campaigns/campaigns.html</xsl:attribute>
              <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'fsfe/campaigns'" /></xsl:call-template>
            </xsl:element>
          </xsl:element>
          <xsl:element name="li">
            <xsl:element name="a">
              <xsl:attribute name="href">/contribute/contribute.html</xsl:attribute>
              <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'fsfe/help'" /></xsl:call-template>
            </xsl:element>
          </xsl:element>
          <xsl:element name="li">
            <xsl:element name="a">
              <xsl:attribute name="href">/press/press.html</xsl:attribute>
              <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'fsfe/press'" /></xsl:call-template>
            </xsl:element>
          </xsl:element>
        </xsl:element>
        <!--/ul#menu-list-->
  
        <xsl:element name="div">
          <xsl:attribute name="id">search</xsl:attribute>
  
            <xsl:element name="form">
              <xsl:attribute name="method">get</xsl:attribute>
              <xsl:attribute name="action">//fsfe.org/cgi-bin/search.cgi</xsl:attribute>
  
              <xsl:element name="input">
                <xsl:attribute name="type">hidden</xsl:attribute>
                <xsl:attribute name="name">l</xsl:attribute>
                <xsl:attribute name="value"><xsl:value-of select="/buildinfo/@language"/></xsl:attribute>
              </xsl:element>
  
              <xsl:element name="p">
                <xsl:element name="input">
                  <xsl:attribute name="type">image</xsl:attribute>
                  <xsl:attribute name="src">/graphics/icons/search-button.png</xsl:attribute>
                  <xsl:attribute name="alt">
                    <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'search'" /></xsl:call-template>
                  </xsl:attribute>
                </xsl:element>
  
                <xsl:element name="input">
                  <xsl:attribute name="type">text</xsl:attribute>
                  <xsl:attribute name="name">q</xsl:attribute>
                  <xsl:attribute name="placeholder">
                    <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'search'" /></xsl:call-template>
                  </xsl:attribute>
                </xsl:element>
              </xsl:element>

            </xsl:element><!--/form-->
        </xsl:element><!--/div#search-->
  
      </xsl:element>
      <!--/nav#menu-->
  
  
      <xsl:element name="div">
        <xsl:attribute name="id">masthead</xsl:attribute>
  
        <xsl:element name="div">
          <xsl:attribute name="id">link-home</xsl:attribute>
          <xsl:element name="a">
            <xsl:attribute name="href"><xsl:value-of select="$urlprefix"/>/</xsl:attribute>
            <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'rootpage'" /></xsl:call-template>
          </xsl:element>
        </xsl:element>
        <!--/div#link-home-->
  
        <xsl:element name="div">
          <xsl:attribute name="id">logo</xsl:attribute>
          <xsl:element name="span">
                <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'fsfeurope'" /></xsl:call-template>
            </xsl:element>
        </xsl:element>
        <!--/div#logo-->
  
        <xsl:element name="div">
          <xsl:attribute name="id">motto</xsl:attribute>
          <xsl:element name="span"><xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'motto-fsfs'" /></xsl:call-template></xsl:element>
          <!-- TODO different motto content depending on planet (use 'motto-planet'), wiki (use 'motto-wiki'), or fsfe dot org, page, so we may have to change this to another way-->
        </xsl:element>
        <!--/div#motto-->
  
      </xsl:element>
      <!--/div#masthead-->
  
    </xsl:element>
    <!--/header#top-->
  </xsl:template>

</xsl:stylesheet>
