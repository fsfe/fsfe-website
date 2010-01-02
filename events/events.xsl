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

    <xsl:variable name="start_day"><xsl:value-of select="substring($start,9,2)" /></xsl:variable>
    <xsl:variable name="end_day"><xsl:value-of select="substring($end,9,2)" /></xsl:variable>

    <xsl:variable name="tmp_start_month"><xsl:value-of select="substring($start,6,2)" /></xsl:variable>

    <xsl:choose>
      <xsl:when test="$tmp_start_month = '01'"><xsl:variable name="start_month"><xsl:value-of select="/html/text [@id = 'months/01']" /></xsl:variable></xsl:when>
      <xsl:when test="$tmp_start_month = '02'"><xsl:variable name="start_month"><xsl:value-of select="/html/text [@id = 'months/02']" /></xsl:variable></xsl:when>
      <xsl:when test="$tmp_start_month = '03'"><xsl:variable name="start_month"><xsl:value-of select="/html/text [@id = 'months/03']" /></xsl:variable></xsl:when>
      <xsl:when test="$tmp_start_month = '04'"><xsl:variable name="start_month"><xsl:value-of select="/html/text [@id = 'months/04']" /></xsl:variable></xsl:when>
      <xsl:when test="$tmp_start_month = '05'"><xsl:variable name="start_month"><xsl:value-of select="/html/text [@id = 'months/05']" /></xsl:variable></xsl:when>
      <xsl:when test="$tmp_start_month = '06'"><xsl:variable name="start_month"><xsl:value-of select="/html/text [@id = 'months/06']" /></xsl:variable></xsl:when>
      <xsl:when test="$tmp_start_month = '07'"><xsl:variable name="start_month"><xsl:value-of select="/html/text [@id = 'months/07']" /></xsl:variable></xsl:when>
      <xsl:when test="$tmp_start_month = '08'"><xsl:variable name="start_month"><xsl:value-of select="/html/text [@id = 'months/08']" /></xsl:variable></xsl:when>
      <xsl:when test="$tmp_start_month = '09'"><xsl:variable name="start_month"><xsl:value-of select="/html/text [@id = 'months/09']" /></xsl:variable></xsl:when>
      <xsl:when test="$tmp_start_month = '10'"><xsl:variable name="start_month"><xsl:value-of select="/html/text [@id = 'months/10']" /></xsl:variable></xsl:when>
      <xsl:when test="$tmp_start_month = '11'"><xsl:variable name="start_month"><xsl:value-of select="/html/text [@id = 'months/11']" /></xsl:variable></xsl:when>
      <xsl:when test="$tmp_start_month = '12'"><xsl:variable name="start_month"><xsl:value-of select="/html/text [@id = 'months/12']" /></xsl:variable></xsl:when>
    </xsl:choose>
    
    <xsl:variable name="tmp_end_month"><xsl:value-of select="substring($end,6,2)" /></xsl:variable>
    
    <xsl:choose>
      <xsl:when test="$tmp_end_month = '01'"><xsl:variable name="end_month"><xsl:value-of select="/html/text [@id = 'months/01']" /></xsl:variable></xsl:when>
      <xsl:when test="$tmp_end_month = '02'"><xsl:variable name="end_month"><xsl:value-of select="/html/text [@id = 'months/02']" /></xsl:variable></xsl:when>
      <xsl:when test="$tmp_end_month = '03'"><xsl:variable name="end_month"><xsl:value-of select="/html/text [@id = 'months/03']" /></xsl:variable></xsl:when>
      <xsl:when test="$tmp_end_month = '04'"><xsl:variable name="end_month"><xsl:value-of select="/html/text [@id = 'months/04']" /></xsl:variable></xsl:when>
      <xsl:when test="$tmp_end_month = '05'"><xsl:variable name="end_month"><xsl:value-of select="/html/text [@id = 'months/05']" /></xsl:variable></xsl:when>
      <xsl:when test="$tmp_end_month = '06'"><xsl:variable name="end_month"><xsl:value-of select="/html/text [@id = 'months/06']" /></xsl:variable></xsl:when>
      <xsl:when test="$tmp_end_month = '07'"><xsl:variable name="end_month"><xsl:value-of select="/html/text [@id = 'months/07']" /></xsl:variable></xsl:when>
      <xsl:when test="$tmp_end_month = '08'"><xsl:variable name="end_month"><xsl:value-of select="/html/text [@id = 'months/08']" /></xsl:variable></xsl:when>
      <xsl:when test="$tmp_end_month = '09'"><xsl:variable name="end_month"><xsl:value-of select="/html/text [@id = 'months/09']" /></xsl:variable></xsl:when>
      <xsl:when test="$tmp_end_month = '10'"><xsl:variable name="end_month"><xsl:value-of select="/html/text [@id = 'months/10']" /></xsl:variable></xsl:when>
      <xsl:when test="$tmp_end_month = '11'"><xsl:variable name="end_month"><xsl:value-of select="/html/text [@id = 'months/11']" /></xsl:variable></xsl:when>
      <xsl:when test="$tmp_end_month = '12'"><xsl:variable name="end_month"><xsl:value-of select="/html/text [@id = 'months/12']" /></xsl:variable></xsl:when>
    </xsl:choose>

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
              <span class="day"><xsl:value-of select="$start_day" /> </span>
              <span class="month"><xsl:value-of select="$start_month" /></span>
            </span>
            <span class="conjunction"><xsl:value-of select="/html/text [@id = 'to']" /></span>
            <span class="to">
              <span class="day"><xsl:value-of select="$end_day" /> </span>
              <span class="month"><xsl:value-of select="$end_month" /></span>
            </span>
            <span class="n">)</span>
          </p>
        </xsl:when>
        <xsl:otherwise>
          <p class="date">
            <span class="n">(</span>
            <span class="day">14 </span>
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

