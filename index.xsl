<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dt="http://xsltsl.org/date-time"
  exclude-result-prefixes="dt">
  
  <xsl:import href="tools/xsltsl/date-time.xsl" />
  <xsl:import href="tools/xsltsl/tagging.xsl" />
  <xsl:import href="tools/xsltsl/translations.xsl" />
  <xsl:import href="tools/xsltsl/static-elements.xsl" />
  <xsl:import href="tools/xsltsl/quotes.xsl" />
  <xsl:output method="xml" encoding="UTF-8" indent="yes" />
  
  
  <!-- The top level element of the input file is "buildinfo" -->
  <xsl:template match="buildinfo">
    <xsl:apply-templates select="node()"/>
  </xsl:template>

  <xsl:template match="/html/body">
    <xsl:copy>
      <div id="frontpage">
        <xsl:apply-templates />
      </div>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="quote-box">
    <xsl:call-template name="quote-box">
      <xsl:with-param name="tag" select="@tag" />
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template match="label-ourwork2011">
    <xsl:call-template name="gettext">
      <xsl:with-param name="id" select="'ourwork2011'" />
    </xsl:call-template>
  </xsl:template>
  
  <!--display dynamic list of news items-->
  <xsl:template match="all-news">
    <xsl:call-template name="fetch-news">
      <xsl:with-param name="tag">front-page</xsl:with-param>
      <xsl:with-param name="nb-items" select="5" />
      <xsl:with-param name="show-date" select="'no'" />
    </xsl:call-template>
    
    <xsl:element name="p">
      <xsl:element name="a">
        <xsl:attribute name="href">/news/news.html</xsl:attribute>
        <xsl:call-template name="more-label" /><xsl:text>…</xsl:text>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  
  <!--display dynamic list of newsletters items-->
  <xsl:template match="all-newsletters">
    <xsl:call-template name="fetch-newsletters">
      <xsl:with-param name="nb-items" select="2" />
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
    </xsl:call-template>
    
    <xsl:element name="p">
      <xsl:element name="a">
        <xsl:attribute name="href">/events/events.html</xsl:attribute>
        <xsl:call-template name="more-label" /><xsl:text>…</xsl:text>
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
        <xsl:attribute name="onerror">
          <xsl:text>this.src='/campaigns/valentine/valentine-358x60-en.png';</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="alt"
                       value="No picture" />
      </xsl:element>
    </xsl:element>
  </xsl:template>
  
  <!-- display campaign box 4 -->
  <xsl:template match="campaign-box4">
    <div id="campaign-box-4">
      
      <!-- here are two codes snippets that will provide for a graphical and a text banner
           /!\ comment out one of the two, you probably only want one banner on the front page  -->
      
      <!-- graphical banner, just change the text and  -->
      <!--<a href="/campaigns/ilovefs/ilovefs.html">
        <img src="/graphics/valentine.png" />
      </a>-->
      
      <!-- text banner -->
      <div class="banner-border">
        <p>
          <xsl:call-template name="gettext">
            <xsl:with-param name="id" select="'cb-restricted-boot'" />
          </xsl:call-template>
          <xsl:text> </xsl:text>
          <a href="/campaigns/ilovefs/ilovefs.html">
            <xsl:call-template name="gettext">
              <xsl:with-param name="id" select="'cb-restricted-boot-link'" />
            </xsl:call-template>
          </a>
        </p>
      </div>
      
    </div>
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
    <xsl:call-template name="more-label" /><xsl:text>…</xsl:text>
  </xsl:template>
  
  <xsl:template name="more-label">
    <xsl:call-template name="gettext">
      <xsl:with-param name="id" select="'more'" />
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
  
  <xsl:template match="subscribe-nl">
    <xsl:call-template name="subscribe-nl" />
  </xsl:template>
  
  <!-- Do not copy <set> or <text> to output at all -->
  <xsl:template match="set | tags | text"/>
  
  <!-- For all other nodes, copy verbatim -->
  <xsl:template match="@* | node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@dt:*">
    <xsl:attribute name="{local-name()}">
      <xsl:value-of select="." />
    </xsl:attribute>
  </xsl:template>
</xsl:stylesheet>
