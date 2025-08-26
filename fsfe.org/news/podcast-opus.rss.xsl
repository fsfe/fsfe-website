<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="podcast.rss.xsl" />

  <xsl:output
    doctype-system="about:legacy-compat"
    encoding="utf-8"
    indent="no"
    method="xml"
    omit-xml-declaration="yes" />

  <xsl:template match="/">
    <xsl:apply-templates select="/buildinfo/document">
      <xsl:with-param name="audioformat" select="'opus'" />
    </xsl:apply-templates>
  </xsl:template>

</xsl:stylesheet>
