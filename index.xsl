<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:import href="tools/xsltsl/static-elements.xsl" />
  
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
      <xsl:with-param name="nb-items" select="4" />
      <xsl:with-param name="show-date" select="'yes'" />
      <!--TODO enable a "Read More" link with class "learn-more" at the end of newsteaser-->
    </xsl:call-template>
    
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
    <div
            id="campaigns-boxes"
            class="cycle-slideshow"
            data-cycle-log="false"
            data-cycle-pause-on-hover="true"
            data-cycle-speed="500"
            data-cycle-timeout="9000"
            data-cycle-slides="a"
            data-cycle-fx="scrollHorz"
            data-cycle-swipe="true">
      <div class="cycle-pager"/>
      
      <xsl:for-each select="/buildinfo/document/set/campaign[@running = 'yes']">
        <xsl:apply-templates select="." mode="slideshow" />
      </xsl:for-each>
      
    </div>
  </xsl:template>
  
  <xsl:template match="campaign" mode="slideshow">
    <a href="{link}" class="campaign-box">
      <xsl:attribute name="id"><xsl:value-of select="@id" /></xsl:attribute>

      <!-- If you use the content tag, you can define boxes arbitrarily,
           but you shouldn't use photo/author/copyright then -->
      <xsl:if test=" content != '' ">
         <xsl:apply-templates select="content/@* | content/node()"/>
      </xsl:if>

      <xsl:if test=" photo != '' "><img src="{photo}" alt="" /></xsl:if>

      <xsl:if test=" text != '' ">
        <p class="text"><xsl:value-of select="text" /></p>
      </xsl:if>

      <xsl:if test=" text2 != '' ">
        <p class="text2"><xsl:value-of select="text2" /></p>
      </xsl:if>
      
      <!-- Author (if existing) -->
      <xsl:if test="author != ''">
        <span class="author"><xsl:value-of select="author" /></span>
      </xsl:if>
          
      <!-- Copyright notice (if existing) -->
      <xsl:if test="copyright != ''">
        <span class="copyright"><xsl:value-of select="copyright" /></span>
      </xsl:if>
    </a>
  </xsl:template>
  
  <!-- display campaign box 4 -->
  <xsl:template match="campaign-box4">
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
