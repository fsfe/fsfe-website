<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dt="http://xsltsl.org/date-time">

  <xsl:import href="../tools/xsltsl/tagging.xsl" />
  <xsl:import href="../fsfe.xsl" />
  <xsl:output method="html" encoding="utf-8" indent="yes" doctype-system="about:legacy-compat" />
  
  <!-- 
      For documentation on tagging (e.g. fetching news and events), take a
      look at the documentation under
        /tools/xsltsl/tagging-documentation.txt
  -->

  <!-- we need to include some things for event maps -->
  <xsl:template match="head">
    <head>
      <xsl:call-template name="page-head" />
      <xsl:element name="link">
        <xsl:attribute name="rel">stylesheet</xsl:attribute>
        <xsl:attribute name="href">/look/leaflet.css</xsl:attribute>
      </xsl:element>
      <xsl:element name="script">
        <xsl:attribute name="type">text/javascript</xsl:attribute>
        <xsl:attribute name="src">/scripts/leaflet.js</xsl:attribute>
      </xsl:element>
      <xsl:element name="script">
        <xsl:attribute name="type">text/javascript</xsl:attribute>
        <xsl:attribute name="src">/scripts/map.js</xsl:attribute>
      </xsl:element>
    </head>
  </xsl:template>

  <!-- In /html/body node, append dynamic content -->
  <xsl:template match="body">
      <!-- First, include what's in the source file -->
      <xsl:apply-templates />
      
      <!-- Current events -->
      <xsl:call-template name="fetch-events">
          <xsl:with-param name="wanted-time" select="'present'" />
          <xsl:with-param name="header" select="'current'" />
          <xsl:with-param name="display-details" select="'yes'" />
          <xsl:with-param name="display-year" select="'yes'" />
      </xsl:call-template>
      
      <!-- Future events -->
      <xsl:call-template name="fetch-events">
          <xsl:with-param name="wanted-time" select="'future'" />
          <xsl:with-param name="header" select="'future'" />
          <xsl:with-param name="display-details" select="'yes'" />
          <xsl:with-param name="display-year" select="'yes'" />
      </xsl:call-template>
      
      <!-- Past events -->
      <xsl:call-template name="fetch-events">
          <xsl:with-param name="wanted-time" select="'past'" />
          <xsl:with-param name="header" select="'past'" />
          <xsl:with-param name="display-details" select="'yes'" />
          <xsl:with-param name="display-year" select="'yes'" />
      </xsl:call-template>

  </xsl:template>

</xsl:stylesheet>

