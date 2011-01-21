<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" encoding="utf-8" indent="yes"/>

  <!-- $today = current date (given as <html date="...">) -->
  <xsl:variable name="today">
    <xsl:value-of select="/html/@date"/>
  </xsl:variable>

  <!-- $frommonth = date from which the list should start -->
  <xsl:variable name="frommonth">
    <xsl:value-of select="concat(substring($today,1,4)-1,substring($today,5,4),'01')"/>
  </xsl:variable>

  <!-- Fill dynamic content -->
  <xsl:template match="dynamic-content">
    <xsl:variable name="group"><xsl:value-of select="@group"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$group='patrons'">
        <xsl:element name="table">
          <xsl:for-each select="/html/set/*[name(.)=$group]/donor[translate(@date,'-','')&gt;=translate($frommonth,'-','')]">
            <xsl:sort select="translate(node(),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
            <xsl:element name="tr">
              <xsl:element name="td">
                <xsl:element name="img">
                  <xsl:attribute name="src"><xsl:value-of select="@img"/></xsl:attribute>
                  <xsl:attribute name="alt"><xsl:value-of select="node()"/></xsl:attribute>
                </xsl:element>
              </xsl:element>
              <xsl:element name="td">
                <xsl:value-of select="node()"/>
              </xsl:element>
            </xsl:element>
          </xsl:for-each>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="ul">
          <xsl:for-each select="/html/set/*[name(.)=$group]/donor[translate(@date,'-','')&gt;=translate($frommonth,'-','')]">
            <xsl:sort select="translate(node(),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
            <xsl:element name="li">
              <xsl:apply-templates select="node()"/>
            </xsl:element>
          </xsl:for-each>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Do not copy <set> to output at all -->
  <xsl:template match="set | tags"/>

  <!-- For all other nodes, copy verbatim -->
  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>

