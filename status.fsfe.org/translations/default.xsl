<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="../../fsfe.org/fsfe.xsl"/>
  <xsl:template match="translation-overall-status">
    <details>
      <summary>
        Overall Translation Status Overview
        </summary>
      <table>
        <tr>
          <th>Language</th>
          <th>Priority 1 files in need of translation</th>
          <th>Priority 2 files in need of translation</th>
        </tr>
        <xsl:for-each select="/buildinfo/document/set/language">
        <xsl:sort select="@long" order="ascending"/>
          <tr>
            <td>
              <a>
                <xsl:attribute name="href">
                  <xsl:text>index.</xsl:text>
                  <xsl:value-of select="@short"/>
                  <xsl:text>.html</xsl:text>
                </xsl:attribute>
                <xsl:value-of select="@long"/>
              </a>
            </td>
            <xsl:for-each select="priority">
              <xsl:sort select="@number" order="ascending"/>
              <td>
                <xsl:value-of select="@value"/>
              </td>
            </xsl:for-each>
          </tr>
        </xsl:for-each>
      </table>
    </details>
  </xsl:template>

  <xsl:template match="translation-status">
    <xsl:if test="/buildinfo/@language != 'en'">
      <div class="translation-status">
        <h2>
          <xsl:text>Translation-Status for </xsl:text>
          <xsl:value-of select="/buildinfo/@language"/>
        </h2>
        <h3>File translations</h3>
        <xsl:for-each select="/buildinfo/document/set/priority">
          <xsl:sort select="@value" order="ascending"/>
          <details>
            <summary>
              <xsl:text>Priority: </xsl:text>
              <xsl:value-of select="@value"/>
            </summary>
            <table>
              <tr>
                <th>Page</th>
                <th>Original date</th>
                <th>Original version</th>
                <th>Translation version</th>
              </tr>
              <xsl:for-each select="file">
                <tr>
                  <td>
                    <xsl:value-of select="@page"/>
                  </td>
                  <td>
                    <xsl:value-of select="@original_date"/>
                  </td>
                  <td>
                    <a>
                      <xsl:attribute name="href">
                        <xsl:value-of select="@original_url"/>
                      </xsl:attribute>
                      <xsl:value-of select="@original_version"/>
                    </a>
                  </td>
                  <td>
                    <xsl:choose>
                      <xsl:when test="@translation_url != '#'">
                        <a>
                          <xsl:attribute name="href">
                            <xsl:value-of select="@translation_url"/>
                          </xsl:attribute>
                          <xsl:value-of select="@translation_version"/>
                        </a>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="@translation_version"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                </tr>
              </xsl:for-each>
            </table>
          </details>
        </xsl:for-each>
        <xsl:for-each select="/buildinfo/document/set/missing-texts">
          <h3>
            <xsl:text>Missing texts in </xsl:text>
            <a>
              <xsl:attribute name="href">
                <xsl:value-of select="@url"/>
              </xsl:attribute>
              <xsl:value-of select="@filepath"/>
            </a>
          </h3>
          <h4>
            <xsl:text>English language texts version: </xsl:text>
            <xsl:value-of select="@en"/>
            <br/>
            <xsl:text>Current language language texts version: </xsl:text>
            <xsl:value-of select="@curr_lang"/>
          </h4>
          <details>
            <summary>Show</summary>
            <div style="display: flex; flex-wrap: wrap; align-items: stretch; align-content: stretch; justify-content: space-evenly; gap: 10px;">
              <xsl:for-each select="text">
                <div>
                  <xsl:value-of select="current()"/>
                </div>
              </xsl:for-each>
            </div>
          </details>
        </xsl:for-each>
      </div>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
