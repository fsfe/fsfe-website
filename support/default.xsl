<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:str="http://exslt.org/strings"
  extension-element-prefixes="str">

  <xsl:import href="../tools/xsltsl/translations.xsl" />
  <xsl:import href="../tools/xsltsl/static-elements.xsl" />
  <xsl:import href="../tools/xsltsl/tagging.xsl" />

  <!-- For pages used on external web servers, load the CSS from absolute URL -->
  <xsl:variable name="urlprefix">
    <xsl:if test="/buildinfo/document/@external">https://fsfe.org</xsl:if>
  </xsl:variable>

  <xsl:include href="../build/xslt/fsfe_head.xsl" />
  <xsl:include href="../build/xslt/fsfe_body.xsl" />
  <xsl:include href="../build/xslt/fsfe_document.xsl" />
  <xsl:include href="../build/xslt/fsfe_headings.xsl" />
  <xsl:include href="../build/xslt/fsfe_localmenu.xsl" />

  <xsl:include href="../build/xslt/support_js.xsl" />
  <xsl:include href="../build/xslt/support_countries.xsl" />

  <!-- Do not copy non-HTML elements to output -->
  <xsl:include href="../build/xslt/fsfe_nolocal.xsl" />

  <!-- HTML 5 compatibility doctype, since our XSLT parser doesn't support disabling output escaping -->
  <xsl:output method="html" encoding="utf-8" indent="yes" doctype-system="about:legacy-compat" />

</xsl:stylesheet>
