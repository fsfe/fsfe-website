<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:import href="../tools/xsltsl/static-elements.xsl" />
  <xsl:import href="../fsfe.xsl" />
  <xsl:import href="news.xsl" />

  <xsl:template match="/buildinfo/document/body">
    <xsl:apply-templates />
  </xsl:template>

</xsl:stylesheet>

