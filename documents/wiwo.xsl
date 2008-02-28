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
      <b><xsl:value-of select="/html/text[@id='osig']" /></b>
      <ul>
        <xsl:apply-templates select="/html/set/osig/node()" />
      </ul>

      <b><xsl:value-of select="/html/text[@id='isig']" /></b>
      <ul>
        <xsl:apply-templates select="/html/set/isig/node()" />
      </ul>
      <xsl:apply-templates select="/html/text/footer/node()" />
    </body>
  </xsl:template>

  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="/html/set" />
  <xsl:template match="/html/text" />
</xsl:stylesheet>
