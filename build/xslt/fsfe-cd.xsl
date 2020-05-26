<?xml version="1.0" encoding="UTF-8"?>

<!-- ====================================================================== -->
<!-- Helper stylesheets to include referrer for fsfe-cd                     -->
<!-- ====================================================================== -->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Hidden input field with referrer for https://my.fsfe.org/subscribe -->
  <xsl:template match="fsfe-cd-referrer-input">
    <xsl:element name="input">
      <xsl:attribute name="type">hidden</xsl:attribute>
      <xsl:attribute name="name">referrer</xsl:attribute>
      <xsl:attribute name="value">
        <xsl:text>https://fsfe.org</xsl:text>
        <xsl:value-of select="/buildinfo/@filename"/>
        <xsl:text>.html</xsl:text>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>

  <!-- Button with referrer for https://my.fsfe.org/donate -->
  <xsl:template match="fsfe-cd-donate-link">
    <xsl:element name="a">
      <xsl:attribute name="href">
        <xsl:text>https://my.fsfe.org/donate?referrer=https://fsfe.org</xsl:text>
        <xsl:value-of select="/buildinfo/@filename"/>
        <xsl:text>.html</xsl:text>
      </xsl:attribute>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
