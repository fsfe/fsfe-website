<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template name="fsfe_pageclass">
    <!--Apply appopriate styles for the whole page -->
    <xsl:if test="/buildinfo/document/body/@id">
      <xsl:attribute name="id"><xsl:value-of select="/buildinfo/document/body/@id"/></xsl:attribute>
    </xsl:if>
    <xsl:if test="/buildinfo/document/body/@class">
      <xsl:attribute name="class">
        <xsl:value-of select="/buildinfo/document/body/@class"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="/buildinfo/document/@newsdate">
      <xsl:attribute name="class">news</xsl:attribute>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
