<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" encoding="UTF-8" indent="yes" />

  <xsl:element name="nav">
    <xsl:attribute name="id">full-menu</xsl:attribute>

    <xsl:element name="a">
      <xsl:attribute name="href">#top</xsl:attribute>
      <xsl:attribute name="id">direct-to-top</xsl:attribute>
      <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'go-top'" /></xsl:call-template>
      <!--FIXME translate that-->
    </xsl:element>

    <xsl:element name="ul">
      <xsl:attribute name="id">full-menu-list</xsl:attribute>
      <!-- FSFE portal menu -->
      <xsl:element name="li">
        <xsl:attribute name="class">fsfe</xsl:attribute>
        <xsl:element name="a">
          <xsl:attribute name="href">/</xsl:attribute>
            <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'fsfeurope'" /></xsl:call-template>
        </xsl:element>

        <xsl:element name="ul">
          <xsl:variable name="menu"><xsl:value-of select="@id" /></xsl:variable>
                  <xsl:for-each select="/buildinfo/menuset/menu[@parent='fsfe']">
                    <!--<xsl:sort select="@id"/>-->
                    <xsl:sort select="@priority" />
                    <xsl:variable name="id"><xsl:value-of select="@id" /></xsl:variable>
                    <xsl:element name="li">
                      <xsl:choose>
                        <xsl:when test="not(string(.))">
                          <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="$id" /></xsl:call-template>
                        </xsl:when>
                        <xsl:when test=". = concat(/buildinfo/@filename ,'.html')">
                          <xsl:element name="span">
                          <xsl:attribute name="id">selected</xsl:attribute>
                            <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="$id" /></xsl:call-template>
                          </xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:element name="a">
                            <xsl:attribute name="href"><xsl:value-of select="." /></xsl:attribute>
                            <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="$id" /></xsl:call-template>
                          </xsl:element>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:element> <!-- /li -->
                  </xsl:for-each>
        </xsl:element>
        <!--/ul-->
      </xsl:element>
      <!--/li-->

      <!-- Support portal menu item -->
      <xsl:element name="li">
        <xsl:attribute name="class">support</xsl:attribute>
        <xsl:element name="a">
          <xsl:attribute name="href">/donate/donate.html#ref-fullmenu</xsl:attribute>
          <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'support/donate'" /></xsl:call-template>
        </xsl:element>

        <xsl:element name="ul">
          <xsl:variable name="menu"><xsl:value-of select="@id" /></xsl:variable>
          <xsl:for-each select="/buildinfo/menuset/menu[@parent='support']">
            <!--<xsl:sort select="@id"/>-->
            <xsl:sort select="@priority" />
            <xsl:variable name="id"><xsl:value-of select="@id" /></xsl:variable>
            <xsl:element name="li">
              <xsl:choose>
                <xsl:when test="not(string(.))">
                  <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="$id" /></xsl:call-template>
                </xsl:when>
                <xsl:when test=". = concat(/buildinfo/@filename ,'.html')">
                  <xsl:element name="span">
                  <xsl:attribute name="id">selected</xsl:attribute>
                    <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="$id" /></xsl:call-template>
                  </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:element name="a">
                    <xsl:attribute name="href"><xsl:value-of select="." /></xsl:attribute>
                    <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="$id" /></xsl:call-template>
                  </xsl:element>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:element> <!-- /li -->
          </xsl:for-each>
        </xsl:element>
        <!--/ul-->

        <!-- Fellowship portal menu -->
        <xsl:element name="ul">
          <xsl:attribute name="class">fellowship</xsl:attribute>
          <xsl:element name="li">
            <xsl:attribute name="class">fellowship</xsl:attribute>
            <xsl:element name="a">
              <xsl:attribute name="href">/fellowship/</xsl:attribute>
              <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'fellowship/fellowship'" /></xsl:call-template>
            </xsl:element>
            <xsl:element name="ul">
              <xsl:variable name="menu"><xsl:value-of select="@id" /></xsl:variable>
              <xsl:for-each select="/buildinfo/menuset/menu[@parent='fellowship']">
                <!--<xsl:sort select="@id"/>-->
                <xsl:sort select="@priority" />
                <xsl:variable name="id"><xsl:value-of select="@id" /></xsl:variable>
                <xsl:element name="li">
                  <xsl:choose>
                    <xsl:when test="not(string(.))">
                      <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="$id" /></xsl:call-template>
                    </xsl:when>
                    <xsl:when test=". = concat(/buildinfo/@filename ,'.html')">
                      <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="$id" /></xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:element name="a">
                        <xsl:attribute name="href"><xsl:value-of select="." /></xsl:attribute>
                        <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="$id" /></xsl:call-template>
                      </xsl:element>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:element> <!-- /li -->
              </xsl:for-each>
            </xsl:element><!-- end ul -->
          </xsl:element>
        </xsl:element>
      </xsl:element> <!-- /li -->

      <!-- campaigns -->
      <xsl:element name="li">
        <xsl:attribute name="class">campaigns</xsl:attribute>
        <xsl:element name="a">
          <xsl:attribute name="href">/campaigns/campaigns.html</xsl:attribute>
          <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'fsfe/campaigns'" /></xsl:call-template>
        </xsl:element>

        <xsl:element name="ul">
          <xsl:variable name="menu"><xsl:value-of select="@id" /></xsl:variable>
                  <xsl:for-each select="/buildinfo/menuset/menu[@parent='campaigns']">
                    <!--<xsl:sort select="@id"/>-->
                    <xsl:sort select="@priority" />
                    <xsl:variable name="id"><xsl:value-of select="@id" /></xsl:variable>
                    <xsl:element name="li">
                      <xsl:choose>
                        <xsl:when test="not(string(.))">
                          <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="$id" /></xsl:call-template>
                        </xsl:when>
                        <xsl:when test=". = concat(/buildinfo/@filename ,'.html')">
                          <xsl:element name="span">
                          <xsl:attribute name="id">selected</xsl:attribute>
                            <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="$id" /></xsl:call-template>
                          </xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:element name="a">
                            <xsl:attribute name="href"><xsl:value-of select="." /></xsl:attribute>
                            <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="$id" /></xsl:call-template>
                          </xsl:element>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:element> <!-- /li -->
                  </xsl:for-each>
        </xsl:element>
        <!--/ul-->
      </xsl:element> <!-- /li -->

      <!-- Planet portal menu -->
      <xsl:element name="li">
        <xsl:attribute name="class">planet</xsl:attribute>
        <xsl:element name="a">
            <xsl:attribute name="href">/news/</xsl:attribute>
            <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'news/news'" /></xsl:call-template>
        </xsl:element>
        <!-- causes validation errors, needs li to pass validator?
        <xsl:element name="ul">
        </xsl:element>-->

        <xsl:element name="ul">
          <xsl:variable name="menu"><xsl:value-of select="@id" /></xsl:variable>
                  <xsl:for-each select="/buildinfo/menuset/menu[@parent='news']">
                    <!--<xsl:sort select="@id"/>-->
                    <xsl:sort select="@priority" />
                    <xsl:variable name="id"><xsl:value-of select="@id" /></xsl:variable>
                    <xsl:element name="li">
                      <xsl:choose>
                        <xsl:when test="not(string(.))">
                          <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="$id" /></xsl:call-template>
                        </xsl:when>
                        <xsl:when test=". = concat(/buildinfo/@filename ,'.html')">
                          <xsl:element name="span">
                          <xsl:attribute name="id">selected</xsl:attribute>
                            <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="$id" /></xsl:call-template>
                          </xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:element name="a">
                            <xsl:attribute name="href"><xsl:value-of select="." /></xsl:attribute>
                            <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="$id" /></xsl:call-template>
                          </xsl:element>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:element> <!-- /li -->
                  </xsl:for-each>
        </xsl:element>
        <!--/ul-->
      </xsl:element>

      <!-- Legal team portal menu -->
      <xsl:element name="li">
        <xsl:attribute name="class">ftf</xsl:attribute>
        <xsl:element name="a">
            <xsl:attribute name="href">/legal/</xsl:attribute>
            <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'ftf/legal'" /></xsl:call-template>
        </xsl:element>
        <!-- causes validation errors, needs li to pass validator?
        <xsl:element name="ul">
        </xsl:element>-->

        <xsl:element name="ul">
          <xsl:variable name="menu"><xsl:value-of select="@id" /></xsl:variable>
                  <xsl:for-each select="/buildinfo/menuset/menu[@parent='ftf']">
                    <!--<xsl:sort select="@id"/>-->
                    <xsl:sort select="@priority" />
                    <xsl:variable name="id"><xsl:value-of select="@id" /></xsl:variable>
                    <xsl:element name="li">
                      <xsl:choose>
                        <xsl:when test="not(string(.))">
                          <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="$id" /></xsl:call-template>
                        </xsl:when>
                        <xsl:when test=". = concat(/buildinfo/@filename ,'.html')">
                          <xsl:element name="span">
                          <xsl:attribute name="id">selected</xsl:attribute>
                            <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="$id" /></xsl:call-template>
                          </xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:element name="a">
                            <xsl:attribute name="href"><xsl:value-of select="." /></xsl:attribute>
                            <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="$id" /></xsl:call-template>
                          </xsl:element>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:element> <!-- /li -->
                  </xsl:for-each>
        </xsl:element>
        <!--/ul-->
      </xsl:element>

      <!-- free software section portal menu -->
      <xsl:element name="li">
        <xsl:attribute name="class">fs</xsl:attribute>
        <xsl:element name="a">
            <xsl:attribute name="href">/freesoftware/</xsl:attribute>
            <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'fs/fs'" /></xsl:call-template>
        </xsl:element>
        <!-- causes validation errors, needs li to pass validator?
        <xsl:element name="ul">
        </xsl:element>-->

        <xsl:element name="ul">
          <xsl:variable name="menu"><xsl:value-of select="@id" /></xsl:variable>
                  <xsl:for-each select="/buildinfo/menuset/menu[@parent='fs']">
                    <!--<xsl:sort select="@id"/>-->
                    <xsl:sort select="@priority" />
                    <xsl:variable name="id"><xsl:value-of select="@id" /></xsl:variable>
                    <xsl:element name="li">
                      <xsl:choose>
                        <xsl:when test="not(string(.))">
                          <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="$id" /></xsl:call-template>
                        </xsl:when>
                        <xsl:when test=". = concat(/buildinfo/@filename ,'.html')">
                          <xsl:element name="span">
                          <xsl:attribute name="id">selected</xsl:attribute>
                            <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="$id" /></xsl:call-template>
                          </xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:element name="a">
                            <xsl:attribute name="href"><xsl:value-of select="." /></xsl:attribute>
                            <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="$id" /></xsl:call-template>
                          </xsl:element>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:element> <!-- /li -->
                  </xsl:for-each>
        </xsl:element>
        <!--/ul-->
      </xsl:element>

    </xsl:element>
    <!--/ul#menu-list-->
  </xsl:element>
  <!--/nav#full-menu-->

</xsl:stylesheet>
