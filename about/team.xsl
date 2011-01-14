<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:import href="../tools/xsltsl/countries.xsl" />
  <xsl:output method="xml" encoding="ISO-8859-1" indent="yes"/>
  
  <!-- 
    For documentation on tagging (e.g. display a people list), take a
    look at the documentation under
      /tools/xsltsl/tagging-documentation.txt
  -->
  
  <!-- Fill dynamic content -->
  <xsl:template match="team-members">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'main'" />
    </xsl:call-template>
  </xsl:template>
  
  <!-- Do not copy <set> or <text> to output at all -->
  <xsl:template match="set"/>
  <xsl:template match="text"/>

  <!-- For all other nodes, copy verbatim -->
  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>