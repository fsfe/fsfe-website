<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- xsl:import href="../build/xslt/fsfe_headings.xsl" / -->
  <!--xsl:include href="../build/xslt/fsfe_pageclass.xsl" /-->
  <!--xsl:include href="../build/xslt/fsfe_pageheader.xsl" /-->
  <xsl:include href="../build/xslt/notifications.xsl" />
  <!--xsl:include href="../build/xslt/fsfe_mainsection.xsl" /-->
  <!--xsl:include href="../build/xslt/fsfe_followupsection.xsl" /-->
  <!--xsl:include href="../build/xslt/body_scripts.xsl" /-->
  <xsl:include href="../build/xslt/translation_list.xsl" />
  <xsl:include href="../build/xslt/footer_sitenav.xsl" />
  <xsl:include href="../build/xslt/footer_sourcelink.xsl" />
  <xsl:include href="../build/xslt/footer_legal.xsl" />

  <xsl:include href="../tools/xsltsl/static-elements.xsl" />
  <xsl:include href="../tools/xsltsl/translations.xsl" />

      <!--xsl:call-template name="fsfe_pageclass" />
      <xsl:call-template name="fsfe_pageheader" />
      <xsl:call-template name="fsfe_mainsection" />
      <xsl:call-template name="fsfe_followupsection" /-->

  <xsl:template name="page-body">
    <xsl:element name="body">
      <xsl:element name="header"> <xsl:attribute name="id">top</xsl:attribute>
        <xsl:call-template name="translation_list" />
      </xsl:element>
 
      <xsl:call-template name="notifications" />

      <xsl:element name="section"> <xsl:attribute name="id">main</xsl:attribute>

        <xsl:apply-templates select="body" />

        <xsl:for-each select="/buildinfo/document/set/news">
          <xsl:sort select="@priority" order="ascending" />
 
          <xsl:element name="div">
            <xsl:attribute name="class">reader</xsl:attribute>
 
            <xsl:element name="img">
              <xsl:attribute name="class">logo</xsl:attribute>
              <xsl:attribute name="src">logos/<xsl:value-of select="logo" /></xsl:attribute>
              <xsl:attribute name="alt"></xsl:attribute>
            </xsl:element>
 
            <xsl:element name="h1">
              <xsl:value-of select="name" />
            </xsl:element>
 
            <xsl:element name="p"> <xsl:attribute name="class">description</xsl:attribute>
              <xsl:apply-templates select="description/node()" />
            </xsl:element>
 
            <xsl:element name="span"> <xsl:attribute name="class">label homepage</xsl:attribute>
              Homepage:
            </xsl:element>
            <xsl:element name="a"> <xsl:attribute name="class">info homepage</xsl:attribute>
              <xsl:attribute name="href"><xsl:value-of select="homepage" /></xsl:attribute>
              <xsl:attribute name="alt"></xsl:attribute>
              <xsl:value-of select="homepage" />
            </xsl:element>
 
            <xsl:element name="span"> <xsl:attribute name="class">label platform</xsl:attribute>
              Platforms:
            </xsl:element>
            <xsl:for-each select="platform">
              <xsl:element name="a"> <xsl:attribute name="class">info platform</xsl:attribute>
                <xsl:attribute name="href"><xsl:value-of select="installer" /></xsl:attribute>
                <xsl:attribute name="alt"></xsl:attribute>
                <xsl:value-of select="name" />
              </xsl:element>
            </xsl:for-each>
 
          </xsl:element>
        </xsl:for-each>
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
