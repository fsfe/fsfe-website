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

  <!-- EXTRACT -->
  <xsl:variable name="metadesc">
    <!-- Get the meta element description -->
    <xsl:value-of select="/buildinfo/document/head/meta[@name = 'description']/@content" />
  </xsl:variable>

  <!-- if there is a meta description, take that -->
  <xsl:variable name="extract">
    <xsl:choose>
      <!-- if there is a meta description, take that -->
      <xsl:when test="$metadesc != ''">
        <xsl:value-of select="$metadesc" />
      </xsl:when>
      <xsl:otherwise>
        <!-- take a first extract which should be sufficient for most pages -->
        <xsl:variable name="extract1">
          <!-- retrieve the first 200 letters of the first p element after h1 -->
          <xsl:value-of select="substring(normalize-space(/buildinfo/document/body/h1[1]/following::p[1]),1,200)" />
        </xsl:variable>
        <!-- measure first extract length -->
        <xsl:variable name="extractlength1">
          <xsl:value-of select="string-length($extract1)" />
        </xsl:variable>
        <!-- define cases what happens with which extract length -->
        <xsl:choose>
          <!-- case: first extract is long enough -->
          <xsl:when test="$extractlength1 &gt; 50">
            <xsl:value-of select="$extract1" />
            <xsl:text>...</xsl:text>
          </xsl:when>
          <!-- case: first extract is too short -->
          <xsl:otherwise>
            <xsl:variable name="extract2">
              <!-- retrieve the first 200 letters of the *second* p element after h1 -->
              <xsl:value-of select="substring(normalize-space(/buildinfo/document/body/h1[1]/following::p[2]),1,200)" />
            </xsl:variable>
            <!-- measure *second* extract length -->
            <xsl:variable name="extractlength2">
              <xsl:value-of select="string-length($extract2)" />
            </xsl:variable>
            <xsl:choose>
              <!-- case: second extract is long enough -->
              <xsl:when test="$extractlength2 &gt; 50">
                <xsl:value-of select="$extract2" />
              </xsl:when>
              <!-- case: second extract is too short, so take default text -->
              <xsl:otherwise>
                Non profit organisation working to create general understanding and support for software freedom. Includes news, events, and campaigns.
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
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
  
  <!-- Static elements which can be included everywhere -->
  <xsl:template match="static-element">
    <xsl:variable name="id"><xsl:value-of select="@id"/></xsl:variable>
    <xsl:copy-of select="/buildinfo/document/set/element[@id=$id]/node()" />
  </xsl:template>

</xsl:stylesheet>
