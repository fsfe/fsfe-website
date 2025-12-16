<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="../fsfe.org/fsfe.xsl"/>
  <xsl:template match="service-status">
    <div class="service-status">
      <xsl:for-each select="/buildinfo/document/set/incident">
        <xsl:sort select="update[1]/@date" order="descending"/>
        <details class="incident">
          <summary><xsl:if test="update[@resolved='true']"><xsl:text>RESOLVED: </xsl:text></xsl:if><xsl:value-of select="@name"/>
            (<xsl:value-of select="update[1]/@date"/> - updated: <xsl:value-of select="update[last()]/@date"/>)
          </summary>
          <div class="description">
            <xsl:for-each select="update">
              <xsl:sort select="@date" order="ascending"/>
              <div class="update">
                <strong>Update (<xsl:value-of select="@date"/>):</strong>
                <xsl:value-of select="."/>
                <br/>
              </div>
            </xsl:for-each>
          </div>
        </details>
      </xsl:for-each>
    </div>
  </xsl:template>
</xsl:stylesheet>
