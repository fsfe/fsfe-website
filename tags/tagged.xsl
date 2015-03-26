<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dt="http://xsltsl.org/date-time">
  
  <xsl:import href="../fsfe.xsl" />
  <xsl:output method="html" encoding="utf-8" indent="yes" doctype-system="about:legacy-compat" />
  
  <!-- 
    For documentation on tagging (e.g. fetching news and events), take a
    look at the documentation under
      /tools/xsltsl/tagging-documentation.txt
  -->
  
  <!-- The top level element of the input file is "buildinfo" -->
  <xsl:template match="buildinfo">
    <xsl:apply-templates select="node()"/>
  </xsl:template>
  
  <!--display dynamic list of news items-->
  <xsl:template match="tagged-news">
    
    <xsl:call-template name="tagged-news"/>
    
  </xsl:template>
  
  <!--display dynamic list of newsletters items-->
  <xsl:template match="tagged-events">
    
    <xsl:call-template name="tagged-events">
      <xsl:with-param name="absolute-fsfe-links" select="'no'" />
    </xsl:call-template>
	
  </xsl:template>

</xsl:stylesheet>
