<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template name="fsfe_topbanner">
    <xsl:element name="div">
      <xsl:attribute name="class">topbanner</xsl:attribute>
      <xsl:element name="div">
        <xsl:attribute name="id">topbanner-border</xsl:attribute>
        <xsl:element name="div">
          <xsl:attribute name="id">topbanner-inner</xsl:attribute>
          <xsl:element name="div">
            <xsl:attribute name="class">progressbar</xsl:attribute>
            <xsl:element name="span">
              <xsl:attribute name="class">progress</xsl:attribute>
              <!-- Use the ID selector to set the perecentage (in steps of five) -->
              <xsl:attribute name="id">progress-percentage-85</xsl:attribute>
              <!-- If you want to adjust the gradient go to -->
              <!-- /look/elements/topbanner.less  -->
              179.801,35€ <!-- how much we collected -->
              <!-- A translation of `of` -->
              <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'progressbar-of'" /></xsl:call-template>
              212.000€ <!-- our donation goal -->
            </xsl:element>
          </xsl:element>
          <xsl:apply-templates select="/buildinfo/topbanner/node()" />
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
