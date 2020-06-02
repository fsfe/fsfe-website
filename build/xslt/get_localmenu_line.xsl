<?xml version="1.0" encoding="UTF-8"?>

<!-- ====================================================================== -->
<!-- XSL script to extract the <localmenu> element of an XML file           -->
<!-- ====================================================================== -->
<!-- This XSL script outputs a line for the .localmenu.en.xml file from the -->
<!-- <localmenu> element of an .xhtml file. It is used by the script        -->
<!-- tools/update_localmenus.sh.                                            -->
<!-- ====================================================================== -->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="text" encoding="UTF-8"/>

  <xsl:template match="localmenu[@id]">
    <xsl:text>  &lt;localmenuitem set="</xsl:text>
    <xsl:choose>
      <xsl:when test="@set">
        <xsl:value-of select="@set"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>default</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>" id="</xsl:text>
    <xsl:value-of select="@id"/>
    <xsl:text>" link="</xsl:text>
    <xsl:value-of select="$link"/>
    <xsl:text>"&gt;</xsl:text>
    <xsl:value-of select="normalize-space(node())"/>
    <xsl:text>&lt;/localmenuitem&gt;</xsl:text>
  </xsl:template>

  <!-- Suppress output of text nodes, which would be the default -->
  <xsl:template match="text()"/>
</xsl:stylesheet>
