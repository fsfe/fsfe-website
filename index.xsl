<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" encoding="ISO-8859-1" indent="yes" />

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
    <div class="entry">
      <h3><xsl:value-of select="title" /></h3>
      <div class="date"><xsl:value-of select="@date" /></div>
      <div class="text">
        <xsl:apply-templates select="body/node()" /> 
        <xsl:variable name="link"><xsl:value-of select="link" /></xsl:variable>
        <xsl:if test="$link!=''">
          <a class="read_more" href="{link}"><xsl:value-of select="/html/text[@id='more']" /></a>
        </xsl:if>
      </div>
    </div>
  </xsl:template>

  <!-- Show a single event -->
  <xsl:template name="event">
    <xsl:variable name="start"><xsl:value-of select="@start" /></xsl:variable>
    <xsl:variable name="end"><xsl:value-of select="@end" /></xsl:variable>
    <xsl:variable name="link"><xsl:value-of select="link" /></xsl:variable>
    <div class="event">
      <h3><xsl:value-of select="title" /></h3>
      <div class="date">
        <xsl:value-of select="@start" />
        <xsl:if test="$start != $end"> 
          <br />
          <xsl:value-of select="@end" />
        </xsl:if>
      </div>
      <div class="text">
        <xsl:apply-templates select="body/node()" /> 
        <xsl:if test="$link!=''">
          <a class="read_more" href="{link}"><xsl:value-of select="/html/text[@id='more']" /></a>
        </xsl:if>
      </div>
    </div>
  </xsl:template>

  <!-- In /html/body node, append dynamic content -->
  <xsl:template match="/html/body">
    <body>
      <xsl:apply-templates />
      <div id="news">
        <h2><xsl:value-of select="/html/text[@id='news']" /></h2>
        <xsl:for-each select="/html/set/news
          [translate (@date, '-', '') &lt;= translate ($today, '-', '')]">
          <xsl:sort select="@date" order="descending" />
          <xsl:if test="position() &lt; 6">
            <xsl:call-template name="news" />
          </xsl:if>
        </xsl:for-each>
        <ul class="tools">
          <li><a class="more_news" href="news/news.html"><xsl:value-of select="/html/text[@id='morenews']" /></a></li>
          <li><a class="rss" href="news/news.rss">RSS</a></li>
        </ul>
      </div> <!-- /#news -->
      <div id="events">
        <h2><xsl:value-of select="/html/text[@id='events']" /></h2>
        <xsl:for-each select="/html/set/event
          [translate (@end, '-', '') &gt;= translate ($today, '-', '')]">
          <xsl:sort select="@start" />
          <xsl:if test="position() &lt; 6">
            <xsl:call-template name="event" />
          </xsl:if>
        </xsl:for-each>
        <ul class="tools">
          <li><a class="more_events" href="events/events.html"><xsl:value-of select="/html/text[@id='moreevents']" /></a></li>
          <li><a class="rss" href="events/events.rss">RSS</a></li>
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
