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
	  <a href="http://www.april.org/">APRIL</a>
	  &nbsp;&nbsp;|&nbsp;&nbsp;
	  <a href="http://www.ofset.org/">OFSET</a>
	</td>
      </tr>
    </table>

    <!-- Top menu line -->
    <table width="100%" border="0" cellspacing="0" cellpadding="4">
      <tr>
	<td class="TopTitle">
	  &nbsp;Chapitres locaux&nbsp;: <a href="{$fsffrance}/index.fr.html">France</a> |
	    Allemagne
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
<!-- If we are on the top level page of the local chapter's site, the
icon links to the top of the hub's site -->
        <xsl:choose>
        <xsl:when test="$path='index.fr.xhtml'">
	  Chapitre Français
        </xsl:when>
        <!-- otherwise, link to the top of the local chapter's site -->
        <xsl:otherwise>
	  <a href="{$fsffrance}/index.en.html">French Chapter</a>
        </xsl:otherwise>
        </xsl:choose>
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
                    <xsl:choose>
                       <xsl:when test="$path='gpl/gpl.fr.xhtml'">GPL en Français</xsl:when>
                       <xsl:otherwise>
                          <a href="{$fsffrance}/gpl/gpl.fr.html">GPL en Français</a>
                       </xsl:otherwise>
                    </xsl:choose><br />
                    <xsl:choose>
                       <xsl:when test="$path='libre.fr.xhtml'">Libertés</xsl:when>
                       <xsl:otherwise>
                          <a href="{$fsffrance}/libre.fr.html">Libertés</a>
                       </xsl:otherwise>
                    </xsl:choose><br />
		    <a href="http://www.fsfeurope.org/law/law.fr.html">Protéger le logiciel libre</a><br />
		    <xsl:choose>
                       <xsl:when test="$path='collecte/collecte.fr.xhtml'">Revue de presse</xsl:when>
                       <xsl:otherwise>
                          <a href="{$fsffrance}/collecte/collecte.fr.html">Revue de presse</a>
                       </xsl:otherwise>
                    </xsl:choose><br />
		    <xsl:choose>
                       <xsl:when test="$path=voting.en.xhtml">E-Vote</xsl:when>
                       <xsl:otherwise>
                          <a href="{$fsffrance}/voting/voting.en.html">E-Vote</a>
                       </xsl:otherwise>
                    </xsl:choose><br />
	          </td>
		</tr>
		<tr><td class="TopTitle" align="center">FSF France</td></tr>
		<tr>
		  <td class="TopBody" align="right">
                    <xsl:choose>
                       <xsl:when test="$path='index.fr.xhtml'">Accueil</xsl:when>
                       <xsl:otherwise>
                          <a href="{$fsffrance}/index.fr.html">Accueil</a>
                       </xsl:otherwise>
                    </xsl:choose><br />
                    <xsl:choose>
                       <xsl:when test="$path='philosophy/philosophy.fr.xhtml'">Philosophie</xsl:when>
                       <xsl:otherwise>
                          <a href="{$fsffrance}/philosophy/philosophy.fr.html">Philosophie</a>
                       </xsl:otherwise>
                    </xsl:choose><br />
		    <a href="http://agenda.lolix.org/">Agenda</a><br />
                    <xsl:choose>
                       <xsl:when test="$path='news/news.fr.xhtml'">Nouvelles</xsl:when>
                       <xsl:otherwise>
                          <a href="{$fsffrance}/news/news.fr.html">Nouvelles</a>
                       </xsl:otherwise>
                    </xsl:choose><br />
                    <xsl:choose>
                       <xsl:when test="$path='events/events.fr.xhtml'">Événements</xsl:when>
                       <xsl:otherwise>
                          <a href="{$fsffrance}/events/events.fr.html">Événements</a>
                       </xsl:otherwise>
                    </xsl:choose><br />
		    <a href="http://savannah.gnu.org/pm/task.php?group_project_id=37&amp;group_id=53&amp;func=browse">Tâches</a><br />
		    <a href="{$gnu}/jobs/jobsFR.fr.html">Emploi</a><br />
                    <xsl:choose>
                       <xsl:when test="$path='press/press.fr.xhtml'">Section presse</xsl:when>
                       <xsl:otherwise>
                          <a href="{$fsffrance}/press/press.fr.html">Section presse</a>
                       </xsl:otherwise>
                    </xsl:choose><br />
                    <xsl:choose>
                       <xsl:when test="$path='lists/lists.fr.xhtml'">Listes Diffusion</xsl:when>
                       <xsl:otherwise>
                          <a href="{$fsffrance}/lists/lists.fr.html">Listes Diffusion</a>
                       </xsl:otherwise>
                    </xsl:choose><br />
                    <xsl:choose>
                       <xsl:when test="$path='donations/donations.fr.xhtml'">Dons</xsl:when>
                       <xsl:otherwise>
                          <a href="{$fsffrance}/donations/donations.fr.html">Dons</a>
                       </xsl:otherwise>
                    </xsl:choose><br />
                    <xsl:choose>
                       <xsl:when test="$path='about/speakers.fr.xhtml'">Intervenants</xsl:when>
                       <xsl:otherwise>
                          <a href="{$fsffrance}/about/speakers.fr.html">Intervenants</a>
                       </xsl:otherwise>
                    </xsl:choose><br />
                    <xsl:choose>
                       <xsl:when test="$path='about/about.fr.xhtml'">À propos</xsl:when>
                       <xsl:otherwise>
                          <a href="{$fsffrance}/about/about.fr.html">À propos</a>
                       </xsl:otherwise>
                    </xsl:choose><br />
                    <xsl:choose>
                       <xsl:when test="$path='contact.fr.xhtml'">Contact</xsl:when>
                       <xsl:otherwise>
                          <a href="{$fsffrance}/contact.fr.html">Contact</a>
                       </xsl:otherwise>
                    </xsl:choose><br />
                    <xsl:choose>
                       <xsl:when test="$path='thanks.fr.xhtml'">Merci !</xsl:when>
                       <xsl:otherwise>
                          <a href="{$fsffrance}/thanks.fr.html">Merci !</a> 
                       </xsl:otherwise>
                    </xsl:choose>
		  </td>
		</tr>

		<tr><td class="TopTitle" align="center">Organisations associées</td></tr>
		<tr>
		  <td class="TopBody" align="right">
		    <a href="http://www.april.org/">APRIL</a><br />
	     	<a href="http://www.softwarelibero.it">AsSoLi</a><br />
		    <a href="http://www.fsf.or.at/">FFS</a><br />
		    <a href="http://www.ofset.org/">OFSET</a><br />
	          </td>
		</tr>

		<tr><td class="TopTitle" align="center">Adminsys</td></tr>
		<tr>
		  <td class="TopBody" align="right">
                    <xsl:choose>
                       <xsl:when test="$path='stats/stats.fr.xhtml'">Statistiques</xsl:when>
                       <xsl:otherwise>
                          <a href="{$fsffrance}/stats/stats.fr.html">Statistiques</a>
                       </xsl:otherwise>
                    </xsl:choose><br />
                    <xsl:choose>
                       <xsl:when test="$path='server/server.en.xhtml'">Guide</xsl:when>
                       <xsl:otherwise>
		          <a href="{$fsffrance}/server/server.en.html">Guide</a>
                       </xsl:otherwise>
                    </xsl:choose><br />
		    <a href="http://savannah.gnu.org/projects/fsffr/">Comptes</a><br />
                    <xsl:choose>
                       <xsl:when test="$path='birth/birth.fr.xhtml'">Naissance</xsl:when>
                       <xsl:otherwise>
                          <a href="{$fsffrance}/birth/birth.fr.html">Naissance</a>
                       </xsl:otherwise>
                    </xsl:choose><br />
		  </td>
		</tr>
		<tr><td class="TopTitle" align="center">Webmaster</td></tr>
		<tr>
		  <td class="TopBody" align="right">
                    <xsl:choose>
                       <xsl:when test="$path='server/server.en.html#Web'">Guide</xsl:when>
                       <xsl:otherwise>
                          <a href="{$fsffrance}/server/server.en.html#Web">Guide</a>
                       </xsl:otherwise>
                    </xsl:choose><br />
		    <a href="{$gnu}/server/standards/">Guide GNU</a><br />
                    <xsl:choose>
                       <xsl:when test="$path='boilerplate.fr.xhtml'">Boilerplate</xsl:when>
                       <xsl:otherwise>
                          <a href="{$fsffrance}/boilerplate.fr.html">Boilerplate</a>
                       </xsl:otherwise>
                    </xsl:choose><br />
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
	    Copyright (C) 2001 FSF France,
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
