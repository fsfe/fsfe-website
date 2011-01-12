<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dt="http://xsltsl.org/date-time">
  
  <xsl:import href="tools/xsltsl/date-time.xsl" />
  <xsl:import href="tools/xsltsl/tagging.xsl" />
  <xsl:output method="xml" encoding="UTF-8" indent="yes" />
  
  <!-- The top level element of the input file is "buildinfo" -->
  <xsl:template match="buildinfo">
    <xsl:apply-templates select="node()"/>
  </xsl:template>
  
  <!--display dynamic list of news items-->
  <xsl:template match="all-news">
    
    <xsl:call-template name="fetch-news">
    	<xsl:with-param name="tag">front-page</xsl:with-param>
    	<xsl:with-param name="nb-items" select="5" />
    </xsl:call-template>
    
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
    </xsl:call-template>
    
    <!-- Future events -->
    <xsl:call-template name="fetch-events">
        <xsl:with-param name="wanted-time" select="'future'" />
        <xsl:with-param name="tag">front-page</xsl:with-param>
        <xsl:with-param name="display-details" select="'yes'" />
        <xsl:with-param name="nb-items" select="3" />
    </xsl:call-template>
    
  </xsl:template>
  
  <!--display labels-->
  
  <!--translated word "newsletter"-->
  <xsl:template match="newsletter-label">
    <xsl:apply-templates select="/html/textset-content/text[@id='newsletter']/node()"/>
  </xsl:template>
  
  <!--translated sentence "receive-newsletter"-->
  <xsl:template match="receive-newsletter">
    <xsl:apply-templates select="/html/textset-content/text[@id='receive-newsletter']/node()"/>
  </xsl:template>
  
  <!--translated word "news"-->
  <xsl:template match="news-label">
    <xsl:apply-templates select="/html/textset-content/text[@id='news']/node()"/>
  </xsl:template>

  <!--translated word "events"-->
  <xsl:template match="events-label">
    <xsl:apply-templates select="/html/textset-content/text[@id='events']/node()"/>
  </xsl:template>
  
  <!--translated word "more"-->
  <xsl:template match="more-label">
    <xsl:apply-templates select="/html/textset-content/text[@id='more']/node()"/>
  </xsl:template>
  
  <!-- Do not copy <set> to output at all -->
  <xsl:template match="set"/>
  <xsl:template match="textset-content"/>

  <!-- For all other nodes, copy verbatim -->
  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
