<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet [<!ENTITY nbsp "&#160;">]>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="/html[@lang='fr']/body/div">
    <!-- FSF related sites -->
    <table cellspacing="0" cellpadding="0" width="100%" border="0"><tr bgcolor="#e7e7e7"><td><img src="{$fsffrance}/images/pix.png" width="1" height="1" alt="" /></td></tr></table> 
    <table cellspacing="0" cellpadding="1" width="100%" border="0"> 
      <tr valign="middle"> 
	<td class="newstext">
	  &nbsp;&nbsp;
	  <a class="topbanner" href="{$fsfeurope}/index.fr.html">FSF Europe</a>
	</td>
	<td class="newstext" align="right">
	  <a class="topbanner" href="{$fsf}/home.fr.html">FSF</a>
	  &nbsp;&nbsp;|&nbsp;&nbsp;
	  <a class="topbanner" href="{$gnu}/home.fr.html">GNU</a>
	  &nbsp;&nbsp;|&nbsp;&nbsp;
	  <a class="topbanner" href="http://www.april.org/">APRIL</a>
	  &nbsp;&nbsp;|&nbsp;&nbsp;
	  <a class="topbanner" href="http://www.ofset.org/">OFSET</a>
	  &nbsp;&nbsp;|&nbsp;&nbsp;
	  <a class="topbanner" href="http://www.lsfn.org/">LSFN</a>
	</td>
      </tr>
    </table>
    <table cellspacing="0" cellpadding="0" width="100%" border="0">
	<tr valign="middle" bgcolor="#6f6f6f">
	  <td><img src="{$fsffrance}/images/pix.png" width="1" height="1" alt="" /></td>
	</tr>
    </table>

    <!-- Top menu line -->
    <table width="100%" border="0" cellspacing="0" cellpadding="4">
      <tr>
	<td class="TopTitle">
	  &nbsp;Chapitres locaux&nbsp;: <a href="{$fsffrance}/index.fr.html" class="T1">France</a> |
	    Allemagne
	</td>
      </tr>
    </table>

    <!-- Title bar -->
    <table width="100%" border="0" cellspacing="0" cellpadding="4">
	<tr>
	  <td class="TopBody">
	    <a href="{$fsffrance}/index.fr.html">
	      <img src="{$fsffrance}/images/fsfeurope-small.png" alt="FSFE logo" border="0"  />
	    </a>
	  </td>
	  <td class="TopBody" width="99%" height="99%">
	    <a class="TopTitleB">FSF France</a>
	    <br />
	    <a class="TopTitle">Free Software - l'entreprise et l'individu sur un pied d'égalité</a>
	  </td>
	  <td align="right" valign="bottom" class="TopBody">
	    <a href="http://cyberlink.idws.com/fsm/" class="T2">Afrique</a> <br />
	    <a href="http://www.rons.net.cn/english/Links/fsf-china/" class="T2">Chine</a> <br />
	    <a href="http://korea.gnu.org/home.html">Corée</a> <br />
	    <a href="http://es.gnu.org/" class="T2">Espagne</a> <br />
	    <a href="{$fsf}/home.fr.html" class="T2">États-Unis</a> <br />
	    <a href="{$fsfeurope}/index.fr.html" class="T2">Europe</a> <br />
	    <a href="{$fsffrance}/index.fr.html" class="T2">France</a> <br />
	    <a href="http://gnu.org.in/" class="T2">Inde</a> <br />
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
                          <a href="{$fsffrance}/gpl/gpl.fr.html" class="T2">GPL en Français</a>
                       </xsl:otherwise>
                    </xsl:choose><br />
                    <xsl:choose>
                       <xsl:when test="$path='libre.fr.xhtml'">Libertés</xsl:when>
                       <xsl:otherwise>
                          <a href="{$fsffrance}/libre.fr.html" class="T2">Libertés</a>
                       </xsl:otherwise>
                    </xsl:choose><br />
		    <a href="http://www.fsfeurope.org/law/law.fr.html" class="T2">Protéger le logiciel libre</a><br />
		    <xsl:choose>
                       <xsl:when test="$path='collecte.fr.xhtml'">Revue de presse</xsl:when>
                       <xsl:otherwise>
                          <a href="{$fsffrance}/collecte.fr.html" class="T2">Revue de presse</a>
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
                          <a href="{$fsffrance}/index.fr.html" class="T2">Accueil</a>
                       </xsl:otherwise>
                    </xsl:choose><br />
                    <xsl:choose>
                       <xsl:when test="$path='philosophy/philosophy.fr.xhtml'">Philosophie</xsl:when>
                       <xsl:otherwise>
                          <a href="{$fsffrance}/philosophy/philosophy.fr.html" class="T2">Philosophie</a>
                       </xsl:otherwise>
                    </xsl:choose><br />
		    <a href="http://agenda.lolix.org/" class="T2">Agenda</a><br />
                    <xsl:choose>
                       <xsl:when test="$path='news/news.fr.xhtml'">Nouvelles</xsl:when>
                       <xsl:otherwise>
                          <a href="{$fsffrance}/news/news.fr.html" class="T2">Nouvelles</a>
                       </xsl:otherwise>
                    </xsl:choose><br />
                    <xsl:choose>
                       <xsl:when test="$path='events/events.fr.xhtml'">Événements</xsl:when>
                       <xsl:otherwise>
                          <a href="{$fsffrance}/events/events.fr.html" class="T2">Événements</a>
                       </xsl:otherwise>
                    </xsl:choose><br />
		    <a href="http://savannah.gnu.org/pm/task.php?group_project_id=37&amp;group_id=53&amp;func=browse" class="T2">Tâches</a><br />
		    <a href="{$gnu}/jobs/jobsFR.fr.html" class="T2">Emploi</a><br />
                    <xsl:choose>
                       <xsl:when test="$path='press/press.fr.xhtml'">Section presse</xsl:when>
                       <xsl:otherwise>
                          <a href="{$fsffrance}/press/press.fr.html" class="T2">Section presse</a>
                       </xsl:otherwise>
                    </xsl:choose><br />
                    <xsl:choose>
                       <xsl:when test="$path='lists/lists.fr.xhtml'">Listes Diffusion</xsl:when>
                       <xsl:otherwise>
                          <a href="{$fsffrance}/lists/lists.fr.html" class="T2">Listes Diffusion</a>
                       </xsl:otherwise>
                    </xsl:choose><br />
                    <xsl:choose>
                       <xsl:when test="$path='donations/donations.fr.xhtml'">Dons</xsl:when>
                       <xsl:otherwise>
                          <a href="{$fsffrance}/donations/donations.fr.html" class="T2">Dons</a>
                       </xsl:otherwise>
                    </xsl:choose><br />
                    <xsl:choose>
                       <xsl:when test="$path='about/speakers.fr.xhtml'">Intervenants</xsl:when>
                       <xsl:otherwise>
                          <a href="{$fsffrance}/about/speakers.fr.html" class="T2">Intervenants</a>
                       </xsl:otherwise>
                    </xsl:choose><br />
                    <xsl:choose>
                       <xsl:when test="$path='about/about.fr.xhtml'">À propos</xsl:when>
                       <xsl:otherwise>
                          <a href="{$fsffrance}/about/about.fr.html" class="T2">À propos</a>
                       </xsl:otherwise>
                    </xsl:choose><br />
                    <xsl:choose>
                       <xsl:when test="$path='contact.fr.xhtml'">Contact</xsl:when>
                       <xsl:otherwise>
                          <a href="{$fsffrance}/contact.fr.html" class="T2">Contact</a>
                       </xsl:otherwise>
                    </xsl:choose><br />
                    <xsl:choose>
                       <xsl:when test="$path='thanks.fr.xhtml'">Merci !</xsl:when>
                       <xsl:otherwise>
                          <a href="{$fsffrance}/thanks.fr.html" class="T2">Merci !</a> 
                       </xsl:otherwise>
                    </xsl:choose>
		  </td>
		</tr>

		<tr><td class="TopTitle" align="center">Organisations associées</td></tr>
		<tr>
		  <td class="TopBody" align="right">
		    <a href="http://www.april.org/" class="T2">APRIL</a><br />
		    <a href="http://www.ofset.org/" class="T2">OFSET</a><br />
	          </td>
		</tr>

		<tr><td class="TopTitle" align="center">Adminsys</td></tr>
		<tr>
		  <td class="TopBody" align="right">
                    <xsl:choose>
                       <xsl:when test="$path='stats/stats.fr.xhtml'">Statistiques</xsl:when>
                       <xsl:otherwise>
                          <a href="{$fsffrance}/stats/stats.fr.html" class="T2">Statistiques</a>
                       </xsl:otherwise>
                    </xsl:choose><br />
                    <xsl:choose>
                       <xsl:when test="$path='server/server.en.xhtml'">Guide</xsl:when>
                       <xsl:otherwise>
		          <a href="{$fsffrance}/server/server.en.html" class="T2">Guide</a>
                       </xsl:otherwise>
                    </xsl:choose><br />
		    <a href="http://savannah.gnu.org/projects/fsffr/" class="T2">Comptes</a><br />
                    <xsl:choose>
                       <xsl:when test="$path='birth/birth.fr.xhtml'">Naissance</xsl:when>
                       <xsl:otherwise>
                          <a href="{$fsffrance}/birth/birth.fr.html" class="T2">Naissance</a>
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
                          <a href="{$fsffrance}/server/server.en.html#Web" class="T2">Guide</a>
                       </xsl:otherwise>
                    </xsl:choose><br />
		    <a href="{$gnu}/server/standards/" class="T2">Guide GNU</a><br />
                    <xsl:choose>
                       <xsl:when test="$path='boilerplate.fr.xhtml'">Boilerplate</xsl:when>
                       <xsl:otherwise>
                          <a href="{$fsffrance}/boilerplate.fr.html" class="T2">Boilerplate</a>
                       </xsl:otherwise>
                    </xsl:choose><br />
		    <a href="http://mailman.fsfeurope.org/mailman/listinfo/web" class="T2">Mailing List</a><br />
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
          <a href="{$filebase}.xhtml" class="T1">XHTML Source</a>&nbsp;&nbsp;|
          &nbsp;&nbsp;<a href="{$fsffrance}/fsfe-fr.xsl" class="T1">XSL Style
	  Sheet</a>&nbsp;&nbsp;|
          &nbsp;&nbsp;<a href="http://savannah.gnu.org/cgi-bin/viewcvs/fsfe/fr/{$path}?cvsroot=www.gnu.org" class="T1">Modifications</a><br/>
	</td>
	<td class="TopTitle" align="right">
	  &nbsp;<a href="mailto:webmaster@fsfeurope.org"
                   class="T1">webmaster@fsfeurope.org</a>
        </td>
      </tr>
      <tr>
	<td class="Body" align="center">
	<font size="-2">
	    Copyright (C) 2001 FSF France,
	    8 rue de Valois, 75001 Paris, France
	    <br/>
            La reproduction exacte et la distribution intégrale de cet article
            sont permises sur n'importe quel support d'archivage, pourvu que
            cette notice soit préservée.
	</font>
	</td>
        <td class="Body">&nbsp;</td>
      </tr>
    </table>
  </xsl:template> 

<!--
Local Variables: ***
mode: xml ***
End: ***
-->
</xsl:stylesheet>
