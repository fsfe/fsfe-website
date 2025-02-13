<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../fsfe.xsl" />

  <!-- Fill dynamic content -->
  <xsl:template match="dynamic-content">
    <xsl:variable name="group"><xsl:value-of select="@group"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$group='category1'">
        <xsl:element name="table">
          <xsl:attribute name="class">table table-striped</xsl:attribute>
          <xsl:for-each select="/buildinfo/document/set/*[name(.)=$group]/donor">
            <xsl:element name="tr">
              <xsl:element name="td">
                <xsl:element name="img">
                  <xsl:attribute name="src"><xsl:value-of select="@img"/></xsl:attribute>
                  <xsl:attribute name="alt"><xsl:value-of select="node()"/></xsl:attribute>
                  <xsl:attribute name="title"><xsl:value-of select="node()"/></xsl:attribute>
                </xsl:element>
              </xsl:element>
              <xsl:element name="td">
                <xsl:value-of select="@amount"/>&#160;€
              </xsl:element>
              <xsl:element name="td">
                <xsl:if test="@since">
                  <xsl:element name="span">
                    <xsl:attribute name="class">label label-primary</xsl:attribute>
                    <xsl:value-of select="/buildinfo/document/text[@id='since']"/>
                    <xsl:text>&#160;</xsl:text>
                    <xsl:value-of select="@since"/>
                  </xsl:element>
                </xsl:if>
              </xsl:element>
            </xsl:element>
          </xsl:for-each>
        </xsl:element>
      </xsl:when>
      <xsl:when test="$group='category2'">
        <xsl:element name="table">
          <xsl:attribute name="class">table table-striped</xsl:attribute>
          <xsl:for-each select="/buildinfo/document/set/*[name(.)=$group]/donor">
            <xsl:element name="tr">
              <xsl:element name="td">
                <xsl:element name="img">
                  <xsl:attribute name="src"><xsl:value-of select="@img"/></xsl:attribute>
                  <xsl:attribute name="alt"><xsl:value-of select="node()"/></xsl:attribute>
                  <xsl:attribute name="title"><xsl:value-of select="node()"/></xsl:attribute>
                </xsl:element>
              </xsl:element>
              <xsl:element name="td">
                <xsl:if test="@since">
                  <xsl:element name="span">
                    <xsl:attribute name="class">label label-primary</xsl:attribute>
                    <xsl:value-of select="/buildinfo/document/text[@id='since']"/>
                    <xsl:text>&#160;</xsl:text>
                    <xsl:value-of select="@since"/>
                  </xsl:element>
                </xsl:if>
              </xsl:element>
            </xsl:element>
          </xsl:for-each>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="ul">
          <xsl:for-each select="/buildinfo/document/set/*[name(.)=$group]/donor">
            <xsl:element name="li">
              <xsl:apply-templates select="node()"/>
              <xsl:if test="@since">
                <xsl:text> </xsl:text>
                <xsl:element name="span">
                  <xsl:attribute name="class">label label-primary</xsl:attribute>
                  <xsl:value-of select="/buildinfo/document/text[@id='since']"/>
                  <xsl:text>&#160;</xsl:text>
                  <xsl:value-of select="@since"/>
                </xsl:element>
              </xsl:if>
            </xsl:element>
          </xsl:for-each>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
