<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet [<!ENTITY nbsp "&#160;">]>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="/html[@lang='fr']/body/div">
    <!-- $Id: navigation.fr.xsl,v 1.16 2002-12-21 13:43:08 rodolphe Exp $ -->
    <!-- $Source: /root/wrk/fsfe-web/savannah-rsync/fsfe/fr/eucd/navigation.fr.xsl,v $ -->
    <!-- Top menu line -->
    <table border="1" cellpadding="5" cellspacing="10" class="main">
      <tr>
	<td colspan="2">
	  <span><a href="http://eucd.info/">EUCD.INFO</a> - Au <a href="donations.fr.php">secours</a> de la copie privée</span>
	</td>
      </tr>
      
      <tr>
	<td valign="top">
	  <a href="index.fr.php">Accueil</a><br />
	  <a href="revue.fr.php">Presse</a><br />
	  <a href="donations.fr.php">Aider</a><br />
	  <a href="transparence.fr.php">Transparence</a><br />

	  <br/>
	  <a href="eucd.fr.php">Analyse</a><br />
	  <a href="http://wiki.ael.be/index.php/EUCD-Status">Situation</a><br />
	  <a href="http://mail.gnu.org/mailman/listinfo/fsfe-france">Discuter</a><br />
	  <a href="who.fr.php">Qui</a><br />
	  <br />
	  <br />
	  <a href="donations.fr.php">Dons</a><br />	  
	  <script language="php">
	    if (file_exists)
	    {
	    require("thermometer.php");
	    print moneyMeter($totaal_ontvangen+$post_donaties+$post_sponsoring, $totaal_pending, $post_intent);
	    }
	  </script>

	</td>
	
	<td valign="top">
	  
	  <xsl:apply-templates select="@*|node()"/>

	</td>
      </tr>
      
    </table>
    <address><a href="mailto:contact@eucd.info">Contact:</a> EUCD.INFO c/o FSF France 8, rue de valois, 75001 Paris - Tel: 01 42 76 05 49 - Mail: <a href="mailto:contact@eucd.info">contact@eucd.info</a> - Web: <a href="http://eucd.info/">http://eucd.info/</a></address>
  </xsl:template> 

<!--
Local Variables: ***
mode: xml ***
End: ***
-->
</xsl:stylesheet>
