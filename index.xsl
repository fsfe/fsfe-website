<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dt="http://xsltsl.org/date-time">
  
  <xsl:import href="tools/xsltsl/date-time.xsl" />
  <xsl:output method="xml" encoding="UTF-8" indent="yes" />

  <!-- $today = current date (given as <html date="...">) -->
  <xsl:variable name="today">
    <xsl:value-of select="/html/@date" />
  </xsl:variable>

  <!-- Basically, copy everything -->
  <xsl:template match="/">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

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
      <xsl:call-template name="dt:get-month-abbreviation">
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
      <xsl:call-template name="dt:get-month-abbreviation">
        <xsl:with-param name="month" select="substring($end,6,2)" />
      </xsl:call-template>
    </xsl:variable>
    
    <xsl:variable name="link">
      <xsl:value-of select="link" />
    </xsl:variable>
 
    <div class="event">
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
          <p class="date multiple">
            <span class="n">(</span>
            <span class="from">
              <span class="day"><xsl:value-of select="$start_day" /></span>
              <xsl:text> </xsl:text>
              <span class="month"><xsl:value-of select="$start_month" /></span>
            </span>
            <xsl:text> </xsl:text>
            <span class="conjunction">
              ↓
            </span>
            <xsl:text> </xsl:text>
            <span class="to">
              <span class="day"><xsl:value-of select="$end_day" /></span>
              <xsl:text> </xsl:text>
              <span class="month"><xsl:value-of select="$end_month" /></span>
            </span>
            <span class="n">)</span>
          </p>
        </xsl:when>
        <xsl:otherwise>
          <p class="date">
            <span class="n">(</span>
            <span class="day"><xsl:value-of select="$start_day" /></span>
            <xsl:text> </xsl:text>
            <span class="month"><xsl:value-of select="$start_month" /></span>
            <span class="n">)</span>
          </p>
        </xsl:otherwise>
      </xsl:choose>

      <div class="details">
        <xsl:apply-templates select="body/node()" /> 
      </div>  
    </div>
  </xsl:template>

  <!-- In /html/body node, append dynamic content -->
  <xsl:template match="/html/body">
    <body>
      <p id="banner">
        <a href="http://documentfreedom.org"><img alt="Document Freedom Day" src="http://www.documentfreedom.org/images/2/2c/2010-banner-120x60.png"/></a>
      </p>

      <xsl:apply-templates />
      
      <div id="news">
        <h2><a href="/news/news.html"><xsl:value-of select="/html/text[@id='news']"/></a></h2>
        <xsl:for-each select="/html/set/news
          [translate (@date, '-', '') &lt;= translate ($today, '-', '')]">
          <xsl:sort select="@date" order="descending" />
          <xsl:if test="position() &lt; 6">
            <xsl:call-template name="news" />
          </xsl:if>
        </xsl:for-each>
        <ul class="tools">
          <li><a class="more_news" href="/news/news.html"><xsl:value-of select="/html/text[@id='morenews']" /></a></li>
          <li><a class="rss feed" href="/news/news.rss">RSS</a></li>
        </ul>
      </div> <!-- /#news -->
      <div id="events">
        <h2><a href="/events/events.html"><xsl:value-of select="/html/text[@id='events']"/></a></h2>
        <xsl:for-each select="/html/set/event
          [translate (@end, '-', '') &gt;= translate ($today, '-', '')]">
          <xsl:sort select="@start" />
          <xsl:if test="position() &lt; 6">
            <xsl:call-template name="event" />
          </xsl:if>
        </xsl:for-each>
        <ul class="tools">
          <li><a class="more_events" href="/events/events.html"><xsl:value-of select="/html/text[@id='moreevents']" /></a></li>
          <li><a class="rss feed" href="/events/events.rss">RSS</a></li>
        </ul>
      </div> <!-- /#events -->
    </body>
  </xsl:template>

  <!-- Do not copy <set> and <text> to output at all -->
  <xsl:template match="/html/text" />
  <xsl:template match="set" />

  <!-- For all other nodes, copy verbatim -->
  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>

