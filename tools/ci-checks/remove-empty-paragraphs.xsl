<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output encoding="utf-8" method="xml" omit-xml-declaration="no"/>
  <!-- Preserve all nodes -->
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>
  <!-- Remove empty <p> elements (whitespace only content) -->
  <xsl:template match="p[not(node()[self::*]) and normalize-space(.) = '']"/>
</xsl:stylesheet>
