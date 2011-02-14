<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dt="http://xsltsl.org/date-time">
  
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
  
  <xsl:template match="identica">
    <xsl:element name="div">
      <xsl:attribute name="class">entry</xsl:attribute>
      <xsl:attribute name="style">float: right;</xsl:attribute>
      
      <xsl:element name="script">
        <xsl:attribute name="type">text/javascript</xsl:attribute>
        <xsl:attribute name="src">http://identi.ca/js/identica-badge.js</xsl:attribute>
      
        <xsl:text>
	          {
	            "user":"ilovefs",
	            "server":"identi.ca",
	            "border":"0px",
	            "background":"none",
	            "width":"360px",
	            "height":"200px"
	          }
	      </xsl:text>
	      
	    </xsl:element>
	  </xsl:element>
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
