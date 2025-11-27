<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="../../fsfe.xsl"/>
  <xsl:template match="timeline">
    <div class="timeline-holder">
      <xsl:for-each select="/buildinfo/document/set/year">
        <xsl:sort select="@value" order="descending"/>
        <xsl:variable name="year" select="@value"/>
        <div class="timeline-year">
          <xsl:attribute name="id">
            <xsl:value-of select="$year"/>
          </xsl:attribute>
          <h2>
            <xsl:value-of select="$year"/>
          </h2>
          <div class="timeline-year-content">
            <xsl:for-each select="event">
              <xsl:sort select="@month" order="descending"/>
              <div>
                <xsl:attribute name="id">
                  <xsl:value-of select="$year"/>
                  <xsl:text>-</xsl:text>
                  <xsl:value-of select="@month"/>
                </xsl:attribute>
                <xsl:attribute name="class">
                  <xsl:text>timeline-item </xsl:text>
                  <xsl:value-of select="@type"/>
                </xsl:attribute>
                <div class="topline">
                  <h3>
                    <xsl:choose>
                      <xsl:when test="@type = 'internal'">🤝︎</xsl:when>
                      <xsl:when test="@type = 'policy-advocacy'">🏛︎</xsl:when>
                      <xsl:when test="@type = 'legal-support'">⚖︎</xsl:when>
                      <xsl:when test="@type = 'public-awareness'">📣︎</xsl:when>
                      <xsl:otherwise>???</xsl:otherwise>
                    </xsl:choose>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="title"/>
                  </h3>
                </div>
                <div class="description">
                  <p>
                    <xsl:value-of select="body"/>
                    <!-- <xsl:if test="img"> -->
                    <!-- <figure> -->
                    <!-- <xsl:copy-of select="img"/> -->
                    <!-- </figure> -->
                    <!-- </xsl:if> -->
                  </p>
                  <a class="more-info">
                    <xsl:attribute name="href">
                      <xsl:value-of select="url"/>
                    </xsl:attribute>
                    <xsl:call-template name="fsfe-gettext">
                      <xsl:with-param name="id" select="'learn-more'"/>
                    </xsl:call-template>
                  </a>
                </div>
              </div>
            </xsl:for-each>
          </div>
        </div>
      </xsl:for-each>
    </div>
  </xsl:template>
</xsl:stylesheet>
