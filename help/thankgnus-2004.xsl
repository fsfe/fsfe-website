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
      <h3><xsl:value-of select="/html/text[@id='patrons']" /></h3>
      <ul>
       <xsl:apply-templates select="/html/set/patrons" />
      </ul>

      <h3><xsl:value-of select="/html/text[@id='sustaining']" /></h3>
      <ul>
       <xsl:apply-templates select="/html/set/sustainingcontributors" />
      </ul>

      <h3><xsl:value-of select="/html/text[@id='contributors']" /></h3>
      <ul>
       <xsl:apply-templates select="/html/set/contributors" />
      </ul>

      <h3><xsl:value-of select="/html/text[@id='supporters']" /></h3>
      <ul>
       <xsl:apply-templates select="/html/set/supporters" />
      </ul>

    </body>
  </xsl:template>

  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="set" />
  <xsl:template match="text" />
</xsl:stylesheet>

