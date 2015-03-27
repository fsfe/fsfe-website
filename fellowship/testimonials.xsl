<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="default.xsl" />
  <xsl:import href="xsl/quotes.xsl" />
  <xsl:import href="../tools/xsltsl/tagging.xsl" />

  <xsl:output method="html" encoding="utf-8" indent="yes" doctype-system="about:legacy-compat" />

  <xsl:template match="body">
    <!-- xsl:attribute name="id">fellowship</xsl:attribute -->
      <div id="fellowship">
        <xsl:apply-templates />
      </div>
  </xsl:template>

  <!-- rotating quotes -->
  <xsl:template match="quote-list">
    <xsl:call-template name="quote-list">
      <xsl:with-param name="tag" select="string(@tag)" />
    </xsl:call-template>
  </xsl:template>

</xsl:stylesheet>
