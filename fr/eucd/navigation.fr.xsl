<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet [<!ENTITY nbsp "&#160;">]>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="/html[@lang='fr']/body/div">

    <!-- Top menu line -->
    <table border="1" cellpadding="5" cellspacing="10" class="main">
      <tr>
	<td colspan="2">
	  <span>EUCD.INFO</span>
	</td>
      </tr>
      
      <tr>
	<td valign="top">
	  <a href="/">Home</a><br />
	  <a href="statut.fr.html">Statut</a><br />
	  <a href="revue.fr.html">Presse</a><br />
	  <a href="donations.fr.html">Dons</a><br />
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
