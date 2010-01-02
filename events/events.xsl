<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" encoding="UTF-8" indent="yes" />

  <!-- Basically, copy everything -->
  <xsl:template match="/">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <!-- Show a single event -->
  <xsl:template name="event">
    <xsl:param name="header" />

    <!-- Create variables -->
    <xsl:variable name="start"><xsl:value-of select="@start" /></xsl:variable>
    <xsl:variable name="end"><xsl:value-of select="@end" /></xsl:variable>
    <xsl:variable name="link"><xsl:value-of select="link" /></xsl:variable>
    <xsl:variable name="page"><xsl:value-of select="page" /></xsl:variable>

    <!-- Before the first event, include the header -->
    <xsl:if test="position() = 1">
      <h2><xsl:value-of select="/html/text [@id = $header]" /></h2>
    </xsl:if>

    <!-- Now, the event block -->
    <div class="event">
      <h3><xsl:value-of select="title" /></h3>

      <xsl:choose>
        <xsl:when test="$start != $end">
          <p class="date multiple">
            <span class="n">(</span>
            <span class="from">
              <span class="day">12</span>
              &nbsp;
              <span class="month">Jan</span>
            </span>
            <span class="conjunction"><xsl:value-of select="/html/text [@id = 'to']" /></span>
            <span class="to">
              <span class="day">14</span>
              &nbsp;
              <span class="month">Jan</span>
            </span>
            <span class="n">)</span>
          </p>
        </xsl:when>
        <xsl:otherwise>
          <p class="date">
            <span class="n">(</span>
            <span class="day">14</span>
            &nbsp;
            <span class="month">Jan</span>
            <span class="n">)</span>
          </p>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:apply-templates select="body/node()" />
     
      <xsl:if test="$link != ''">
        <p class="read_more">
          <a href="{link}"><xsl:value-of select="/html/text [@id = 'more']" /></a>
        </p>
      </xsl:if>

      <xsl:if test="$page != ''">
        <p class="read_more">
          <a href="{page}"><xsl:value-of select="/html/text [@id = 'page']" /></a>
        </p>
      </xsl:if>
    </div>
  </xsl:template>

  <!-- In /html/body node, append dynamic content -->
  <xsl:template match="/html/body">
    <body>
      <!-- First, include what's in the source file -->
      <xsl:apply-templates />

      <!-- $today = current date (given as <html date="...">) -->
      <xsl:variable name="today">
        <xsl:value-of select="/html/@date" />
      </xsl:variable>

      <!-- Current events -->
      <xsl:for-each select="/html/set/event
        [translate (@start, '-', '') &lt;= translate ($today, '-', '') and
         translate (@end,   '-', '') &gt;= translate ($today, '-', '')]">
        <xsl:sort select="@start" order="descending" />
        <xsl:call-template name="event">
          <xsl:with-param name="header">current</xsl:with-param>
        </xsl:call-template>
      </xsl:for-each>

      <!-- Future events -->
      <xsl:for-each select="/html/set/event
        [translate (@start, '-', '') &gt; translate ($today, '-', '')]">
        <xsl:sort select="@start" />
        <xsl:call-template name="event">
          <xsl:with-param name="header">future</xsl:with-param>
        </xsl:call-template>
      </xsl:for-each>

      <!-- Past events -->
      <xsl:for-each select="/html/set/event
        [translate (@end, '-', '') &lt; translate ($today, '-', '')]">
        <xsl:sort select="@end" order="descending" />
        <xsl:call-template name="event">
          <xsl:with-param name="header">past</xsl:with-param>
        </xsl:call-template>
      </xsl:for-each>

    </body>
  </xsl:template>

  <!-- Do not copy <set> and <text> to output at all -->
  <xsl:template match="set" />
  <xsl:template match="text" />

  <!-- For all other nodes, copy verbatim -->
  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>

