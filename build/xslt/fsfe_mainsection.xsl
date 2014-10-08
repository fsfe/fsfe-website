<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template name="fsfe_mainsection">
    <xsl:element name="section">
      <xsl:attribute name="id">main</xsl:attribute>
      <xsl:attribute name="role">main</xsl:attribute>
  
      <xsl:element name="article">
        <xsl:attribute name="id">content</xsl:attribute>
        <xsl:if test="/buildinfo/document/body/@microformats">
          <xsl:attribute name="class"><xsl:value-of select="/buildinfo/document/body/@microformats" /></xsl:attribute>
        </xsl:if>
  
        <!-- Here goes the actual content of the <body> node of the input file -->
        <xsl:apply-templates select="body | /buildinfo/document/event/body | /buildinfo/document/news/body" />
      
        <!-- Show tags if this is a news press release or an event -->
        <xsl:if test="/buildinfo/document/@newsdate or /buildinfo/document/event">
          <xsl:if test="count(/buildinfo/document/tags/tag[. != 'front-page' and . != 'newsletter']) > 0">
            <footer class="tags">
              <span id="tags">
                <xsl:call-template name="fsfe-gettext">
                  <xsl:with-param name="id" select="'tags'" />
                </xsl:call-template>
              </span>

              <xsl:for-each select="/buildinfo/document/tags/tag">
                <a href="/tags/tagged.html#id-{.}" class="tag tag-{.} p-category">
                  <xsl:value-of select="."/>
                </a>
              </xsl:for-each>
            </footer>
          </xsl:if>
        </xsl:if>
  
      </xsl:element>
      <!--/article#content-->
  
      <xsl:if test = "/buildinfo/document/sidebar or /buildinfo/document/@newsdate">
        <xsl:element name="aside">
          <xsl:attribute name="id">sidebar</xsl:attribute>
  
          <xsl:if test="string(/buildinfo/document/@newsdate) and /buildinfo/document/@type = 'newsletter'">
            <xsl:element name="h3">
              <xsl:call-template name="fsfe-gettext">
                <xsl:with-param name="id" select="'receive-newsletter'" />
              </xsl:call-template>
            </xsl:element>
            <xsl:call-template name="subscribe-nl" />
            <ul>
              <li><a href="/news/newsletter.html">
                <xsl:call-template name="fsfe-gettext">
                    <xsl:with-param name="id" select="'news/nl'" />
                </xsl:call-template>
              </a></li>
              <li>
                  <a href="/news/news.html">
                    <xsl:call-template name="fsfe-gettext">
                        <xsl:with-param name="id" select="'news/news'" />
                    </xsl:call-template>
                  </a>
              </li>
              <li><a href="/events/events.html">
                <xsl:call-template name="fsfe-gettext">
                    <xsl:with-param name="id" select="'news/events'" />
                </xsl:call-template>
              </a></li>
              <li><a href="//planet.fsfe.org">
                <xsl:call-template name="fsfe-gettext">
                    <xsl:with-param name="id" select="'news/planet'" />
                </xsl:call-template>
              </a></li>
              <li><a href="/contact/community.html">
                <xsl:call-template name="fsfe-gettext">
                    <xsl:with-param name="id" select="'community/discuss'" />
                </xsl:call-template>
              </a></li>
            </ul>
          </xsl:if>
  
          <xsl:if test="string(/buildinfo/document/@newsdate) and count(/buildinfo/document/@type) = 0">
              <h3>
                <xsl:call-template name="fsfe-gettext">
                    <xsl:with-param name="id" select="'fsfe/press'" />
                </xsl:call-template>
              </h3>
              <ul>
                <li>
                  <a href="/press/press.html">
                    <xsl:call-template name="fsfe-gettext">
                        <xsl:with-param name="id" select="'news/press'" />
                    </xsl:call-template>
                  </a>
                </li>
                <li>
                  <a href="/news/news.html">
                    <xsl:call-template name="fsfe-gettext">
                        <xsl:with-param name="id" select="'news/news'" />
                    </xsl:call-template>
                  </a>
                </li>
                <li>
                  <a href="/about/basics/freesoftware.html">
                    <xsl:call-template name="fsfe-gettext">
                      <xsl:with-param name="id" select="'fs/basics'" />
                    </xsl:call-template>
                  </a>
                </li>
              </ul>
            </xsl:if>
  
          <xsl:apply-templates select="/buildinfo/document/sidebar/node()" />
  
          <xsl:if test="string(/buildinfo/document/@newsdate)">
              <p>
                <a href="/donate/index.html" class="small-donate">
                  <xsl:call-template name="fsfe-gettext">
                    <xsl:with-param name="id" select="'donate'" />
                  </xsl:call-template>
                </a>
              </p>
          </xsl:if>
          <!--xsl:if test = "/buildinfo/document/sidebar/@news">
            <xsl:element name="h4">
              <xsl:call-template name="fsfe-gettext">
                <xsl:with-param name="id" select="'related-news'" />
              </xsl:call-template>
            </xsl:element>
            <fetch-news />
            -->
            <!--FIXME-->
            <!--ul class="placeholder"><li>
                <span class="dt-published">11 June 2013</span><a href="/news/2013/news-20130611-01.en.html">Filing taxes without non-free software: Slovak company appeals fines</a>
            </li></ul-->
          <!--/xsl:if-->
  
          <xsl:choose>
            <xsl:when test = "/buildinfo/document/sidebar/@promo = 'our-work'">
              <xsl:element name="h3">
                <xsl:attribute name="class">promo</xsl:attribute>
                <xsl:call-template name="fsfe-gettext">
                  <xsl:with-param name="id" select="'our-work'" />
                </xsl:call-template>
              </xsl:element>
              <xsl:call-template name="fsfe-gettext">
                <xsl:with-param name="id" select="'our-work-intro'" />
              </xsl:call-template>
              <xsl:element name="a">
                <xsl:attribute name="href">/work.html</xsl:attribute>
                <xsl:attribute name="class">learn-more</xsl:attribute>
                <xsl:call-template name="fsfe-gettext">
                  <xsl:with-param name="id" select="'learn-more'" />
                </xsl:call-template>
              </xsl:element>
            </xsl:when>
            <xsl:when test = "/buildinfo/document/sidebar/@promo = 'about-fsfe'">
              <xsl:element name="h3">
                <xsl:attribute name="class">promo</xsl:attribute>
                <xsl:call-template name="fsfe-gettext">
                  <xsl:with-param name="id" select="'about-fsfe'" />
                </xsl:call-template>
              </xsl:element>
              <xsl:call-template name="fsfe-gettext">
                <xsl:with-param name="id" select="'about-fsfe-intro'" />
              </xsl:call-template>
              <xsl:element name="a">
                <xsl:attribute name="href">/about/about.html</xsl:attribute>
                <xsl:attribute name="class">learn-more</xsl:attribute>
                <xsl:call-template name="fsfe-gettext">
                  <xsl:with-param name="id" select="'learn-more'" />
                </xsl:call-template>
              </xsl:element>
            </xsl:when>
            <xsl:when test = "/buildinfo/document/sidebar/@promo = 'donate'">
              <xsl:element name="h3">
                <xsl:attribute name="class">promo</xsl:attribute>
                <xsl:call-template name="fsfe-gettext">
                  <xsl:with-param name="id" select="'donate'" />
                </xsl:call-template>
              </xsl:element>
              <xsl:call-template name="fsfe-gettext">
                <xsl:with-param name="id" select="'donate-paragraph'" />
              </xsl:call-template>
              <xsl:element name="a">
                <xsl:attribute name="href">/donate/donate.html#ref-sidebar</xsl:attribute>
                <xsl:attribute name="class">learn-more big-donate</xsl:attribute>
                <xsl:call-template name="fsfe-gettext">
                  <xsl:with-param name="id" select="'donate'" />
                </xsl:call-template>
              </xsl:element>
            </xsl:when>
            <xsl:when test = "/buildinfo/document/sidebar/@promo = 'no'">
            </xsl:when>
            <!--otherwise display about-fsfe-->
            <xsl:otherwise>
              <xsl:element name="h3">
                <xsl:attribute name="class">promo</xsl:attribute>
                <xsl:call-template name="fsfe-gettext">
                  <xsl:with-param name="id" select="'about-fsfe'" />
                </xsl:call-template>
              </xsl:element>
              <xsl:call-template name="fsfe-gettext">
                <xsl:with-param name="id" select="'about-fsfe-intro'" />
              </xsl:call-template>
              <xsl:element name="a">
                <xsl:attribute name="href">/about/about.html</xsl:attribute>
                <xsl:attribute name="class">learn-more</xsl:attribute>
                <xsl:call-template name="fsfe-gettext">
                  <xsl:with-param name="id" select="'learn-more'" />
                </xsl:call-template>
              </xsl:element>
            </xsl:otherwise>
          </xsl:choose>
  
        </xsl:element>
        <!--/aside#sidebar-->
      </xsl:if>
  
      <xsl:if test = "/buildinfo/document/legal">
        <xsl:element name="footer">
  
          <xsl:attribute name="class">copyright notice creativecommons</xsl:attribute>
          <xsl:choose>
            <xsl:when test = "/buildinfo/document/legal/license">
              <xsl:element name="a">
                <xsl:attribute name="href">
                  <xsl:value-of select="/buildinfo/document/legal/license"/>
                </xsl:attribute>
                <xsl:attribute name="rel">license</xsl:attribute>
                  <xsl:if test ="/buildinfo/document/legal/@type='cc-license'">
                  </xsl:if>
                  <xsl:value-of select="/buildinfo/document/legal/notice"/>
              </xsl:element>
            </xsl:when>
  
            <xsl:otherwise>
              <xsl:element name="span">
                <xsl:value-of select="/buildinfo/document/legal/notice"/>
              </xsl:element>
            </xsl:otherwise>
          </xsl:choose>
  
        </xsl:element>
        <!--/footer-->
      </xsl:if>
  
      <!--Depreciated: it's here only for "backward compatibility"  cc license way-->
      <xsl:if test = "string(/buildinfo/document/head/meta[@name='cc-license']/@content)">
        <xsl:element name="footer">
  
          <xsl:element name="div">
            <xsl:attribute name="id">cc-licenses</xsl:attribute>
  
            <xsl:element name="p">
              <xsl:element name="img">
              <xsl:attribute name="src">/graphics/cc-logo.png</xsl:attribute>
              <xsl:attribute name="alt">Creative Commons logo</xsl:attribute>
              </xsl:element> <!-- </img> -->
              <xsl:for-each select="/buildinfo/document/head/meta[@name='cc-license']">
                <xsl:value-of select="@content"/> •
              </xsl:for-each>
              <!--<xsl:value-of select="/buildinfo/document/head/meta[@name='cc-license-1']/@content" /> • -->
            </xsl:element> <!-- </p> -->
  
          </xsl:element> <!-- </div> -->
          <!-- End cc licenses -->
  
        </xsl:element>
        <!--/footer-->
      </xsl:if>
  
    </xsl:element>
    <!--/section#main-->
  </xsl:template>

</xsl:stylesheet>
