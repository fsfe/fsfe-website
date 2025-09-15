<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <!-- showing a dropdown select menu with all countries in /global/countries/*.**.xml -->
  <xsl:template name="country-list">
    <xsl:param name="required" select="'no'"/>
    <xsl:param name="class" select="''"/>
    <xsl:param name="subset" select="''"/>
    <xsl:param name="twoletter" select="'no'"/>
    <xsl:element name="select">
      <xsl:attribute name="id">country</xsl:attribute>
      <xsl:attribute name="name">country</xsl:attribute>
      <!-- if called with a "class" value, set it as the CSS class -->
      <xsl:choose>
        <xsl:when test="$class != ''">
          <xsl:attribute name="class">
            <xsl:value-of select="$class"/>
          </xsl:attribute>
        </xsl:when>
      </xsl:choose>
      <!-- when called with the required="yes" param, add the attribute
      and an empty option -->
      <xsl:choose>
        <xsl:when test="$required = 'yes'">
          <xsl:attribute name="required">required</xsl:attribute>
          <option/>
          <!-- this will force people to pick a choice actively -->
        </xsl:when>
      </xsl:choose>
      <!-- loop over all countries in countries.**.xml -->
      <xsl:choose>
        <!-- if subset is defined, only display those that have as attribute: $subset="yes" -->
        <xsl:when test="$subset != ''">
          <xsl:for-each select="/buildinfo/document/set/country[@*[name() = $subset] = 'yes']">
            <xsl:sort select="." lang="en"/>
            <xsl:call-template name="country-list-options"/>
          </xsl:for-each>
        </xsl:when>
        <!-- otherwise, just display all countries -->
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="$twoletter = 'yes'">
              <xsl:for-each select="/buildinfo/document/set/country">
                <xsl:sort select="." lang="en"/>
                <xsl:call-template name="country-list-options-2-letter"/>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:for-each select="/buildinfo/document/set/country">
                <xsl:sort select="." lang="en"/>
                <xsl:call-template name="country-list-options"/>
              </xsl:for-each>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
    <!-- /select -->
  </xsl:template>
  <xsl:template name="country-list-options">
    <!-- will output: <option value="ZZ|Fooland">Fooland</option> -->
    <xsl:element name="option">
      <xsl:attribute name="value"><xsl:value-of select="@id"/>|<xsl:value-of select="."/>
      </xsl:attribute>
      <xsl:value-of select="."/>
    </xsl:element>
    <!-- /option -->
  </xsl:template>
  <xsl:template name="country-list-options-2-letter">
    <!-- will output: <option value="ZZ">Fooland</option> -->
    <xsl:element name="option">
      <xsl:attribute name="value">
        <xsl:value-of select="@id"/>
      </xsl:attribute>
      <xsl:value-of select="."/>
    </xsl:element>
    <!-- /option -->
  </xsl:template>
</xsl:stylesheet>
