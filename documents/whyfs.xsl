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
        <xsl:apply-templates select="html/set/node()" />
        <xsl:apply-templates select="html/footer/node()" />
      </body>
    </html>
  </xsl:template>
  
  <!-- Do not copy <set> to output at all -->
  <xsl:template match="set" />

  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>

