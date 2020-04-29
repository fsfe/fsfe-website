<?xml version="1.0" encoding="UTF-8"?>

<!-- ====================================================================== -->
<!-- Display a list of tags (below a news item or event entry)              -->
<!-- ====================================================================== -->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="tags">
    <xsl:element name="ul">
      <xsl:attribute name="class">tags</xsl:attribute>
      <xsl:for-each select="tag[not(@key='front-page')]">
        <xsl:element name="li">
          <xsl:element name="a">
            <xsl:attribute name="href">
              <xsl:text>/tags/tagged-</xsl:text>
              <xsl:value-of select="@key"/>
              <xsl:text>.</xsl:text>
              <xsl:value-of select="/buildinfo/@language"/>
              <xsl:text>.html</xsl:text>
            </xsl:attribute>
            <!-- If the <tag> element has no text content, fall back to key -->
            <xsl:choose>
              <xsl:when test="text()">
                <xsl:value-of select="."/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="@key"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:element><!-- a -->
        </xsl:element><!-- li -->
      </xsl:for-each>
    </xsl:element><!-- ul -->
  </xsl:template>
</xsl:stylesheet>
