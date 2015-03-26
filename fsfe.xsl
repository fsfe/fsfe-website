<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dt="http://xsltsl.org/date-time"
  exclude-result-prefixes="dt"
  xmlns:str="http://exslt.org/strings"
  extension-element-prefixes="str">

  <xsl:import href="build/xslt/gettext.xsl" />
  <xsl:import href="tools/xsltsl/static-elements.xsl" />
  <xsl:import href="tools/xsltsl/tagging.xsl" />

  <xsl:import href="build/xslt/fsfe_head.xsl" />
  <xsl:import href="build/xslt/fsfe_body.xsl" />

  <!-- For pages used on external web servers, load the CSS from absolute URL -->
  <xsl:variable name="urlprefix">
    <xsl:if test="/buildinfo/document/@external">https://fsfe.org</xsl:if>
  </xsl:variable>

  <xsl:include href="build/xslt/fsfe_document.xsl" />
  <xsl:include href="build/xslt/fsfe_headings.xsl" />
  <xsl:include href="build/xslt/fsfe_localmenu.xsl" />

  <!-- Do not copy non-HTML elements to output -->
  <xsl:include href="build/xslt/fsfe_nolocal.xsl" />

  <!-- HTML 5 compatibility doctype, since our XSLT parser doesn't support disabling output escaping -->
  <xsl:output method="html" encoding="utf-8" indent="yes" doctype-system="about:legacy-compat" />

  <!-- Ignore "latin" tags, used only for printable material -->
  <xsl:template match="latin">
    <xsl:apply-templates select="@*|node()"/>
  </xsl:template>
  
 <!--FIXME ↓-->
  <xsl:template match="fetch-news">
    <xsl:call-template name="fetch-news">
      <xsl:with-param name="tag" select="'/buildinfo/document/sidebar/@news'"/>
      <xsl:with-param name="nb-items" select="4"/>
    </xsl:call-template>
  </xsl:template>

</xsl:stylesheet>
