<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" encoding="ISO-8859-1" indent="yes" />

  <!-- Basically, copy everything -->
  <xsl:template match="/">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
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

      <!-- Show news except those in the future -->
      <xsl:for-each select="/html/set/news
        [translate (@date, '-', '') &lt;= translate ($today, '-', '')]">
        <xsl:sort select="@date" order="descending" />
        <p>
         <b>(<xsl:value-of select="@date" />) <xsl:value-of select="title" /></b><br />
         <xsl:value-of select="body" />
         <xsl:variable name="link"><xsl:value-of select="link" /></xsl:variable>
         <xsl:if test="$link!=''">
           [<a href="{link}"><xsl:value-of select="/html/text[@id='more']" />]</a>
         </xsl:if>
        </p>
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

