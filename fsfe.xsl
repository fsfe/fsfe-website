<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dt="http://xsltsl.org/date-time"
  exclude-result-prefixes="dt"
  xmlns:str="http://exslt.org/strings"
  extension-element-prefixes="str">

  <!-- HTML 5 compatibility doctype, since our XSLT parser doesn't support disabling output escaping -->
  <xsl:output method="html" encoding="utf-8" indent="yes" doctype-system="about:legacy-compat" />
  
  <xsl:variable name="mode">
    <!-- here you can set the mode to switch between normal and IloveFS style -->
    <xsl:value-of select="'normal'" /> <!-- can be either 'normal' or 'valentine' -->
  </xsl:variable>

  <xsl:import href="tools/xsltsl/translations.xsl" />
  <xsl:import href="tools/xsltsl/static-elements.xsl" />
  <xsl:import href="tools/xsltsl/tagging.xsl" />

  
  <xsl:import href="build/xslt/fsfe_document.xsl" />
  
  <xsl:import href="build/xslt/fsfe_head.xsl" />
  <xsl:import href="build/xslt/fsfe_headings.xsl" />

  <xsl:import href="build/xslt/support_js.xsl" />
  <xsl:import href="build/xslt/support_countries.xsl" />
    
  <xsl:import href="build/xslt/fsfe_body.xsl" />
  <xsl:import href="build/xslt/fsfe_localmenu.xsl" />

  <!-- Ignore "latin" tags, used only for printable material -->
  <xsl:template match="latin">
    <xsl:apply-templates select="@*|node()"/>
  </xsl:template>
  
  <!-- If no template matching <body> is found in the current page's XSL file, this one will be used -->
  <xsl:template match="body" priority="-1">
    <xsl:apply-templates />
  </xsl:template>
  
  <!-- Do not copy non-HTML elements to output -->
  <xsl:import href="build/xslt/fsfe_nolocal.xsl" />

  <xsl:template match="@dt:*">
    <xsl:attribute name="{local-name()}">
      <xsl:value-of select="." />
    </xsl:attribute>
  </xsl:template>

 <!--FIXME ↓-->
  <xsl:template match="fetch-news">
    <xsl:call-template name="fetch-news">
      <xsl:with-param name="tag" select="'/buildinfo/document/sidebar/@news'"/>
      <xsl:with-param name="nb-items" select="4"/>
    </xsl:call-template>
  </xsl:template>

</xsl:stylesheet>

