<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml"
           encoding="UTF-8"
           indent="yes"
           />

  <xsl:template match="speakers">
    <xsl:copy-of select="/html/set/table" />
  </xsl:template>
  
  <!-- Do not copy <set> to output at all -->
  <xsl:template match="set" />

  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>

