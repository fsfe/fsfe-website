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

  <xsl:template match="/html/text" />

  <xsl:template match="/html/body">
    <body>
      <xsl:apply-templates />
      <ul><b><xsl:value-of select="/html/text[@id='osig']" /></b>
      <ul>
       <xsl:apply-templates select="/html/set/osig" />
      </ul></ul>

      <ul><b><xsl:value-of select="/html/text[@id='isig']" /></b>
      <ul>
       <xsl:apply-templates select="/html/set/isig" />
      </ul></ul>

    </body>
  </xsl:template>

  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="osig"><xsl:apply-templates /></xsl:template>
  <xsl:template match="isig"><xsl:apply-templates /></xsl:template>

  <xsl:template match="set" />
  <xsl:template match="text" />
</xsl:stylesheet>

