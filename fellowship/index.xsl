<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" encoding="UTF-8" indent="yes" />

  <xsl:template match="/html/head">
    <xsl:copy>
      <xsl:element name="link">
        <xsl:attribute name="href">/look/fellowship.css</xsl:attribute>
        <xsl:attribute name="rel">stylesheet</xsl:attribute>
      </xsl:element>

      <xsl:apply-templates />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="/html/body">
    <xsl:copy>
      <div id="fellowship">
        <xsl:apply-templates />
      </div>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@* | node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" />
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
