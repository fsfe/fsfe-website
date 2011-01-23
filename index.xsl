<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dt="http://xsltsl.org/date-time">
  
  <xsl:import href="tools/xsltsl/date-time.xsl" />
  <xsl:import href="tools/xsltsl/tagging.xsl" />
  <xsl:import href="tools/xsltsl/translations.xsl" />
  <xsl:output method="xml" encoding="UTF-8" indent="yes" />
  
  <!-- 
    For documentation on tagging (e.g. fetching news and events), take a
    look at the documentation under
      /tools/xsltsl/tagging-documentation.txt
  -->
  
  <!-- The top level element of the input file is "buildinfo" -->
  <xsl:template match="buildinfo">
    <xsl:apply-templates select="node()"/>
  </xsl:template>
  
  <!-- Display dynamic list of news items -->
  <xsl:template match="all-news">
    
    <xsl:call-template name="fetch-news">
    	<xsl:with-param name="tag">front-page</xsl:with-param>
    	<xsl:with-param name="nb-items" select="5" />
    </xsl:call-template>
    
  </xsl:template>
  
  <!-- Display dynamic list of newsletters items -->
  <xsl:template match="all-newsletters">
    <xsl:call-template name="fetch-newsletters">
      <xsl:with-param name="nb-items" select="2" />
    </xsl:call-template>
  </xsl:template>
  
  <!-- Display dynamic list of event items -->
  <xsl:template match="all-events">
    
    <!-- Current events -->
    <xsl:call-template name="fetch-events">
        <xsl:with-param name="wanted-time" select="'present'" />
        <xsl:with-param name="tag">front-page</xsl:with-param>
    </xsl:call-template>
    
    <!-- Future events -->
    <xsl:call-template name="fetch-events">
        <xsl:with-param name="wanted-time" select="'future'" />
        <xsl:with-param name="tag">front-page</xsl:with-param>
        <xsl:with-param name="display-details" select="'yes'" />
        <xsl:with-param name="nb-items" select="3" />
    </xsl:call-template>
    
  </xsl:template>
    
  <!-- Translated word "newsletter" -->
  <xsl:template match="newsletter-label">
    <xsl:call-template name="gettext">
      <xsl:with-param name="id" select="'newsletter'" />
    </xsl:call-template>
  </xsl:template>
  
  <!-- Translated sentence "receive-newsletter" -->
  <xsl:template match="receive-newsletter">
    <xsl:call-template name="gettext">
      <xsl:with-param name="id" select="'receive-newsletter'" />
    </xsl:call-template>
  </xsl:template>
  
  <!-- Translated word "news" -->
  <xsl:template match="news-label">
    <xsl:call-template name="gettext">
      <xsl:with-param name="id" select="'news'" />
    </xsl:call-template>
  </xsl:template>

  <!-- Translated word "events" -->
  <xsl:template match="events-label">
    <xsl:call-template name="gettext">
      <xsl:with-param name="id" select="'events'" />
    </xsl:call-template>
  </xsl:template>
  
  <!-- Translated word "more" -->
  <xsl:template match="more-label">
    <xsl:call-template name="gettext">
      <xsl:with-param name="id" select="'more'" />
    </xsl:call-template>
  </xsl:template>
  
  <!-- Translated word "donate" -->
  <xsl:template match="donate-label">
    <xsl:call-template name="gettext">
      <xsl:with-param name="id" select="'donate'" />
    </xsl:call-template>
  </xsl:template>

  <!-- ranslated word "join" -->
  <xsl:template match="join-label">
    <xsl:call-template name="gettext">
      <xsl:with-param name="id" select="'join'" />
    </xsl:call-template>
  </xsl:template>
  
  <!-- Generate subscribe button in correct language -->
  <xsl:template match="subscribe-button">
    <xsl:element name="input">
      <xsl:attribute name="id">submit</xsl:attribute>
      <xsl:attribute name="type">submit</xsl:attribute>
      <xsl:attribute name="value">
	    <xsl:call-template name="gettext">
          <xsl:with-param name="id" select="'subscribe'" />
        </xsl:call-template>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>
  
  <!-- Do not copy <set> or <text> to output at all -->
  <xsl:template match="set | tags"/>
  
  <!-- For all other nodes, copy verbatim -->
  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
