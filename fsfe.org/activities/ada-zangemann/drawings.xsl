<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../../fsfe.xsl"/>

  <xsl:template match="az-drawings">
    <xsl:for-each select="/buildinfo/document/set/drawing">
      <figure>
        <img src="https://pics.fsfe.org/uploads/medium/23/e8/1c468d01f1e3d0586b73d543f0c1.jpg">
            <xsl:attribute name="src">
                <xsl:value-of select="image"/>
            </xsl:attribute>
            <xsl:attribute name="alt">
                <xsl:value-of select="caption"/>
            </xsl:attribute>
        </img>
        <figcaption>
            <xsl:value-of select="caption"/>
            <xsl:if test="not(normalize-space(source)='')"> @ <xsl:value-of select="source"/></xsl:if>
        </figcaption>
      </figure>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
