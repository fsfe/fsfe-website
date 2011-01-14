<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" encoding="utf-8" indent="yes"/>

  <!-- $today = current date (given as <html date="...">) -->
  <xsl:variable name="today">
    <xsl:value-of select="/html/@date"/>
  </xsl:variable>

  <!-- Fill dynamic content -->
  <xsl:template match="dynamic-content">
    <xsl:element name="dl">
      <xsl:attribute name="id">press-releases</xsl:attribute>

      <!-- Show news except those in the future, but no newsletters -->
      <xsl:for-each select="/html/set/news[translate(@date,'-','')&lt;=translate($today,'-','') and not(@type='newsletter')]">
        <xsl:sort select="@date" order="descending" />

        <!-- A news entry -->
        <xsl:if test="position()&lt;4">
          <xsl:element name="dt">
            <xsl:value-of select="@date"/>
          </xsl:element>
          <xsl:element name="dd">
            <xsl:element name="a">
              <xsl:attribute name="href"><xsl:value-of select="link"/></xsl:attribute>
              <xsl:value-of select="title"/>
            </xsl:element>
          </xsl:element>
        </xsl:if>

      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <!-- Do not copy <set> or <text> to output at all -->
  <xsl:template match="set"/>
  <xsl:template match="text"/>

  <!-- For all other nodes, copy verbatim -->
  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
