<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" encoding="UTF-8" indent="yes" />

  <!-- Fill dynamic content -->
  <xsl:template match="dynamic-content">
    <xsl:for-each select="/html/set/buglist">
      <xsl:sort select="@country"/>

      <xsl:variable name="country">
        <xsl:value-of select="@country"/>
      </xsl:variable>

      <!-- Heading -->
      <xsl:element name="h3">
        <xsl:value-of select="/html/set/country[@id=$country]"/>
      </xsl:element>

      <!-- Table header -->
      <xsl:element name="table">
        <xsl:element name="tr">
          <xsl:element name="th"><xsl:value-of select="/html/text[@id='institution-name']"/></xsl:element>
          <xsl:element name="th"><xsl:value-of select="/html/text[@id='institution-address']"/></xsl:element>
          <xsl:element name="th"><xsl:value-of select="/html/text[@id='institution-url']"/></xsl:element>
          <xsl:element name="th"><xsl:value-of select="/html/text[@id='opened']"/></xsl:element>
          <xsl:element name="th"><xsl:value-of select="/html/text[@id='closed']"/></xsl:element>
          <xsl:element name="th"><xsl:value-of select="/html/text[@id='name']"/></xsl:element>
          <xsl:element name="th"><xsl:value-of select="/html/text[@id='group']"/></xsl:element>
        </xsl:element>

        <!-- Table rows -->
        <xsl:for-each select="bug">
          <xsl:element name="tr">
            <xsl:element name="td"><xsl:value-of select="@institution-name"/></xsl:element>
            <xsl:element name="td"><xsl:value-of select="@institution-address"/></xsl:element>
            <xsl:element name="td">
              <xsl:element name="a">
                <xsl:element name="href">
                  <xsl:value-of select="@institution-url"/>
                </xsl:element>
                <xsl:value-of select="@institution-url"/>
              </xsl:element>
            </xsl:element>
            <xsl:element name="td"><xsl:value-of select="@opened"/></xsl:element>
            <xsl:element name="td"><xsl:value-of select="@closed"/></xsl:element>
            <xsl:element name="td"><xsl:value-of select="@name"/></xsl:element>
            <xsl:element name="td"><xsl:value-of select="@group"/></xsl:element>
          </xsl:element>
        </xsl:for-each>
      </xsl:element>

    </xsl:for-each>
  </xsl:template>

  <!-- Do not copy <set> and <text> to output at all -->
  <xsl:template match="set"/>
  <xsl:template match="text"/>

  <!-- For all other nodes, copy verbatim -->
  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
