<?xml version="1.0" encoding="UTF-8"?>

<!-- ====================================================================== -->
<!-- XSL script to extract the used modules from a .xhtml file              -->
<!-- ====================================================================== -->
<!-- This XSL script processes all <module> elements of a .xhtml file and   -->
<!-- outputs the source files for these modules, separated by newlines.     -->
<!-- It is used by the script tools/update_xmllists.sh.                     -->
<!-- ====================================================================== -->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="text" encoding="UTF-8"/>

  <xsl:template match="module">
    <!-- Directory name -->
    <xsl:text>global/data/modules/</xsl:text>
    <!-- Filename = module id -->
    <xsl:value-of select="@id"/>
    <!-- Append a newline -->
    <xsl:text>&#xa;</xsl:text>
  </xsl:template>

  <!-- Suppress output of text nodes, which would be the default -->
  <xsl:template match="text()"/>
</xsl:stylesheet>
