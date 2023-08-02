<?xml version="1.0" encoding="UTF-8"?>

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

      </xsl:element>
      <!--/div#masthead-->

      <xsl:element name="nav">
        <xsl:attribute name="id">menu</xsl:attribute>

        <xsl:element name="p">
          <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'go-to'" /></xsl:call-template>
        </xsl:element>

        <xsl:element name="ul">
          <xsl:attribute name="id">direct-links</xsl:attribute>

          <xsl:element name="li">
            <xsl:attribute name="id">direct-to-menu-list</xsl:attribute>
            <xsl:element name="a">
              <xsl:attribute name="href">#menu-list</xsl:attribute>
              <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'menu'" /></xsl:call-template>
            </xsl:element>
          </xsl:element>

          <xsl:element name="li">
            <xsl:attribute name="id">direct-to-content</xsl:attribute>
            <xsl:element name="a">
              <xsl:attribute name="href">#content</xsl:attribute>
              <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'content'" /></xsl:call-template>
            </xsl:element>
          </xsl:element>

          <xsl:element name="li">
            <xsl:attribute name="id">direct-to-page-info</xsl:attribute>
            <xsl:element name="a">
              <xsl:attribute name="href">#page-info</xsl:attribute>
              <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'page-info'" /></xsl:call-template>
            </xsl:element>
          </xsl:element>
        </xsl:element>
        <!--/ul#direct-links-->

        <xsl:if test="not(/buildinfo/document/@external)">
          <xsl:element name="input">
            <xsl:attribute name="type">checkbox</xsl:attribute>
            <xsl:attribute name="id">burger</xsl:attribute>
          </xsl:element>
          <xsl:element name="label">
            <xsl:attribute name="for">burger</xsl:attribute>
             <xsl:element name="i">
               <xsl:attribute name="class">fa fa-bars fa-lg</xsl:attribute>
             </xsl:element>
          </xsl:element>

          <xsl:element name="div">
            <xsl:attribute name="id">menu-list</xsl:attribute>
            <xsl:element name="ul">
              <xsl:element name="li">
                <xsl:attribute name="id">menu-donate</xsl:attribute>
                <xsl:element name="a">
                  <xsl:attribute name="href">
                    <xsl:text>https://my.fsfe.org/donate?referrer=https://fsfe.org</xsl:text>
                    <xsl:value-of select="/buildinfo/@filename"/>
                    <xsl:text>.html</xsl:text>
                  </xsl:attribute>
                  <xsl:element name="i">
                    <xsl:attribute name="class">fa fa-heart-o fa-lg</xsl:attribute>
                  </xsl:element>
                  <xsl:text>&#x2000;</xsl:text>
                  <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'donate'" /></xsl:call-template>
                </xsl:element>
              </xsl:element>
            </xsl:element>
            <!--/ul#menu-list-->

            <xsl:element name="ul">
              <xsl:attribute name="id">menu-sections</xsl:attribute>
              <xsl:element name="li">
                <xsl:element name="a">
                  <xsl:attribute name="href"><xsl:value-of select="$urlprefix"/>/about/about.html</xsl:attribute>
                  <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'fsfe/about'" /></xsl:call-template>
                </xsl:element>
              </xsl:element>
              <xsl:element name="li">
                <xsl:element name="a">
                  <xsl:attribute name="href"><xsl:value-of select="$urlprefix"/>/activities/activities.html</xsl:attribute>
                  <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'fsfe/activities'" /></xsl:call-template>
                </xsl:element>
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
            </xsl:element>
            <!--/ul#menu-sections-->

            <xsl:element name="ul">
              <xsl:element name="li">
                <xsl:element name="a">
                  <xsl:attribute name="href">https://my.fsfe.org/</xsl:attribute>
                  <xsl:element name="i">
                    <xsl:attribute name="class">fa fa-sign-in fa-lg</xsl:attribute>
                  </xsl:element>
                  <xsl:text>&#x2000;</xsl:text>
                  <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'fellowship/login'" /></xsl:call-template>
                </xsl:element>
              </xsl:element>

              <xsl:element name="li">
                <xsl:attribute name="id">menu-translations</xsl:attribute>
                <xsl:element name="a">
                  <xsl:attribute name="href">#translations</xsl:attribute>
                  <xsl:attribute name="data-toggle">collapse</xsl:attribute>
                  <xsl:attribute name="data-target">#translations</xsl:attribute>
                  <xsl:element name="i">
                    <xsl:attribute name="class">fa fa-globe fa-lg</xsl:attribute>
                  </xsl:element>
                  <xsl:text>&#x2000;</xsl:text>
                  <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'change-lang'" /></xsl:call-template>
                </xsl:element>
              </xsl:element>

              <!-- Search box -->
              <xsl:element name="li">
                <xsl:attribute name="id">menu-search-box</xsl:attribute>
                <xsl:element name="form">
                  <xsl:attribute name="method">GET</xsl:attribute>
                  <xsl:attribute name="action"><xsl:value-of select="$urlprefix"/>/search/search.<xsl:value-of select="/buildinfo/@language" />.html</xsl:attribute>
                  <xsl:element name="div">
                    <xsl:attribute name="class">input-group</xsl:attribute>
                    <xsl:element name="div">
                      <xsl:attribute name="class">input-group-btn</xsl:attribute>
                      <xsl:element name="button">
                        <xsl:attribute name="class">btn btn-primary</xsl:attribute>
                        <xsl:attribute name="type">submit</xsl:attribute>
                        <xsl:element name="i">
                          <xsl:attribute name="class">fa fa-search</xsl:attribute>
                        </xsl:element>
                      </xsl:element>
                    </xsl:element>
                    <xsl:element name="input">
                      <xsl:attribute name="placeholder">
                        <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'search/placeholder'" /></xsl:call-template>
                      </xsl:attribute>
                      <xsl:attribute name="type">text</xsl:attribute>
                      <xsl:attribute name="name">q</xsl:attribute>
                      <xsl:attribute name="size">10</xsl:attribute>
                      <xsl:attribute name="class">form-control</xsl:attribute>
                    </xsl:element>
                  </xsl:element>
                </xsl:element>
              </xsl:element>
            </xsl:element>
          </xsl:element>
        </xsl:if>

      </xsl:element>
      <!--/nav#menu-->

    </xsl:element>
    <!--/header#top-->
  </xsl:template>

</xsl:stylesheet>
