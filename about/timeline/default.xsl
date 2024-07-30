<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="../../fsfe.xsl"/>
  <xsl:template match="timeline">
    <div id="timeline">
      <xsl:for-each select="/buildinfo/document/set/year">
        <xsl:sort select="@value" order="descending"/>
        <div id="@value">
          <h2>
            <xsl:value-of select="@value"/>
          </h2>
          <xsl:for-each select="event">
            <xsl:sort select="@month" order="descending"/>
            <div>
              <h3>
                <a>
                  <xsl:attribute name="href">
                    <xsl:value-of select="url"/>
                  </xsl:attribute>
                  <xsl:value-of select="@month"/>
                  <xsl:text> </xsl:text>
                  <xsl:choose>
                    <xsl:when test="@type = 'internal'">🤝</xsl:when>
                    <xsl:when test="@type = 'legal'">⚖️</xsl:when>
                    <xsl:when test="@type = 'policy'">🏛️</xsl:when>
                    <xsl:when test="@type = 'public'">📣</xsl:when>
                    <xsl:otherwise>???</xsl:otherwise>
                  </xsl:choose>
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="title"/>
                </a>
              </h3>
              <p>
                <xsl:value-of select="body"/>
              </p>
              <figure class="float-right">
                <xsl:copy-of select="img"/>
              </figure>
            </div>
          </xsl:for-each>
        </div>
      </xsl:for-each>
    </div>
  </xsl:template>
</xsl:stylesheet>
