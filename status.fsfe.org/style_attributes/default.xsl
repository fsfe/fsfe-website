<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="../../fsfe.org/fsfe.xsl"/>
  <xsl:template match="style-attribute-status">
    <div class="style-attribute-status">
      <h2>Files with style attributes</h2>
      <xsl:for-each select="/buildinfo/document/set/filetype">
        <xsl:sort select="@name" order="ascending"/>
        <h2>
          <xsl:value-of select="@name"/>
        </h2>
        <xsl:for-each select="basepath">
          <details>
            <summary>
              <xsl:value-of select="@name"/>
            </summary>
            <table class="style-table">
              <thead>
                <tr>
                  <th>File</th>
                  <th>Element</th>
                  <th>Style value</th>
                </tr>
              </thead>
              <tbody>
                <xsl:for-each select="localised">
                  <xsl:variable name="file" select="@path"/>
                  <xsl:for-each select="style">
                    <tr>
                      <td>
                        <a href="https://git.fsfe.org/FSFE/fsfe-website/src/branch/master/{$file}">
                          <xsl:value-of select="$file"/>
                        </a>
                      </td>
                      <td>
                        <xsl:value-of select="@element"/>
                      </td>
                      <td>
                        <xsl:value-of select="@value"/>
                      </td>
                    </tr>
                  </xsl:for-each>
                </xsl:for-each>
              </tbody>
            </table>
          </details>
        </xsl:for-each>
      </xsl:for-each>
    </div>
  </xsl:template>
</xsl:stylesheet>
