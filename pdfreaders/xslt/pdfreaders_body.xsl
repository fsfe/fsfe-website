<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- xsl:import href="../../build/xslt/fsfe_headings.xsl" / -->
  <xsl:include href="../../build/xslt/notifications.xsl" />
  <!--xsl:include href="../../build/xslt/fsfe_followupsection.xsl" /-->
  <xsl:include href="../../build/xslt/translation_list.xsl" />
  <xsl:include href="../../build/xslt/footer_sitenav.xsl" />
  <xsl:include href="../../build/xslt/footer_sourcelink.xsl" />
  <xsl:include href="../../build/xslt/footer_legal.xsl" />
  <xsl:include href="../../build/xslt/gettext.xsl" />

  <xsl:include href="../../tools/xsltsl/static-elements.xsl" />

  <xsl:template name="page-body">
    <xsl:element name="body">
      <xsl:element name="header">
        <xsl:attribute name="id">top</xsl:attribute>

        <xsl:element name="div">
          <xsl:attribute name="id">logo</xsl:attribute>
          <xsl:element name="a">
            <xsl:attribute name="href">http://pdfreaders.org</xsl:attribute>
            <xsl:element name="img">
              <xsl:attribute name="src">graphics/pdfreaders-logo.png</xsl:attribute>
              <xsl:attribute name="alt">PDFreaders.org</xsl:attribute>
            </xsl:element>
          </xsl:element>
        </xsl:element>

        <xsl:element name="div">
          <xsl:attribute name="id">fsfe-logo</xsl:attribute>
          <xsl:element name="a">
            <xsl:attribute name="href">http://fsfe.org</xsl:attribute>
            <xsl:element name="img">
              <xsl:attribute name="src">//fsfe.org//graphics/logo_transparent.svg</xsl:attribute>
              <xsl:attribute name="alt">FSFE.org</xsl:attribute>
            </xsl:element>
          </xsl:element>
        </xsl:element>

        <xsl:call-template name="translation_list" />

        <xsl:element name="div">
          <xsl:attribute name="id">menu</xsl:attribute>
          <xsl:element name="ul">
            <xsl:element name="li">
              <xsl:element name="a">
                <xsl:attribute name="href">pdfreaders.html</xsl:attribute>
		The Readers
              </xsl:element>
            </xsl:element>
            <xsl:element name="li">
              <xsl:element name="a">
                <xsl:attribute name="href">os.html</xsl:attribute>
                Open Standards
              </xsl:element>
            </xsl:element>
            <xsl:element name="li">
              <xsl:element name="a">
                <xsl:attribute name="href">graphics.html</xsl:attribute>
                Graphics
              </xsl:element>
            </xsl:element>
            <xsl:element name="li">
              <xsl:element name="a">
                <xsl:attribute name="href">about.html</xsl:attribute>
                About
              </xsl:element>
            </xsl:element>
          </xsl:element>
        </xsl:element>

      </xsl:element>
 
      <xsl:call-template name="notifications" />

      <xsl:element name="section"> <xsl:attribute name="id">main</xsl:attribute>
        <xsl:apply-templates select="body/node()" />
      </xsl:element>
 
      <xsl:element name="footer">
        <xsl:attribute name="id">bottom</xsl:attribute>
 
        <xsl:call-template name="footer_sitenav" />
        <xsl:element name="hr" />
        <xsl:call-template name="footer_sourcelink" />
        <xsl:call-template name="footer_legal" />
 
        <xsl:element name="section">
          <xsl:attribute name="id">sister-organisations</xsl:attribute>
          <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'fsfnetwork'" /></xsl:call-template>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
