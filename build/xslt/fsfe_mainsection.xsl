<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:include href="tags.xsl"/>
  <xsl:include href="fsfe_sidebar.xsl"/>

  <xsl:template name="fsfe_mainsection">
    <xsl:element name="main">
      <xsl:element name="div">
        <xsl:attribute name="id">content</xsl:attribute>
        <xsl:if test="/buildinfo/@translation_state='very-outdated' or /buildinfo/@translation_state='untranslated'">
          <xsl:attribute name="lang">
            <xsl:value-of select="/buildinfo/@original"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="/buildinfo/document/body/@microformats">
          <xsl:attribute name="class"><xsl:value-of select="/buildinfo/document/body/@microformats" /></xsl:attribute>
        </xsl:if>

        <!-- Here goes the actual content of the <body> node of the input file -->
        <xsl:apply-templates select="/buildinfo/document/event/body | /buildinfo/document/news/body | /buildinfo/document/body/* | /buildinfo/document/body/node()" />

        <!-- Link to discussion topic on community.fsfe.org -->
        <xsl:if test = "/buildinfo/document/discussion/@href">
        <xsl:element name="p">
            <xsl:attribute name="id">discussion-link</xsl:attribute>
            <xsl:element name="a">
              <xsl:attribute name="class">learn-more</xsl:attribute>
              <xsl:attribute name="href">
                <xsl:value-of select="discussion/@href" />
              </xsl:attribute>
              <xsl:call-template name="fsfe-gettext">
                <xsl:with-param name="id" select="'discuss-article'" />
              </xsl:call-template>
              <xsl:text> </xsl:text>
            </xsl:element>
          </xsl:element>
        </xsl:if>

        <!-- Show tags if this is a news press release or an event -->
        <xsl:if test="(/buildinfo/document/@newsdate or /buildinfo/document/event)
                      and /buildinfo/document/tags/tag[not(@key='front-page')]">
          <xsl:element name="footer">
            <xsl:attribute name="id">tags</xsl:attribute>
            <xsl:element name="h2">
              <xsl:call-template name="fsfe-gettext">
                <xsl:with-param name="id" select="'tags'"/>
              </xsl:call-template>
            </xsl:element>
            <xsl:apply-templates select="/buildinfo/document/tags"/>
          </xsl:element>
        </xsl:if> <!-- /tags -->

      </xsl:element>
      <!--/article#content-->

      <xsl:if test = "/buildinfo/document/sidebar or /buildinfo/document/@newsdate">
          <xsl:call-template name="sidebar"/>
      </xsl:if>

      <xsl:if test = "/buildinfo/document/legal">
        <footer class="copyright notice creativecommons">

          <xsl:choose><xsl:when test = "/buildinfo/document/legal/license">
            <xsl:element name="a">
              <xsl:attribute name="href">
                <xsl:value-of select="/buildinfo/document/legal/license"/>
              </xsl:attribute>
              <xsl:attribute name="rel">license</xsl:attribute>
              <xsl:value-of select="/buildinfo/document/legal/notice"/>
            </xsl:element>
          </xsl:when><xsl:otherwise>
            <span><xsl:value-of select="/buildinfo/document/legal/notice"/></span>
          </xsl:otherwise></xsl:choose>

        </footer>
        <!--/footer-->
      </xsl:if>

      <!--Depreciated: it's here only for "backward compatibility"  cc license way-->
      <xsl:if test = "string(/buildinfo/document/head/meta[@name='cc-license']/@content)">
        <footer id="cc-licenses"><xsl:element name="p">
          <img src="/graphics/cc-logo.png" alt="Creative Commons logo" />
          <xsl:for-each select="/buildinfo/document/head/meta[@name='cc-license']">
            <xsl:value-of select="@content"/> •
          </xsl:for-each>
        </xsl:element></footer>
      </xsl:if>

    </xsl:element>
    <!--/section#main-->
  </xsl:template>

</xsl:stylesheet>
