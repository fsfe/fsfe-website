<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet [<!ENTITY nbsp "&#160;">]>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="/html[@lang='fr']/body/div">
    <!-- $Id: navigation.fr.xsl,v 1.5 2002-12-17 11:18:15 loic Exp $ -->
    <!-- $Source: /root/wrk/fsfe-web/savannah-rsync/fsfe/fr/eucd/navigation.fr.xsl,v $ -->
    <!-- Top menu line -->
    <table border="1" cellpadding="5" cellspacing="10" class="main">
      <tr>
	<td colspan="2">
	  <span>EUCD.INFO - Au secours de la copie privée</span>
	</td>
      </tr>
      
      <tr>
	<td valign="top">
	  <a href="index.fr.html">Accueil</a><br />
	  <a href="revue.fr.html">Presse</a><br />
	  <a href="donations.fr.html">Participer</a><br />

	  <br/>
	  <a href="eucd.fr.html">Analyse</a><br />
	  <a href="http://wiki.ael.be/index.php/EUCD-Status">Situation</a><br />
	</td>
	
	<td>
	  
	  <xsl:apply-templates select="@*|node()"/>

	</td>
      </tr>
      
    </table>
    <address><a href="mailto:www@france.fsfeurope.org">Virtual Webmaster</a></address>
  </xsl:template> 

<!--
Local Variables: ***
mode: xml ***
End: ***
-->
</xsl:stylesheet>
