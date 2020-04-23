<?xml version="1.0" encoding="UTF-8"?>

<!-- ====================================================================== -->
<!-- XSL script to extract the <localmenu> dir attribute of an XML file     -->
<!-- ====================================================================== -->
<!-- This XSL script outputs the "dir" attribute of the <localmenu> element -->
<!-- of an XML file. It is used by the script tools/update_localmenus.sh.   -->
<!-- ====================================================================== -->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="text" encoding="UTF-8"/>

  <xsl:template match="localmenu">
    <xsl:value-of select="@dir"/>
  </xsl:template>
  
  <!-- Suppress output of text nodes, which would be the default -->
  <xsl:template match="text()"/>
</xsl:stylesheet>
