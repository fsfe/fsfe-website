<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template name="sidebar">
    <aside id="sidebar">
      <xsl:if test="string(/buildinfo/document/@newsdate) and /buildinfo/document/@type = 'newsletter'">
        <h3><xsl:call-template name="fsfe-gettext">
          <xsl:with-param name="id" select="'receive-newsletter'" />
        </xsl:call-template></h3>
        <xsl:call-template name="subscribe-nl" />
        <ul>
          <li><a href="/news/newsletter.html">
            <xsl:call-template name="fsfe-gettext">
              <xsl:with-param name="id" select="'news/nl'" />
            </xsl:call-template></a></li>
          <li><a href="/news/news.html">
            <xsl:call-template name="fsfe-gettext">
              <xsl:with-param name="id" select="'news/news'" />
            </xsl:call-template></a></li>
          <li><a href="/events/events.html">
            <xsl:call-template name="fsfe-gettext">
              <xsl:with-param name="id" select="'news/events'" />
            </xsl:call-template></a></li>
          <li><a href="http://planet.fsfe.org">
            <xsl:call-template name="fsfe-gettext">
              <xsl:with-param name="id" select="'news/planet'" />
            </xsl:call-template></a></li>
          <li><a href="/contact/community.html">
            <xsl:call-template name="fsfe-gettext">
              <xsl:with-param name="id" select="'community/discuss'" />
            </xsl:call-template></a></li>
        </ul>
      </xsl:if>

      <xsl:if test="string(/buildinfo/document/@newsdate) and count(/buildinfo/document/@type) = 0">
        <h3><xsl:call-template name="fsfe-gettext">
          <xsl:with-param name="id" select="'fsfe/press'" />
        </xsl:call-template></h3>
        <ul>
          <li><a href="/press/press.html">
            <xsl:call-template name="fsfe-gettext">
              <xsl:with-param name="id" select="'news/press'" />
            </xsl:call-template></a></li>
          <li><a href="/news/news.html">
            <xsl:call-template name="fsfe-gettext">
              <xsl:with-param name="id" select="'news/news'" />
            </xsl:call-template></a></li>
          <li><a href="/freesoftware/freesoftware.html">
            <xsl:call-template name="fsfe-gettext">
              <xsl:with-param name="id" select="'fs/basics'" />
            </xsl:call-template></a></li>
        </ul>
      </xsl:if>

      <xsl:apply-templates select="/buildinfo/document/sidebar/node()" />

      <xsl:if test="string(/buildinfo/document/@newsdate)">
        <a href="https://my.fsfe.org/support" class="small-donate">
          <xsl:call-template name="fsfe-gettext">
            <xsl:with-param name="id" select="'support/become'" />
          </xsl:call-template>
        </a>
      </xsl:if>

      <!-- Add promotion block depending on the "promo" parameter -->
      <xsl:choose>

        <!-- Promotion block "our-work" -->
        <xsl:when test = "/buildinfo/document/sidebar/@promo = 'our-work'">
          <h3 class="promo"><xsl:call-template name="fsfe-gettext">
            <xsl:with-param name="id" select="'our-work'" />
          </xsl:call-template></h3>
          <xsl:call-template name="fsfe-gettext">
            <xsl:with-param name="id" select="'our-work-intro'" />
          </xsl:call-template>
          <a href="/about/ourwork.html" class="learn-more">
            <xsl:call-template name="fsfe-gettext">
              <xsl:with-param name="id" select="'learn-more'" />
          </xsl:call-template></a>
        </xsl:when>

        <!-- Promotion block "support" -->
        <xsl:when test = "/buildinfo/document/sidebar/@promo = 'support'">
          <h3 class="promo"><xsl:call-template name="fsfe-gettext">
            <xsl:with-param name="id" select="'support'" />
          </xsl:call-template></h3>
          <xsl:call-template name="fsfe-gettext">
            <xsl:with-param name="id" select="'our-work-intro'" />
          </xsl:call-template>
          <xsl:call-template name="fsfe-gettext">
            <xsl:with-param name="id" select="'support-paragraph'" />
          </xsl:call-template>
          <a href="https://my.fsfe.org/support" class="big-donate">
            <xsl:call-template name="fsfe-gettext">
              <xsl:with-param name="id" select="'support/become'" />
          </xsl:call-template></a>
        </xsl:when>

        <!-- Promotion block "donate" -->
        <xsl:when test = "/buildinfo/document/sidebar/@promo = 'donate'">
          <h3 class="promo"><xsl:call-template name="fsfe-gettext">
            <xsl:with-param name="id" select="'donate'" />
          </xsl:call-template></h3>
          <xsl:call-template name="fsfe-gettext">
            <xsl:with-param name="id" select="'donate-paragraph'" />
          </xsl:call-template>
          <a href="https://my.fsfe.org/donate" class="learn-more big-donate">
            <xsl:call-template name="fsfe-gettext">
              <xsl:with-param name="id" select="'donate'" />
          </xsl:call-template></a>
        </xsl:when>

        <!-- Promotion block "about-fsfe", which is the default -->
        <xsl:when test = "not(/buildinfo/document/sidebar/@promo = 'none')">
          <h3 class="promo"><xsl:call-template name="fsfe-gettext">
            <xsl:with-param name="id" select="'about-fsfe'" />
          </xsl:call-template></h3>
          <xsl:call-template name="fsfe-gettext">
            <xsl:with-param name="id" select="'about-fsfe-intro'" />
          </xsl:call-template>
          <a href="/about/about.html" class="learn-more">
            <xsl:call-template name="fsfe-gettext">
              <xsl:with-param name="id" select="'learn-more'" />
          </xsl:call-template></a>
        </xsl:when>
      </xsl:choose>

    </aside>
  </xsl:template>

</xsl:stylesheet>
