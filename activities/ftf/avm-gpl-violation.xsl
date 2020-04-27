<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../../tags/default.xsl" />
  <xsl:import href="../../fsfe.xsl" />
  
  <!-- In /html/body node, append dynamic content -->
  <xsl:template match="tagged-docs">
    <xsl:call-template name="tagged-news" />
  </xsl:template>
</xsl:stylesheet>
