<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dt="http://xsltsl.org/date-time">
  
  <xsl:import href="../tools/xsltsl/date-time.xsl" />
  <xsl:import href="../tools/xsltsl/tagging.xsl" />
  <xsl:output method="xml" encoding="UTF-8" indent="yes" />
  
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
  <xsl:template match="all-tags-news">
    
    <xsl:call-template name="all-tags-news"/>
    
  </xsl:template>
  
  <!--display dynamic list of newsletters items-->
  <xsl:template match="all-tags-events">
    
    <xsl:call-template name="all-tags-events"/>
	
  </xsl:template>
  
  
  <!-- Do not copy <set> or <text> to output at all -->
  <xsl:template match="set | tags"/>

  <!-- For all other nodes, copy verbatim -->
  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
