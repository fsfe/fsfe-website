<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Insert local menu -->
  <xsl:template match="localmenu">

    <!-- Remember own set (default to 'default') -->
    <xsl:variable name="set">
      <xsl:choose>
        <xsl:when test="@set">
          <xsl:value-of select="@set"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>default</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- Remember own id -->
    <xsl:variable name="id"><xsl:value-of select="@id"/></xsl:variable>

    <!-- Add list of menu items -->
    <xsl:element name="ul">
      <xsl:attribute name="class">nav nav-tabs</xsl:attribute>

      <xsl:for-each select="/buildinfo/document/set/localmenuitem[@set=$set]">
        <xsl:sort select="@id"/>

        <xsl:element name="li">
          <xsl:attribute name="role">presentation</xsl:attribute>
          <xsl:if test="@id=$id">
            <xsl:attribute name="class">active</xsl:attribute>
          </xsl:if>

          <xsl:element name="a">
            <xsl:attribute name="href">
              <xsl:value-of select="@link"/>
            </xsl:attribute>
            <xsl:value-of select="node()"/>
          </xsl:element><!-- a -->
        </xsl:element><!-- li -->
      </xsl:for-each>
    </xsl:element><!-- ul -->

  </xsl:template>
</xsl:stylesheet>
