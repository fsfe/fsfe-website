<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dt="http://xsltsl.org/date-time"
  exclude-result-prefixes="dt"
  xmlns:str="http://exslt.org/strings"
  extension-element-prefixes="str">

  <xsl:import href="tools/xsltsl/translations.xsl" />
  <xsl:import href="tools/xsltsl/static-elements.xsl" />
  <xsl:import href="tools/xsltsl/tagging.xsl" />

  <!-- HTML 5 compatibility doctype, since our XSLT parser doesn't support disabling output escaping -->
  <xsl:output method="html" encoding="utf-8" indent="yes" doctype-system="about:legacy-compat" />
  
  <xsl:variable name="mode">
    <!-- here you can set the mode to switch between normal and IloveFS style -->
    <xsl:value-of select="'normal'" /> <!-- can be either 'normal' or 'valentine' -->
  </xsl:variable>
  
  <!-- The top level element of the input file is "buildinfo" -->
  <xsl:template match="/">
    <xsl:apply-templates select="buildinfo/document"/>
  </xsl:template>

  <!-- The actual HTML tree is in "buildinfo/document" -->
  <xsl:template match="buildinfo/document">
    <xsl:element name="html">
      <xsl:attribute name="lang">
        <xsl:value-of select="/buildinfo/@language"/>
      </xsl:attribute>

      <xsl:attribute name="class"><xsl:value-of select="/buildinfo/@language" /> no-js</xsl:attribute>

      <xsl:if test="/buildinfo/@language='ar'">
        <xsl:attribute name="dir">rtl</xsl:attribute>
      </xsl:if>

      <!--<xsl:apply-templates select="node()"/>-->
      <xsl:apply-templates select="head" />
      <xsl:call-template name="fsfe-body" />
    </xsl:element>
  </xsl:template>
  
  
  <!-- HTML head -->
  <xsl:import href="build/xslt/fsfe_head.xsl" />
  
  <xsl:import href="build/xslt/fsfe_headings.xsl" />

  <!-- Apply support page -->
  <xsl:template match="support-portal-javascript">
    <xsl:call-template name="support-portal-javascript" />
  </xsl:template>
  <xsl:template match="support-form-javascript">
    <xsl:call-template name="support-form-javascript" />
  </xsl:template>
  <xsl:template match="country-list-europe">
    <xsl:call-template name="country-list-europe" />
  </xsl:template>
  <xsl:template match="country-list-other-continents">
    <xsl:call-template name="country-list-other-continents" />
  </xsl:template>
  <!-- End apply support page rules -->
    
  <!-- HTML body -->
  <xsl:import href="build/xslt/fsfe_body.xsl" />

  <!-- Insert local menu -->
  <xsl:import href="build/xslt/fsfe_localmenu.xsl" />

  <!-- Ignore "latin" tags, used only for pritable material -->
  <xsl:template match="latin">
    <xsl:apply-templates select="@*|node()"/>
  </xsl:template>
  
  <!-- If no template matching <body> is found in the current page's XSL file, this one will be used -->
  <xsl:template match="body" priority="-1">
    <xsl:apply-templates />
  </xsl:template>
  
  <!-- Do not copy non-HTML elements to output -->
  <xsl:template match="timestamp|
               buildinfo/document/translator|
               buildinfo/set|
               buildinfo/textset|
               buildinfo/textsetbackup|
               buildinfo/menuset|
               buildinfo/trlist|
               buildinfo/fundraising|
               buildinfo/localmenuset|
               buildinfo/document/tags|
               buildinfo/document/legal|
               buildinfo/document/author|
               buildinfo/document/date|
               buildinfo/document/download|
               buildinfo/document/followup"/>
  
  <xsl:template match="set | tags | text"/>

  <!-- For all other nodes, copy verbatim -->
  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="@dt:*">
    <xsl:attribute name="{local-name()}">
      <xsl:value-of select="." />
    </xsl:attribute>
  </xsl:template>
  
  <!--
  <xsl:template match="@x:*">
    <xsl:attribute name="{local-name()}">
      <xsl:value-of select="." />
    </xsl:attribute>
  </xsl:template>
  -->
 <!--FIXME ↓-->
  <xsl:template match="fetch-news">
    <xsl:call-template name="fetch-news">
      <xsl:with-param name="tag" select="'/buildinfo/document/sidebar/@news'"/>
      <xsl:with-param name="nb-items" select="4"/>
    </xsl:call-template>
  </xsl:template>


</xsl:stylesheet>

