<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:import href="tools/xsltsl/date-time.xsl" />
  <xsl:import href="tools/xsltsl/tagging.xsl" />
  <xsl:import href="tools/xsltsl/translations.xsl" />
  <xsl:import href="tools/xsltsl/static-elements.xsl" />
  <!-- TODO xsl:import href="tools/xsltsl/campaigns.xsl" /-->
  
  <xsl:import href="fsfe.xsl" />
  <xsl:output method="html" encoding="utf-8" indent="yes" doctype-system="about:legacy-compat" />
  
  <xsl:template match="body">
      <div id="frontpage">
        <xsl:apply-templates />
      </div>
  </xsl:template>
  
  <!--xsl:template match="quote-box">
    <xsl:call-template name="quote-box">
      <xsl:with-param name="tag" select="@tag" />
    </xsl:call-template>
  </xsl:template-->
  
  <xsl:template match="label-ourwork2011">
    <xsl:call-template name="gettext">
      <xsl:with-param name="id" select="'support'" />
    </xsl:call-template>
  </xsl:template>
  
  <!--display dynamic list of news items-->
  <xsl:template match="all-news">
    <xsl:call-template name="fetch-news">
      <xsl:with-param name="tag">front-page</xsl:with-param>
      <xsl:with-param name="nb-items" select="5" />
      <xsl:with-param name="show-date" select="'yes'" />
      <!--TODO enable a "Read More" link with class "learn-more" at the end of newsteaser-->
    </xsl:call-template>
    
  </xsl:template>
  
  <!--display dynamic list of newsletters items-->
  <xsl:template match="all-newsletters">
    <xsl:call-template name="fetch-newsletters">
      <xsl:with-param name="nb-items" select="0" />
    </xsl:call-template>

    <!--xsl:element name="p">
      <xsl:element name="a">
        <xsl:attribute name="href">/news/news.html</xsl:attribute>
        <xsl:attribute name="class">learn-more</xsl:attribute>
        <xsl:call-template name="more-news" /><xsl:text></xsl:text>
      </xsl:element>
    </xsl:element-->
  </xsl:template>
  
  <!--display dynamic list of event items-->
  <xsl:template match="all-events">
    <!-- Current events -->
    <xsl:call-template name="fetch-events">
      <xsl:with-param name="wanted-time" select="'present'" />
      <xsl:with-param name="tag">front-page</xsl:with-param>
      <xsl:with-param name="display-details" select="'yes'" />
    </xsl:call-template>
    
    <!-- Future events -->
    <xsl:call-template name="fetch-events">
      <xsl:with-param name="wanted-time" select="'future'" />
      <xsl:with-param name="tag">front-page</xsl:with-param>
      <xsl:with-param name="display-details" select="'yes'" />
      <xsl:with-param name="nb-items" select="3" />
      <!--FIXME ↑ why is it showing one more?-->
    </xsl:call-template>
    
    <xsl:element name="p">
      <xsl:element name="a">
        <xsl:attribute name="href">/events/events.html</xsl:attribute>
        <xsl:attribute name="class">learn-more</xsl:attribute>
        <xsl:call-template name="more-events" /><xsl:text></xsl:text>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  
  <!-- display campaign box 3 -->
  
  <xsl:template match="campaign-box-3">
    <xsl:element name="a">
     <xsl:attribute name="href">/campaigns/ilovefs/ilovefs<xsl:value-of select="/buildinfo/@language" />.html</xsl:attribute>
      
      <xsl:variable name="lang" select="/buildinfo/@language" />
      
      <xsl:variable name="img-path"
                    select="concat( '/campaigns/valentine/valentine-358x60-', substring($lang, 2, 2) , '.png' )" />
      
      <xsl:element name="img">
        <xsl:attribute name="src">
          <xsl:value-of select="$img-path" />
        </xsl:attribute>
        <!-- And on error (if previous file does not exist), we load our default image -->
        <!-- xsl:attribute name="onerror">
          <xsl:text>this.src='/campaigns/valentine/valentine-358x60-en.png';</xsl:text>
        </xsl:attribute -->
        <xsl:attribute name="alt"
                       value="No picture" />
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="campaigns">
    <div  id="campaigns-boxes" class="cycle-slideshow"  data-cycle-pause-on-hover="true" data-cycle-speed="500"  data-cycle-timeout="9000" data-cycle-slides="a"  data-cycle-fx="scrollHorz" data-cycle-swipe="true">
      <div class="cycle-pager"/>
      
      <xsl:for-each select="/buildinfo/textsetbackup/campaigns/campaign[ @id='zacchiroli' or @id='dfd' ]">
        <xsl:choose>
          <xsl:when test="count(/buildinfo/textset/campaigns/campaign[@id = current()/@id]) > 0">
            <xsl:apply-templates select="/buildinfo/textset/campaigns/campaign[@id = current()/@id]" mode="slideshow" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="." mode="slideshow" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
      
    </div>
  </xsl:template>
  
  <xsl:template match="campaign" mode="slideshow">
      <a href="{link}" class="campaign-box" id="{@id}">
          <xsl:if test=" photo != '' ">
              <img src="{photo}" alt="" />
          </xsl:if>
      <p class="text">
        <xsl:value-of select="   text   " />
      </p>
      <span class="author">
        <xsl:value-of select="   author   " />
      </span>
    </a>
  </xsl:template>
  
  <!-- display campaign box 4 -->
  <xsl:template match="campaign-box4">
    <!--div id="campaign-box-4"-->
      
      <!--
        Here are two codes snippets that will provide for a graphical and a text banner.
        /!\ comment out one of the two, you probably only want one banner on the front page.
      -->
      
      <!-- graphical banner -->
      <!--<a href="/campaigns/ilovefs/ilovefs.html">
        <img src="/graphics/valentine.png" />
      </a>-->
      
      <!--
        Text banner
        The ids used here are needed to fetch the correct texts in /tools/texts-content.**.xml
        /!\ the text with given IDs *must* exist there!
      -->
      <!--div class="banner-border">
        <p>
          <a href="http://www.defectivebydesign.org/no-drm-in-html5">
            <xsl:call-template name="gettext">
              <xsl:with-param name="id" select="'no-drm-in-html5'" />
            </xsl:call-template>
          </a>
        </p>
      </div -->
      
    <!--/div-->
  </xsl:template>
  
  
  <!--display labels-->
  
  <!--translated word "newsletter"-->
  <xsl:template match="newsletter-label">
    <xsl:call-template name="gettext">
      <xsl:with-param name="id" select="'newsletter'" />
    </xsl:call-template>
  </xsl:template>
  
  <!--translated sentence "receive-newsletter"-->
  <xsl:template match="receive-newsletter">
    <xsl:call-template name="gettext">
      <xsl:with-param name="id" select="'receive-newsletter'" />
    </xsl:call-template>
  </xsl:template>
  
  <!--translated word "news"-->
  <xsl:template match="news-label">
    <xsl:call-template name="gettext">
      <xsl:with-param name="id" select="'news'" />
    </xsl:call-template>
  </xsl:template>

  <!--translated word "events"-->
  <xsl:template match="events-label">
    <xsl:call-template name="gettext">
      <xsl:with-param name="id" select="'events'" />
    </xsl:call-template>
  </xsl:template>
  
  <!--translated word "more"-->
  <xsl:template match="more-label">
    <xsl:call-template name="more-label" /><xsl:text></xsl:text>
  </xsl:template>
  
  <xsl:template name="more-label">
    <xsl:call-template name="gettext">
      <xsl:with-param name="id" select="'more'" />
    </xsl:call-template>
  </xsl:template>
  
  <!--translated word "more news"-->
  <xsl:template match="more-news">
    <xsl:call-template name="more-news" /><xsl:text></xsl:text>
  </xsl:template>
  
  <xsl:template name="more-news">
    <xsl:call-template name="gettext">
      <xsl:with-param name="id" select="'morenews'" />
    </xsl:call-template>
  </xsl:template>
  
  <!--translated word "more events"-->
  <xsl:template match="more-events">
    <xsl:call-template name="more-events" /><xsl:text></xsl:text>
  </xsl:template>
  
  <xsl:template name="more-events">
    <xsl:call-template name="gettext">
      <xsl:with-param name="id" select="'moreevents'" />
    </xsl:call-template>
  </xsl:template>
  
  
  <!--translated word "donate"-->
  <xsl:template match="donate-label">
    <xsl:call-template name="gettext">
      <xsl:with-param name="id" select="'donate'" />
    </xsl:call-template>
  </xsl:template>

  <!--translated word "join"-->
  <xsl:template match="join-label">
    <xsl:call-template name="gettext">
      <xsl:with-param name="id" select="'join'" />
    </xsl:call-template>
  </xsl:template>

  <!--translated word "support"-->
  <xsl:template match="support-label">
    <xsl:call-template name="gettext">
      <xsl:with-param name="id" select="'support'" />
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template match="about-work-label">
    <xsl:call-template name="gettext">
      <xsl:with-param name="id" select="'about-work'" />
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="subscribe-nl">
    <xsl:call-template name="subscribe-nl" />
  </xsl:template>
  
</xsl:stylesheet>
