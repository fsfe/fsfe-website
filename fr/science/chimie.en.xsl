<?xml version="1.0" encoding="ISO-8859-1" ?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#160;"> ]>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" encoding="ISO-8859-1" 	    
	      doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
	      doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
	      indent="yes" />

  <xsl:template match="/softliste">

<html lang="en">
  <head>
    <title>FSF France - Free software for chemistry</title>
  </head>
  <body>

    <div> <!-- The header will be inserted here -->
      <center>
	[
	<!-- Please keep this list alphabetical -->
	English | <a href="chimie.fr.html">French</a>
	]
      </center>
      <p />

<p align="center"><font size="+2"><b>Free software for chemistry</b></font>
<font size="-2">(Listed by Jérôme Pansanel.)</font>
</p>

  <p align="center">This page lists different free software usefull to
  research in chemistry. It was compiled as part of the <a
  href="science.en.html">Free Software and science</a> project.</p>

  <xsl:apply-templates select="updatenotice"/>

<TABLE CELLPADDING="10" RULES="all" BORDER="1">
<TR>
<TH>Name</TH>
<TH>Description</TH>
<TH>URL</TH>
<TH>License</TH>
</TR>

      <xsl:apply-templates select="software"/>      

</TABLE>

    </div> <!-- The footer will be inserted here -->

    Updated:
    <!-- timestamp start -->
    $Date: 2002-04-22 11:05:39 $ $Author: loic $
    <!-- timestamp end -->

  </body>
    </html>
  </xsl:template>

  <xsl:template match="/softliste/software">
<TR>
<TD><b><xsl:value-of select="name" /></b><br />(<xsl:value-of select="date" />)</TD>
<TD><xsl:value-of select="description[@lang='en']" /></TD>
<TD><a href="{url}"><xsl:value-of select="url" /></a></TD>
<TD>Version <xsl:value-of select="os[@name='GNU/Linux']/version" />: <xsl:value-of select="os[@name='GNU/Linux']/license" /></TD>
</TR>
  </xsl:template>

<!--  <xsl:include href="chimie.xsl" /> -->

<xsl:template match="updatenotice">
    <i>List updated : <xsl:apply-templates select="@*|node()"/></i>
</xsl:template>

  <xsl:template match="@*|node()" priority="-1">
    <xsl:apply-templates select="@*|node()"/>
  </xsl:template>

  <!--
  Local Variables: ***
  mode: xml ***
  End: ***
  -->
</xsl:stylesheet>
