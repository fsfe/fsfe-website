<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dt="http://xsltsl.org/date-time" xmlns:str="http://exslt.org/strings" version="1.0" exclude-result-prefixes="dt" extension-element-prefixes="str">
  <!-- For pages used on external web servers, load the CSS from absolute URL -->
  <xsl:variable name="urlprefix">
    <xsl:if test="/buildinfo/document/@external">https://fsfe.org</xsl:if>
  </xsl:variable>
  <xsl:include href="../global/xslt/internal/fsfe_head.xsl"/>
  <xsl:include href="../global/xslt/internal/fsfe_body.xsl"/>
  <xsl:include href="../global/xslt/internal/gettext.xsl"/>
  <xsl:include href="../global/xslt/internal/static-elements.xsl"/>
  <xsl:include href="../global/xslt/internal/fsfe-cd.xsl"/>
  <xsl:include href="../global/xslt/internal/module.xsl"/>
  <xsl:include href="../global/xslt/internal/related.xsl"/>
  <xsl:include href="../global/xslt/internal/email-obfuscate.xsl"/>
  <xsl:include href="../global/xslt/internal/peertube.xsl"/>
  <!-- HTML 5 compatibility doctype, since our XSLT parser doesn't support disabling output escaping -->
  <xsl:output doctype-system="about:legacy-compat" encoding="utf-8" indent="no" method="html" omit-xml-declaration="yes"/>
  <!-- EXTRACT / DESCRIPTION of each page -->
  <xsl:variable name="metadesc">
    <!-- Get the description element -->
    <xsl:value-of select="/buildinfo/document/description"/>
  </xsl:variable>
  <!-- if there is a description, take that as an extract -->
  <xsl:variable name="extract">
    <xsl:choose>
      <!-- case 1: if there is a description, take that -->
      <xsl:when test="$metadesc != ''">
        <xsl:value-of select="$metadesc"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- take a first extract which should be sufficient for most pages -->
        <xsl:variable name="extract1">
          <!-- retrieve the first 200 letters of the first p element after h1 -->
          <xsl:value-of select="substring(normalize-space(/buildinfo/document/body/h1[1]/following::p[1]),1,155)"/>
        </xsl:variable>
        <!-- define cases what happens with which extract length -->
        <xsl:choose>
          <!-- case 2: first paragraph is long enough -->
          <xsl:when test="string-length($extract1) &gt; 50">
            <xsl:value-of select="$extract1"/>
            <xsl:text>...</xsl:text>
          </xsl:when>
          <!-- case 3: first paragraph is too short -->
          <xsl:otherwise>
            <xsl:variable name="extract2">
              <!-- retrieve the first 200 letters of the *second* p element after h1 -->
              <xsl:value-of select="substring(normalize-space(/buildinfo/document/body/h1[1]/following::p[2]),1,155)"/>
            </xsl:variable>
            <xsl:choose>
              <!-- case 3a: second paragraph is long enough -->
              <xsl:when test="string-length($extract2) &gt; 50">
                <!-- Combine $extract1 and $extract2 with max. 155 characters -->
                <xsl:value-of select="substring(normalize-space(concat($extract1, ' ', $extract2)),1,155)"/>
                <xsl:text>...</xsl:text>
              </xsl:when>
              <!-- case 3b: also second extract is too short, so take a default text -->
              <xsl:otherwise>
                <xsl:text>Free Software Foundation Europe is a charity that empowers users to control technology. We enable people to use, understand, adapt, and share software.</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:include href="../global/xslt/internal/fsfe_document.xsl"/>
  <xsl:include href="../global/xslt/internal/fsfe_headings.xsl"/>
  <xsl:include href="../global/xslt/internal/fsfe_localmenu.xsl"/>
  <!-- Do not copy non-HTML elements to output -->
  <xsl:include href="../global/xslt/internal/fsfe_nolocal.xsl"/>
</xsl:stylesheet>
