<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml"
           encoding="ISO-8859-1"
           indent="yes"
           />

  <xsl:template match="/">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="/html/body">
    <body>
      <xsl:apply-templates />
      <xsl:for-each select="/html/set/news">
        <xsl:sort select="@date" order="descending" />
        <p>
         <b><xsl:value-of select="@date" /></b><br />
         <xsl:value-of select="body" />
         <xsl:variable name="link"><xsl:value-of select="link" /></xsl:variable>
         <xsl:if test="$link!=''">
           [<a href="{link}"><xsl:value-of select="/html/text[@id='more']" />]</a>
         </xsl:if>
        </p>
      </xsl:for-each>
    </body>
  </xsl:template>

  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="set">
  </xsl:template>
</xsl:stylesheet>

