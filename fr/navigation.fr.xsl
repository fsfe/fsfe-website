<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet [<!ENTITY nbsp "&#160;">]>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="/html[@lang='fr']/body/div">
    <!-- FSF related sites -->
    <table cellspacing="0" cellpadding="1" width="100%" border="0"> 
      <tr valign="middle"> 
	<td class="newstext">
	  &nbsp;&nbsp;
	  <a href="{$fsfeurope}/index.fr.html">FSF Europe</a>
	</td>
	<td class="newstext" align="right">
	  <a href="{$fsf}/home.fr.html">FSF</a>
	  &nbsp;&nbsp;|&nbsp;&nbsp;
	  <a href="{$gnu}/home.fr.html">GNU</a>
	  &nbsp;&nbsp;|&nbsp;&nbsp;
	  <a href="http://es.gnu.org/">GNU Espagne</a>
	</td>
      </tr>
    </table>

    <!-- Title bar -->
    <table width="100%" border="0" cellspacing="0" cellpadding="8">
      <tr>
	<td class="TopBody">
	  <a href="{$fsfeurope}/index.fr.html">
	    <img src="{$fsffrance}/images/fsfe-logo.png" alt="to FSFE Logo"
	      border="0" width="259" height="76" align="left"/>
	  </a>
	</td>
	<td class="TopBody">
	  FSF Europe Chapter France
	</td>
	<td align="right" valign="bottom" class="TopBody">
	  <table>
	    <tr>
	      <td>
		<a href="http://cyberlink.idws.com/fsm/">Afrique</a> <br />
		<a href="http://www.fsf.or.at/">Autriche</a> <br />
		<a href="http://www.rons.net.cn/english/Links/fsf-china/">Chine</a> <br />
		<a href="http://korea.gnu.org/home.html">Corée</a> <br />
	      </td>
	      <td>
		<a href="http://es.gnu.org/">Espagne</a> <br />
		<a href="{$fsf}/home.fr.html">États-Unis</a> <br />
		<a href="{$fsfeurope}/index.fr.html">Europe</a> <br />
		<a href="{$fsffrance}/index.fr.html">France</a> <br />
	      </td>
	      <td>
		<a href="http://fsf.org.in/">Inde</a> <br />
		<a href="http://www.gnulinux.org.mx/">Mexique</a> <br />
		<a href="http://www.ansol.org/">Portugal</a> <br />
		<a href="http://www.gnu.cz/">République Tchèque</a> <br />
	      </td>
	    </tr>
	  </table>
	</td>
      </tr>
    </table>

    <table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
	<td width="99%" valign="top">
	  <div class="content">
	    <xsl:apply-templates select="@*|node()"/>
	  </div>
	</td>
	<!-- Menu column. On the right to be Lynx friendly.  -->
	<td>&nbsp;</td>
	<td valign="top" class="TopBody">
	  <table summary="" width="150" border="0" cellspacing="0" cellpadding="4">
	    <tr><td class="TopTitle" align="center">Projets</td></tr>
	    <tr>
	      <td class="TopBody" align="right">
		<a href="{$fsffrance}/gpl/gpl.fr.html">GPL en Français</a><br />
		<a href="{$fsffrance}/libre.fr.html">Libertés</a><br />
		<a href="http://www.fsfeurope.org/law/law.fr.html">Protéger le logiciel libre</a><br />

		<a href="{$fsffrance}/collecte/collecte.fr.html">Revue de presse</a><br />
		<a href="{$fsffrance}/voting/voting.en.html">E-Vote</a><br />
		<a href="{$fsffrance}/dcssi/dcssi.fr.html">DCSSI</a><br />
		<a href="{$fsfeurope}/coposys/index.fr.html">Coposys</a><br />
		<a href="{$fsfeurope}/documents/whyfs.fr.html">Pourquoi nous parlons de Logiciel Libre</a><br />
		<a href="{$fsffrance}/science/science.fr.html">Sciences et LL</a><br />
	      </td>
	    </tr>
	    <tr><td class="TopTitle" align="center">Sections</td></tr>
	    <tr>
	      <td class="TopBody" align="right">
		<a href="{$fsffrance}/index.fr.html">Accueil</a><br />
		<a href="{$fsffrance}/philosophy/philosophy.fr.html">Philosophie</a><br />
		<a href="http://agenda.lolix.org/">Agenda</a><br />
		<a href="{$fsffrance}/news/news.fr.html">Nouvelles</a><br />
		<a href="http://savannah.gnu.org/pm/task.php?group_project_id=37&amp;group_id=53&amp;func=browse">Tâches</a><br />
		<a href="{$gnu}/jobs/jobsFR.fr.html">Emploi</a><br />
		<a href="{$fsffrance}/press/press.fr.html">Section presse</a><br />
		<a href="{$fsffrance}/lists/lists.fr.html">Listes Diffusion</a><br />
		<a href="{$fsffrance}/donations/donations.fr.html">Dons</a><br />
		<a href="{$fsffrance}/about/speakers.fr.html">Intervenants</a><br />
		<a href="{$fsffrance}/about/about.fr.html">À propos</a><br />
		<a href="{$fsffrance}/contact.fr.html">Contact</a><br />
		<a href="{$fsffrance}/thanks.fr.html">Merci !</a><br />
		<a href="{$fsfeurope}/order/announce.fr.html">Articles FSFE</a>
	      </td>
	    </tr>

	    <tr><td class="TopTitle" align="center">Organisations associées</td></tr>
	    <tr>
	      <td class="TopBody" align="right">
		<a href="http://www.april.org/">APRIL</a><br />
		<a href="http://www.ansol.org/">ANSOL</a><br />
	     	<a href="http://www.softwarelibero.it">AsSoLi</a><br />
		<a href="http://www.fsf.or.at/">FFS</a><br />
		<a href="http://www.ofset.org/">OFSET</a><br />
	      </td>
	    </tr>

	    <tr><td class="TopTitle" align="center">Adminsys</td></tr>
	    <tr>
	      <td class="TopBody" align="right">
		<a href="{$fsffrance}/stats/stats.fr.html">Statistiques</a><br />
		<a href="{$fsffrance}/server/server.en.html">Guide</a><br />
		<a href="http://savannah.gnu.org/projects/fsffr/">Comptes</a><br />
		<a href="{$fsffrance}/birth/birth.fr.html">Naissance</a><br />
	      </td>
	    </tr>
	    <tr><td class="TopTitle" align="center">Webmaster</td></tr>
	    <tr>
	      <td class="TopBody" align="right">
		<a href="{$fsffrance}/server/server.en.html#Web">Guide</a><br />
		<a href="{$gnu}/server/standards/">Guide GNU</a><br />
		<a href="{$fsffrance}/boilerplate.fr.html">Boilerplate</a><br />
		<a href="http://mailman.fsfeurope.org/mailman/listinfo/web">Mailing List</a><br />
	      </td>
	    </tr>
	  </table>
	</td>
      </tr>
    </table>

    <!-- Bottom line -->
    <table width="100%" border="0" cellspacing="0" cellpadding="2">
      <tr>
	<td class="TopTitle">
          <a href="{$filebase}.xhtml">XHTML Source</a>&nbsp;&nbsp;|
          &nbsp;&nbsp;<a href="{$fsffrance}/fsfe-fr.xsl">XSL Style
	    Sheet</a>&nbsp;&nbsp;|
          &nbsp;&nbsp;<a href="http://savannah.gnu.org/cgi-bin/viewcvs/fsfe/fr/{$path}?cvsroot=www.gnu.org">Modifications</a><br/>
	</td>
	<td class="TopTitle" align="right">
	  &nbsp;<a href="mailto:webmaster@fsfeurope.org"
	    >webmaster@fsfeurope.org</a>
        </td>
      </tr>
      <tr>
	<td class="newstext" align="center">
	  <font size="-2">
	    Copyright (C) 2002 FSF Europe Chapter France,
	    8 rue de Valois, 75001 Paris, France
	    <br/>
            La reproduction exacte et la distribution intégrale de cet article
            sont permises sur n'importe quel support d'archivage, pourvu que
            cette notice soit préservée.
	  </font>
	</td>
        <td class="newstext">&nbsp;</td>
      </tr>
    </table>
  </xsl:template> 

<!--
Local Variables: ***
mode: xml ***
End: ***
-->
</xsl:stylesheet>
