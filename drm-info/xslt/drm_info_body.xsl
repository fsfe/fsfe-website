<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template name="page-head">
    <xsl:element name="head">
      <!-- Don't let search engine robots index untranslated pages -->

      <xsl:element name="link">
        <xsl:attribute name="rel">stylesheet</xsl:attribute>
        <xsl:attribute name="media">all</xsl:attribute>
        <xsl:attribute name="href">drm_info.css</xsl:attribute>
        <xsl:attribute name="type">text/css</xsl:attribute>
      </xsl:element>


      <xsl:apply-templates select="head/node()"/>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>

