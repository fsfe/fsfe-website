<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="default.xsl" />
  <xsl:import href="../tools/xsltsl/tagging.xsl" />

  <xsl:output method="html" encoding="utf-8" indent="yes" doctype-system="about:legacy-compat" />

  <xsl:template match="body">
    <!-- xsl:attribute name="id">fellowship</xsl:attribute -->
      <div id="fellowship">
        <xsl:apply-templates />
      </div>
  </xsl:template>

  <!--display dynamic list of event items-->
  <xsl:template match="all-events">
    <!-- Current events -->
    <xsl:call-template name="fetch-events">
      <xsl:with-param name="wanted-time" select="'present'" />
      <xsl:with-param name="tag">fellowship</xsl:with-param>
      <xsl:with-param name="display-details" select="'yes'" />
    </xsl:call-template>
    
    <!-- Future events -->
    <xsl:call-template name="fetch-events">
      <xsl:with-param name="wanted-time" select="'future'" />
      <xsl:with-param name="tag">fellowship</xsl:with-param>
      <xsl:with-param name="display-details" select="'yes'" />
      <xsl:with-param name="nb-items" select="4" />
    </xsl:call-template>
    
  </xsl:template>

</xsl:stylesheet>
