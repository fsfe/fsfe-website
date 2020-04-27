<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../../fsfe.xsl" />
  <xsl:import href="../../tags/default.xsl" />

  <xsl:template match="tagged-docs">
    <xsl:call-template name="tagged-news" />
  </xsl:template>
</xsl:stylesheet>
