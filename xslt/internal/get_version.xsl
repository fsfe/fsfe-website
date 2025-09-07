<?xml version="1.0" encoding="UTF-8"?>
<!-- ====================================================================== -->
<!-- Extract the content of <version> element from an XML file              -->
<!-- ====================================================================== -->
<!-- This XSL script processes the <version> elements of an XML file and    -->
<!-- outputs its content. It is used to check for outdated translations.    -->
<!-- ====================================================================== -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output doctype-system="about:legacy-compat" encoding="utf-8" indent="no" method="text" omit-xml-declaration="yes"/>
  <xsl:template match="version">
    <xsl:value-of select="."/>
  </xsl:template>
  <!-- Suppress output of text nodes, which would be the default -->
  <xsl:template match="text()"/>
</xsl:stylesheet>
