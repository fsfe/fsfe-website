<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <!-- this template is to be called to get texts contained in "tools/texts-xx.xml" files -->
  <xsl:template name="fsfe-gettext">
    <xsl:param name="id" />
    
    <xsl:choose>
      <xsl:when test="/buildinfo/textset/text[@id=$id]">
        <xsl:apply-templates select="/buildinfo/textset/text[@id=$id]/node()" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="/buildinfo/textsetbackup/text[@id=$id]/node()" />
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>
  
  <!-- this template is to be called to get texts contained in "tools/texts-content-xx.xml" files -->
  <xsl:template name="gettext">
    <xsl:param name="id" />
    <xsl:value-of select="/buildinfo/textset/text[@id=$id] |
                          /buildinfo/textsetbackup/text[ @id=$id and not(@id=/buildinfo/textset/text/@id) ]"/>
  </xsl:template>
</xsl:stylesheet>
