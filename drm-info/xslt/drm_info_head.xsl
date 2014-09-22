<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- xsl:import href="../../build/xslt/fsfe_headings.xsl" / -->
  <xsl:include href="../../build/xslt/notifications.xsl" />
  <!--xsl:include href="../../build/xslt/fsfe_followupsection.xsl" /-->
  <xsl:include href="../../build/xslt/translation_list.xsl" />
  <xsl:include href="../../build/xslt/footer_sitenav.xsl" />
  <xsl:include href="../../build/xslt/footer_sourcelink.xsl" />
  <xsl:include href="../../build/xslt/footer_legal.xsl" />

  <xsl:include href="../../tools/xsltsl/static-elements.xsl" />

  <xsl:template name="page-body">
    <xsl:element name="body">
      <xsl:element name="header">
        <xsl:attribute name="id">top</xsl:attribute>

        <xsl:element name="div">
          <xsl:attribute name="id">logo</xsl:attribute>
          <xsl:element name="a">
            <xsl:attribute name="href">http://drm.info</xsl:attribute>
            <xsl:element name="img">
              <xsl:attribute name="src">logos/drm_logo_top.png</xsl:attribute>
              <xsl:attribute name="alt">DRM.Info</xsl:attribute>
            </xsl:element>
          </xsl:element>
        </xsl:element>

 
      </xsl:element>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
