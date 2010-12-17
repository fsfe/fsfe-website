<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dt="http://xsltsl.org/date-time">
  
  <xsl:import href="tools/xsltsl/date-time.xsl" />
  <xsl:import href="tools/xsltsl/tagging.xsl" />
  <xsl:output method="xml" encoding="UTF-8" indent="yes" />

  <!-- set today variable-->
  <xsl:variable name="today">
    <xsl:value-of select="/html/@date" />
  </xsl:variable>

  <!-- define content type templates-->

  <!-- Show a single news item -->
  <xsl:template name="news">
    <xsl:variable name="link"><xsl:value-of select="link" /></xsl:variable>
    <div class="entry">
      <xsl:choose>
        <xsl:when test="$link != ''">
          <h3><a href="{link}"><xsl:value-of select="title" /></a></h3>
        </xsl:when>
        <xsl:otherwise>
          <h3><xsl:value-of select="title" /></h3>
        </xsl:otherwise>
      </xsl:choose>
      
      <div class="text">
        <xsl:apply-templates select="body/node()" />
      </div>
      
    </div>
  </xsl:template>

  <!-- Show a single news item -->
  <xsl:template name="newsletter">
    <xsl:variable name="link"><xsl:value-of select="link" /></xsl:variable>
    <div class="entry">
      <xsl:choose>
        <xsl:when test="$link != ''">
          <h3><a href="{link}"><xsl:value-of select="title" /></a></h3>
        </xsl:when>
        <xsl:otherwise>
          <h3><xsl:value-of select="title" /></h3>
        </xsl:otherwise>
      </xsl:choose>
      
    </div>
  </xsl:template>

  <!-- Show a single event -->
  <xsl:template name="event">

    <!-- Create variables -->
    <xsl:variable name="start">
      <xsl:value-of select="@start" />
    </xsl:variable>
    
    <xsl:variable name="start_day">
      <xsl:value-of select="substring($start,9,2)" />
    </xsl:variable>
    
    <xsl:variable name="start_month">
      <xsl:call-template name="dt:get-month-name">
        <xsl:with-param name="month" select="substring($start,6,2)" />
      </xsl:call-template>
    </xsl:variable>
    
    <xsl:variable name="end">
      <xsl:value-of select="@end" />
    </xsl:variable>
    
    <xsl:variable name="end_day">
      <xsl:value-of select="substring($end,9,2)" />
    </xsl:variable>
    
    <xsl:variable name="end_month">
      <xsl:call-template name="dt:get-month-name">
        <xsl:with-param name="month" select="substring($end,6,2)" />
      </xsl:call-template>
    </xsl:variable>
    
    <xsl:variable name="link">
      <xsl:value-of select="link" />
    </xsl:variable>
 
    <div class="entry">
      <xsl:choose>
        <xsl:when test="$link != ''">
          <h3><a href="{link}"><xsl:value-of select="title" /></a></h3>
        </xsl:when>
        <xsl:otherwise>
          <h3><xsl:value-of select="title" /></h3>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:choose>
        <xsl:when test="$start != $end">
          <p class="date">
            <xsl:value-of select="$start_day" />
            <xsl:text> </xsl:text>
            <xsl:value-of select="$start_month" />
            <xsl:text> to </xsl:text>
            <xsl:value-of select="$end_day" />
            <xsl:text> </xsl:text>
            <xsl:value-of select="$end_month" />
          </p>
        </xsl:when>
        <xsl:otherwise>
          <p class="date">
            <xsl:value-of select="$start_day" />
            <xsl:text> </xsl:text>
            <xsl:value-of select="$start_month" />
          </p>
        </xsl:otherwise>
      </xsl:choose>
    </div>
  </xsl:template>
  
  <!--define dynamic list of news items-->
  <xsl:template match="all-news">
    
    <xsl:call-template name="fetch-news">
    	<xsl:with-param name="tag"></xsl:with-param>
    </xsl:call-template>
    
  </xsl:template>
  
  <!--define dynamic list of newsletters items-->
  <xsl:template match="all-newsletters">

      <xsl:for-each select="/html/set/news [translate(@date, '-', '') &lt;= translate($today, '-', '') and (@type = 'newsletter')]">
	<xsl:sort select="@date" order="descending" />
	<xsl:if test="position()&lt;3">
	  <xsl:call-template name="newsletter" />
	</xsl:if>
      </xsl:for-each>
	  
  </xsl:template>
  
  <!--define dynamic list of event items-->
  <xsl:template match="all-events">
    
    <xsl:call-template name="fetch-events">
    	<xsl:with-param name="tag"></xsl:with-param>
    </xsl:call-template>
    
  </xsl:template>

  <!-- Do not copy <set> to output at all -->
  <xsl:template match="set"/>

  <!-- For all other nodes, copy verbatim -->
  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
