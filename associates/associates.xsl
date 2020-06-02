<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../fsfe.xsl" />

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

