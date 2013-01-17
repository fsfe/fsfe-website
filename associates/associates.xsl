<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../fsfe.xsl" />
  <xsl:output method="html" encoding="utf-8" indent="yes" doctype-system="about:legacy-compat" />

  <xsl:template match="associates">
    <xsl:for-each select="/buildinfo/document/set/associate">
      <xsl:sort select="@id" />
      <h3>
        <xsl:call-template name="generate-id-attribute">
          <xsl:with-param name="title" select="name" />
        </xsl:call-template>
        <a href="{link}"><xsl:value-of select="name" /></a>
      </h3>
      <xsl:apply-templates select="description/node()" />
    </xsl:for-each>
  </xsl:template>
  
</xsl:stylesheet>

