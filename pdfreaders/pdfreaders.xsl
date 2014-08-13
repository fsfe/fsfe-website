<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="pdfreaders_head.xsl" />
  <!-- xsl:import href="../build/xslt/fsfe_headings.xsl" /-->

  <!--xsl:include href="../build/xslt/fsfe_pageclass.xsl" /-->
  <!--xsl:include href="../build/xslt/fsfe_pageheader.xsl" /-->
  <!--xsl:include href="../build/xslt/notifications.xsl" /-->
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
      <xsl:call-template name="notifications" />
      <xsl:call-template name="fsfe_mainsection" />
      <xsl:call-template name="fsfe_followupsection" /-->

  <!-- xsl:import href="../fsfe.xsl" / -->

  <xsl:output method="html" encoding="utf-8" indent="yes" doctype-system="about:legacy-compat" />

<xsl:template match="/">
    <xsl:apply-templates select="buildinfo/document"/>
  </xsl:template>

  <!-- The actual HTML tree is in "buildinfo/document" -->
  <xsl:template match="buildinfo/document">
    <xsl:element name="html">
      <xsl:attribute name="lang">
        <xsl:value-of select="/buildinfo/@language"/>
      </xsl:attribute>
      <xsl:attribute name="class">
        <xsl:value-of select="/buildinfo/@language" /> no-js
      </xsl:attribute>
  
      <xsl:apply-templates select="head" />
      <xsl:call-template name="pdfreaders-body" />
    </xsl:element>
  </xsl:template>
  
  <!-- In /html/body node, append dynamic content -->
  <xsl:template match="body" name="pdfreaders-body">
     <xsl:call-template name="translation_list" />
     <!-- First, include what's in the source file -->
     <!-- xsl:apply-templates / -->

     <!-- Show news except those in the future, but no newsletters -->
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

         <xsl:apply-templates select="description/node()" />

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

  </xsl:template>
</xsl:stylesheet>
