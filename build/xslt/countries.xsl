<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- showing a dropdown select menu with all countries in /tools/countries.**.xml -->
  <xsl:template name="country-list">
    <xsl:param name="required" select="'no'" />
    <xsl:param name="class" select="''" />
    <xsl:element name="select">
      <xsl:attribute name="id">country</xsl:attribute>
      <xsl:attribute name="name">country</xsl:attribute>
      <!-- if called with a "class" value, set it as the CSS class -->
      <xsl:choose>
        <xsl:when test="$class != ''">
          <xsl:attribute name="class"><xsl:value-of select="$class" /></xsl:attribute>
        </xsl:when>
      </xsl:choose>
      <!-- when called with the required="yes" param, add the attribute
      and an empty option -->
      <xsl:choose>
        <xsl:when test="$required = 'yes'">
          <xsl:attribute name="required">required</xsl:attribute>
          <option></option> <!-- this will force people to pick a choice actively -->
        </xsl:when>
      </xsl:choose>
      <!-- loop over all countries in countries.**.xml -->
      <xsl:for-each select="/buildinfo/document/set/country">
        <xsl:sort select="." lang="en" />
        <!-- will output: <option value="ZZ">Fooland</option> -->
        <xsl:element name="option">
          <xsl:attribute name="value">
            <xsl:value-of select="@id" />|<xsl:value-of select="." />
          </xsl:attribute>
          <xsl:value-of select="." />
        </xsl:element>  <!-- /option -->
      </xsl:for-each>
    </xsl:element> <!-- /select -->
  </xsl:template>

</xsl:stylesheet>

