<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet [<!ENTITY nbsp "&#160;">]>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" encoding="ISO-8859-1" 	    
	      doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
	      doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
	      indent="yes" />

<xsl:template match="/softliste">

 <html lang="fr">
  <head>
    <title>FSF France - Logiciel libre pour la chimie</title>
  </head>
  <body>

    <div> <!-- The header will be inserted here -->
      <center>
	[
	<!-- Please keep this list alphabetical -->
	<a href="chimie.en.html">Anglais</a> | Français
	]
      </center>
      <p />

  <p align="center"><font size="+2"><b>Logiciel libre pour la chimie</b></font>
  <font size="-2">(Listée par Jérôme Pansanel.)</font>
  </p>

  <xsl:apply-templates select="updatenotice"/>

  <TABLE CELLPADDING="10" RULES="all" BORDER="1">
    <TR>
     <TH>Nom</TH>
     <TH>Description</TH>
     <TH>URL</TH>
    </TR>
      
	    <xsl:apply-templates select="software"/>      
  </TABLE>

  </div> <!-- The footer will be inserted here -->


    Mis à jour:
    <!-- timestamp start -->
    $Date: 2001-12-29 14:22:37 $ $Author: olberger $
    <!-- timestamp end -->


  </body>
 </html>
</xsl:template>

  <xsl:template match="/softliste/software">
<TR>
<TD><b><xsl:value-of select="name" /></b><br />(<xsl:value-of select="date" />)</TD>
<TD><xsl:value-of select="description[@lang='fr']" /></TD>
<TD><a href="{url}"><xsl:value-of select="url" /></a></TD>
</TR>
  </xsl:template>

<!-- <xsl:include href="chimie.xsl" /> -->

<xsl:template match="updatenotice">
    <i>Liste mise à jour : <xsl:apply-templates select="@*|node()"/></i>
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
