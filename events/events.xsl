<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dt="http://xsltsl.org/date-time">

  <xsl:import href="../tools/xsltsl/tagging.xsl" />
  <xsl:output method="xml" encoding="UTF-8" indent="yes" />
  
  <!-- 
      For documentation on tagging (e.g. fetching news and events), take a
      look at the documentation under
        /tools/xsltsl/tagging-documentation.txt
  -->

  <!-- Basically, copy everything -->
  <xsl:template match="/">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <!-- In /html/body node, append dynamic content -->
  <xsl:template match="/html/body">
    <xsl:element name="body">
      <!-- First, include what's in the source file -->
      <xsl:apply-templates />
      
      <!-- Current events -->
      <xsl:call-template name="fetch-events">
          <xsl:with-param name="wanted-time" select="'present'" />
          <xsl:with-param name="header" select="'current'" />
          <xsl:with-param name="display-details" select="'yes'" />
      </xsl:call-template>
      
      <!-- Future events -->
      <xsl:call-template name="fetch-events">
          <xsl:with-param name="wanted-time" select="'future'" />
          <xsl:with-param name="header" select="'future'" />
          <xsl:with-param name="display-details" select="'yes'" />
      </xsl:call-template>
      
      <!-- Past events -->
      <xsl:call-template name="fetch-events">
          <xsl:with-param name="wanted-time" select="'past'" />
          <xsl:with-param name="header" select="'past'" />
          <xsl:with-param name="display-details" select="'yes'" />
      </xsl:call-template>

    </xsl:element>
  </xsl:template>

  <!-- Do not copy <set> and <text> to output at all -->
  <xsl:template match="set" />
  <xsl:template match="text" />

  <!-- For all other nodes, copy verbatim -->
  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>

