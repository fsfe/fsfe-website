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
    <tr>
      <td class="newstitle"><xsl:value-of select="title" /></td>
      <td class="newsdate"><xsl:value-of select="@date" /></td>
    </tr>
    <tr>
      <td colspan="2" class="newsbody">
        <xsl:apply-templates select="body/node()" />
        <xsl:variable name="link"><xsl:value-of select="link" /></xsl:variable>
        <xsl:if test="$link!=''">
          [<a href="{link}"><xsl:value-of select="/html/text[@id='more']" /></a>]
        </xsl:if>
      </td>
    </tr> 
    <tr><td colspan="2"></td></tr>
  </xsl:template>

  <!-- Show a single event -->
  <xsl:template name="event">
    <xsl:variable name="start"><xsl:value-of select="@start" /></xsl:variable>
    <xsl:variable name="end"><xsl:value-of select="@end" /></xsl:variable>
    <xsl:variable name="link"><xsl:value-of select="link" /></xsl:variable>
    <tr>
      <td class="newstitle"><xsl:value-of select="title" /></td>
      <td class="newsdate">
        <xsl:value-of select="@start" />
        <xsl:if test="$start != $end"> 
          <br />
          <xsl:value-of select="@end" />
        </xsl:if>
      </td>
    </tr>
    <tr>
      <td colspan="2" class="newsbody">
        <xsl:apply-templates select="body/node()" />
        <xsl:if test="$link!=''">
          [<a href="{link}"><xsl:value-of select="/html/text[@id='more']" /></a>]
        </xsl:if>
      </td>
    </tr> 
    <tr><td colspan="2"></td></tr>
  </xsl:template>

  <!-- In /html/body node, append dynamic content -->
  <xsl:template match="/html/body">
    <body>
      <xsl:apply-templates />
      <table>
        <tr>
          <td valign="top" width="47%">
            <center>
              <h2><xsl:value-of select="/html/text[@id='news']" /></h2>
            </center>
            <table class="news">
              <xsl:for-each select="/html/set/news">
                <xsl:sort select="@date" order="descending" />
                <xsl:if test="position() &lt; 6">
                  <xsl:call-template name="news" />
                </xsl:if>
              </xsl:for-each>
            </table>
            <center>
              <a href="news/news.html">
                <xsl:value-of select="/html/text[@id='morenews']" />
              </a>
              <br />
              <br />
              <a href="news/news.rss">[RSS]</a>
            </center>
          </td>
          <td valign="top" width="4%">
            &#160;
          </td>
          <td valign="top" width="47%">
            <center>
              <h2><xsl:value-of select="/html/text[@id='events']" /></h2>
            </center>
            <table class="news">
              <xsl:for-each select="/html/set/event
                [translate (@end, '-', '') &gt;= translate ($today, '-', '')]">
                <xsl:sort select="@start" />
                <xsl:if test="position() &lt; 6">
                  <xsl:call-template name="event" />
                </xsl:if>
              </xsl:for-each>
            </table>
            <center>
              <a href="events/events.html">
                <xsl:value-of select="/html/text[@id='moreevents']" />
              </a>
              <br />
              <br />
              <a href="events/events.rss">[RSS]</a>
            </center>
          </td>
        </tr>
      </table>
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
