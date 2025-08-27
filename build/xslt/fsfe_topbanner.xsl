<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:template name="fsfe_topbanner">
    <xsl:element name="div">
      <xsl:attribute name="class">topbanner</xsl:attribute>
      <xsl:element name="div">
        <xsl:attribute name="id">topbanner-border</xsl:attribute>
        <xsl:element name="div">
          <xsl:attribute name="id">topbanner-inner</xsl:attribute>
          <xsl:apply-templates select="/buildinfo/topbanner/node()"/>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
