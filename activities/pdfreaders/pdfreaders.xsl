<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../../fsfe.xsl" />

  <xsl:template match="number-of-businesses">
    <xsl:value-of select="count(/buildinfo/document/set/bsig/li)" />
  </xsl:template>

  <xsl:template match="number-of-orgs">
    <xsl:value-of select="count(/buildinfo/document/set/osig/li)" />
  </xsl:template>

  <xsl:template match="number-of-individuals">
    <xsl:value-of select="count(/buildinfo/document/set/isig/li)" />
  </xsl:template>

  <!-- Fill dynamic content -->
  <xsl:template match="dynamic-content">
    <xsl:for-each select="/buildinfo/document/set/buglist">
      <xsl:sort select="@country"/>

      <xsl:variable name="country">
        <xsl:value-of select="@country"/>
      </xsl:variable>

      <!-- Heading -->
      <xsl:element name="h3">
        <xsl:value-of select="/buildinfo/document/set/country[@id=$country]"/>
      </xsl:element>

      <!-- Table header -->
      <xsl:element name="table">
        <xsl:element name="tr">
          <xsl:element name="th"><xsl:value-of select="/buildinfo/document/text[@id='institution-name']"/></xsl:element>
          <xsl:element name="th"><xsl:value-of select="/buildinfo/document/text[@id='institution-address']"/></xsl:element>
          <xsl:element name="th"><xsl:value-of select="/buildinfo/document/text[@id='institution-url']"/></xsl:element>
          <xsl:element name="th"><xsl:value-of select="/buildinfo/document/text[@id='opened']"/></xsl:element>
          <xsl:element name="th"><xsl:value-of select="/buildinfo/document/text[@id='closed']"/></xsl:element>
          <xsl:element name="th"><xsl:value-of select="/buildinfo/document/text[@id='name']"/></xsl:element>
          <xsl:element name="th"><xsl:value-of select="/buildinfo/document/text[@id='group']"/></xsl:element>
          <xsl:element name="th"><xsl:value-of select="/buildinfo/document/text[@id='comment']"/></xsl:element>
        </xsl:element>

        <!-- Table rows -->
        <xsl:for-each select="bug">
          <xsl:element name="tr">
            <xsl:element name="td"><xsl:value-of select="@institution-name"/></xsl:element>
            <xsl:element name="td"><xsl:value-of select="@institution-address"/></xsl:element>
            <xsl:element name="td">
              <xsl:element name="a">
                <xsl:attribute name="href">
                  <xsl:value-of select="@institution-url"/>
                </xsl:attribute>
                <xsl:value-of select="/buildinfo/document/text[@id='link']"/>
              </xsl:element>
            </xsl:element>
            <xsl:element name="td"><xsl:value-of select="@opened"/></xsl:element>
            <xsl:element name="td"><xsl:value-of select="@closed"/></xsl:element>
            <xsl:element name="td"><xsl:value-of select="@name"/></xsl:element>
            <xsl:element name="td"><xsl:value-of select="@group"/></xsl:element>
            <xsl:element name="td"><xsl:value-of select="@comment"/></xsl:element>
          </xsl:element>
        </xsl:for-each>
      </xsl:element>

    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
