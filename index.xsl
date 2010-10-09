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
      <!--
      <p><xsl:value-of "html/@newsdate" /></p>
      -->
      <!--
      <div class="text">
        <xsl:apply-templates select="body/node()" />
      </div>
      -->
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
          <p>
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
          <p>
            <xsl:value-of select="$start_day" />
            <xsl:text> </xsl:text>
            <xsl:value-of select="$start_month" />
          </p>
        </xsl:otherwise>
      </xsl:choose>
    </div>
  </xsl:template>

  <!-- In /html/body node, append dynamic content -->
  <xsl:template match="/html/body">
    <body>
      <xsl:apply-templates />
      
      <div class="grid-50-50">
        <div class="box first">

          <div id="feed" class="section blue-4">
            <!--<h2><a href="/news/news.html"><xsl:value-of select="/html/text[@id='news']"/></a></h2>-->
            
            <div>
              <a href="#" class="minibutton mousedown"><span>News</span></a>
              <a href="#" class="minibutton"><span>Blogs</span></a>
            </div>

            <div id="all">
              <xsl:for-each select="/html/set/news[translate (@date, '-', '') &lt;= translate ($today, '-', '')]">
                <xsl:sort select="@date" order="descending" />
                <xsl:if test="position() &lt; 6">
                  <xsl:call-template name="news" />
                </xsl:if>
              </xsl:for-each>
            </div>
          </div>
        </div>

        <div class="box">
          <div id="events" class="section blue-3">
            <h2><a href="/events/events.html"><xsl:value-of select="/html/text[@id='events']"/></a></h2>
            
            <xsl:for-each select="/html/set/event
              [translate (@end, '-', '') &gt;= translate ($today, '-', '')]">
              <xsl:sort select="@start" />
              <xsl:if test="position() &lt; 6">
                <xsl:call-template name="event" />
              </xsl:if>
            </xsl:for-each>
          </div>
        </div>
      </div>
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

