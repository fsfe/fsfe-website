<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../fsfe.xsl" />
  <xsl:output method="html" encoding="utf-8" indent="yes" doctype-system="about:legacy-compat" />

  <!-- HTML head -->
  <xsl:template match="head">
    <head>
      <xsl:call-template name="pdfreaders-head" />
    </head>
  </xsl:template>
  
  
  <xsl:template name="pdfreaders-head">
    
    <!-- Don't let search engine robots index untranslated pages -->
    <xsl:element name="meta">
      <xsl:attribute name="name">robots</xsl:attribute>
      <xsl:attribute name="content">
        <xsl:choose>
          <xsl:when test="/buildinfo/@language=/buildinfo/document/@language">index, follow</xsl:when>
          <xsl:otherwise>noindex</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
    </xsl:element>

    <xsl:element name="link">
      <xsl:attribute name="rel">stylesheet</xsl:attribute>
      <xsl:attribute name="media">all</xsl:attribute>
      <xsl:attribute name="href">pdfreaders.css</xsl:attribute>
      <xsl:attribute name="type">text/css</xsl:attribute>
    </xsl:element>
    
    <xsl:element name="link">
      <xsl:attribute name="rel">icon</xsl:attribute>
      <xsl:attribute name="href">/graphics/fsfe.ico</xsl:attribute>
      <xsl:attribute name="type">image/x-icon</xsl:attribute>
    </xsl:element>
    
    <link rel="apple-touch-icon" href="{$urlprefix}/graphics/touch-icon.png" type="image/png" />
    <link rel="apple-touch-icon-precomposed" href="{$urlprefix}/graphics/touch-icon.png" type="image/png" />
    
    <xsl:for-each select="/buildinfo/trlist/tr">
      <xsl:sort select="@id"/>
      <xsl:element name="link">
        <xsl:attribute name="type">text/html</xsl:attribute>
        <xsl:attribute name="rel">alternate</xsl:attribute>
        <xsl:attribute name="hreflang"><xsl:value-of select="@id" /></xsl:attribute>
        <xsl:attribute name="lang"><xsl:value-of select="@id" /></xsl:attribute>
        <xsl:attribute name="href"><xsl:value-of select="/buildinfo/@filename"/>.<xsl:value-of select="@id"/>.html</xsl:attribute>
        <xsl:attribute name="title"><xsl:value-of select="."  disable-output-escaping="yes" /></xsl:attribute>
      </xsl:element>
    </xsl:for-each>
    
    <xsl:apply-templates select="@*|node()"/>
  </xsl:template>


  <!-- In /html/body node, append dynamic content -->
  <xsl:template match="body">
      <!-- First, include what's in the source file -->
      <xsl:apply-templates />

      <!-- $today = current date (given as <html date="...">) -->
      <xsl:variable name="today">
        <xsl:value-of select="/buildinfo/@date" />
      </xsl:variable>

      <!-- Show news except those in the future, but no newsletters -->
      <xsl:for-each select="/buildinfo/document/set/news
        [translate (@date, '-', '') &lt;= translate ($today, '-', '') and
         not (@type = 'newsletter')]">
        <xsl:sort select="@date" order="descending" />

        <!-- This is a news entry -->
        <xsl:element name="div">
	  <xsl:attribute name="class">reader</xsl:attribute>

          <!-- Date and title -->
          <xsl:element name="h1">
            <xsl:value-of select="title" />
          </xsl:element>

          <!-- Text -->
          <xsl:apply-templates select="body/node()" />

          <!-- Link -->
          <xsl:apply-templates select="link" />

        </xsl:element>
        <!-- End news entry -->

      </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
