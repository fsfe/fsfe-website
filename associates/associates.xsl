<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml"
           encoding="ISO-8859-1"
           indent="yes"
           />

  <xsl:template match="/">
    <html>
      <xsl:apply-templates select="html/head" />
      <body>
        <xsl:apply-templates select="html/body/node()" />
        <xsl:for-each select="/html/set/associate">
          <xsl:sort select="@id" />
          <h3><a href="{link}"><xsl:value-of select="name" /></a></h3>
          <xsl:apply-templates select="description" />
        </xsl:for-each>
      </body>
    </html>
  </xsl:template>

  <xsl:template select="description"><xsl:apply-templates /></xsl:template>

  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>

