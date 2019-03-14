<?xml version="1.0" encoding="UTF-8"?>

<!-- ====================================================================== -->
<!-- XSL script to extract the content of <tag> elements from an XML file   -->
<!-- ====================================================================== -->
<!-- This XSL script processes all <tag> elements of an XML file and        -->
<!-- outputs the content of each of these elements, separated by newlines.  -->
<!-- It is used by the script build/make_xmllists.sh.                       -->
<!-- ====================================================================== -->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="text" encoding="UTF-8"/>

  <xsl:template match="tag">
    <!-- tag name -->
    <xsl:value-of select="translate(.,' .+-/:_','')"/>
    <!-- blank -->
    <xsl:text> </xsl:text>
    <!-- tag label -->
    <xsl:value-of select="@content"/>
    <!-- append a newline -->
    <xsl:text>&#xa;</xsl:text>
  </xsl:template>
  
  <xsl:template match="@*|node()" priority="-1">
    <xsl:apply-templates select="@*|node()"/>
  </xsl:template>
</xsl:stylesheet>
