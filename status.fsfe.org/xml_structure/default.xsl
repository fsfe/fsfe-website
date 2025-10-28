<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="../../fsfe.org/fsfe.xsl"/>
  <xsl:template match="xml-structure-status">
    <div class="xml-structure-status">
      <h2>Status</h2>
      <xsl:for-each select="/buildinfo/document/set/master">
        <xsl:sort select="@name" order="ascending"/>
        <details>
          <summary>
            <xsl:value-of select="@name"/>
          </summary>
          <ul>
            <xsl:for-each select="detail">
              <li>
                <a>
                  <xsl:attribute name="href">
                    <xsl:text>https://git.fsfe.org/FSFE/fsfe-website/src/branch/master/</xsl:text>
                    <xsl:value-of select="@name"/>
                  </xsl:attribute>
                  <xsl:value-of select="@name"/>
                </a>
                <xsl:text>: </xsl:text>
                <xsl:value-of select="@error"/>
              </li>
            </xsl:for-each>
          </ul>
        </details>
      </xsl:for-each>
    </div>
  </xsl:template>
</xsl:stylesheet>
