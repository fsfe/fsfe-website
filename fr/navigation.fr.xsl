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
	  <a class="topbanner" href="http://es.gnu.org/">GNU Espagne</a>
	  &nbsp;&nbsp;|&nbsp;&nbsp;
	  <a class="topbanner" href="http://www.april.org/">April</a>
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
	  &nbsp;<a href="{$fsffrance}/index.fr.html" class="T1">France</a> |
	    Allemagne
	</td>
      </tr>
    </table>

    <!-- Title bar -->
    <table width="100%" border="0" cellspacing="0" cellpadding="4">
	<tr>
	  <td class="TopBody">
	    <a href="{$fsffrance}/index.fr.html">
	      <img src="{$fsffrance}/images/gnulogo.jpg" alt="GNU Logo" border="0" />
	    </a>
	  </td>
	  <td class="TopBody" width="99%" height="99%">
	    <a class="TopTitleB">FSF France</a>
	    <br />
	    <a class="TopTitle">Le Logiciel Libre est la conscience du logiciel</a>
	  </td>
	  <td align="right" valign="bottom" class="TopBody">
	    <a href="{$fsffrance}/index.fr.html" class="T2">France</a> <br />
	    <a href="{$fsfeurope}/index.fr.html" class="T2">Europe</a> <br />
	    <a href="{$fsf}/home.fr.html" class="T2">Etats-Unis</a> <br />
	  </td>
	</tr>
    </table>

    <table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
	  <td width="99%" valign="top">
	  <xsl:apply-templates select="@*|node()"/>
	  </td>

	  <!-- Menu column. On the right to be Lynx friendly.  -->
	  <td>&nbsp;</td>
	  <td valign="top" class="TopBody">
	    <table width="120" border="0" cellspacing="0" cellpadding="4">
		<tr><td class="TopTitle" align="center">FSF France</td></tr>
		<tr>
		  <td class="TopBody" align="right">
		    <a href="http://agenda.lolix.org/" class="T2">Agenda</a><br />
		    <a href="{$fsffrance}/news/news.fr.html" class="T2">Nouvelles</a><br />
		    <a href="http://savannah.gnu.org/pm/task.php?group_project_id=37&amp;group_id=53&amp;func=browse" class="T2">Tâches</a><br />
		    <a href="{$gnu}/jobs/jobsFR.fr.html" class="T2">Emploi</a><br />
		    <a href="{$fsffrance}/press/press.fr.html" class="T2">Section presse</a><br />
		    <a href="http://mail.gnu.org/mailman/listinfo/fsfe-france" class="T2">Mailing List</a><br />
		    <a href="http://savannah.gnu.org/project/memberlist.php?group_id=148" class="T2">Who's who</a><br />
		    <a href="{$fsffrance}/about/about.fr.html" class="T2">A propos</a><br />
		    <a href="{$fsffrance}/contact.fr.html" class="T2">Contact</a> <br />
		    <a href="{$fsffrance}/thanks.fr.html" class="T2">Merci!</a> 
		  </td>
		</tr>
		<tr><td class="TopTitle" align="center">Adminsys</td></tr>
		<tr>
		  <td class="TopBody" align="right">
		    <a href="{$fsffrance}/stats/stats.fr.html" class="T2">Statistiques</a> <br />
		    <a href="{$fsffrance}/server/server.en.html" class="T2">Guide</a><br />
		    <a href="http://savannah.gnu.org/projects/fsffr/" class="T2">Comptes</a><br />
		    <a href="{$fsffrance}/birth/birth.fr.html" class="T2">Naissance</a><br />
		  </td>
		</tr>
		<tr><td class="TopTitle" align="center">Webmaster</td></tr>
		<tr>
		  <td class="TopBody" align="right">
		    <a href="{$fsffrance}/server/server.en.html#Web" class="T2">Guide</a><br />
		    <a href="{$gnu}/server/standards/" class="T2">Guide GNU</a><br />
		    <a href="{$fsffrance}/boilerplate.fr.html" class="T2">Boilerplate</a><br />
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
