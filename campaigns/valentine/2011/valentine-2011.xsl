<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../../../fsfe.xsl" />

  <!-- The top level element of the input file is "buildinfo" -->
  <xsl:template match="buildinfo">
    <xsl:apply-templates select="node()"/>
  </xsl:template>

  <xsl:template match="identica">
    <!--<xsl:element name="div">
      <xsl:attribute name="class">entry</xsl:attribute>
      <xsl:attribute name="style">float: right;</xsl:attribute>

      <xsl:element name="script">
        <xsl:attribute name="type">text/javascript</xsl:attribute>
        <xsl:attribute name="src">http://identi.ca/js/identica-badge.js</xsl:attribute>

        <xsl:text>
	          {
	            "user":"ireallylovefs",
	            "server":"identi.ca",
	            "border":"0px",
	            "background":"none",
	            "width":"360px",
	            "height":"200px"
	          }
	      </xsl:text>
	
	    </xsl:element>
	  </xsl:element>-->
  </xsl:template>

</xsl:stylesheet>
