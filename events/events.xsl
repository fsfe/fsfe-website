<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" encoding="ISO-8859-1" indent="yes" />

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

    <!-- Before the first event, include the header -->
    <xsl:if test="position() = 1">
      <h2><xsl:value-of select="/html/text [@id = $header]" /></h2>
    </xsl:if>

    <!-- Now, the event block -->
    <p>
      <b>
        (<xsl:value-of select="@start" />
        <xsl:if test="$start != $end"> 
          <xsl:value-of select="/html/text [@id = 'to']" />
          <xsl:value-of select="@end" />
        </xsl:if>)
        <xsl:value-of select="title" />
      </b><br />
      <xsl:value-of select="body" />
      <xsl:if test="$link != ''">
        [<a href="{link}">
          <xsl:value-of select="/html/text [@id = 'more']" />
        </a>]
      </xsl:if>
    </p>
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
        <xsl:sort select="@start" order="descending" />
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
