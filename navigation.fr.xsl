<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet [<!ENTITY nbsp "&#160;">]>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="/html[@lang='fr']/body/div">
    <!-- FSF related sites -->
    <table cellspacing="0" cellpadding="0" width="100%" border="0"><tr bgcolor="#e7e7e7"><td><img src="{$fsfeurope}/images/pix.png" width="1" height="1" alt="" /></td></tr></table> 
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
	    <a class="topbanner" href="http://es.gnu.org/">GNU Espagne</a><br/>
	  </td>
       </tr>
    </table>
    <table cellspacing="0" cellpadding="0" width="100%" border="0">
	<tr valign="middle" bgcolor="#6f6f6f">
	  <td><img src="{$fsfeurope}/images/pix.png" width="1" height="1" alt="" /></td>
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
	  <!--
	    <a href="{$fsfeurope}/index.fr.html">
	      <img src="{$fsfeurope}/images/gnulogo.jpg" alt="GNU Logo" border="0" />
	    </a>
	  --> &nbsp;
	  </td>
	  <td class="TopBody" width="99%" height="99%">
	    <a class="TopTitleB">FSF Europe</a>
	    <br/>
	    <a class="TopTitle">Free Software - l'entreprise et l'individu sur un pied d'égalité</a>
	  </td>
	  <td align="right" valign="top" class="TopBody">
	    <a href="{$fsfeurope}/documents/freesoftware.fr.html" class="T2">Qu'est-ce&nbsp;que&nbsp;le&nbsp;Logiciel&nbsp;Libre?</a><br/>
	    <a href="{$fsfeurope}/documents/gnuproject.fr.html" class="T2">Qu'est-ce&nbsp;que&nbsp;le&nbsp;Projet&nbsp;GNU?</a><br/>
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
          <table summary="" width="150" border="0" cellspacing="0"
          cellpadding="4">
            <tr>
              <td class="TopTitle" align="center">Sections</td>
            </tr>
            <tr>
              <td align="right"><br/>
              <a href="{$fsfeurope}/index.fr.html" class="T2">Accueil</a><br/>
              <a href="{$fsfeurope}/contact/index.fr.html"
                    class="T2">Contact</a><br/>
              <a href="{$fsfeurope}/background.fr.html"
                   class="T2">Contexte</a><br/>
              <a href="{$fsfeurope}/mailman/index.fr.html"
                   class="T2">Listes de diffusion</a><br/>
              <a href="{$fsfeurope}/press/index.fr.html"
                   class="T2">Section Presse</a><br/>
              <a href="{$fsfeurope}/gbn/index.fr.html"
                   class="T2">GNU Business Network</a><br/>
              <br/></td>
            </tr>
            <tr>
              <td class="TopTitle" align="center">Admin</td>
            </tr>
            <tr>
              <td align="right"><br/>
              <a href="http://savannah.gnu.org/projects/fsfe/"
                   class="T2">Résumé du Projet</a><br/>
              <a href="http://www.gnu.org/server/standards/"
                   class="T2">Guide GNU</a><br/>
              <a href="http://savannah.gnu.org/pm/?group_id=53"
                   class="T2">Tâches</a><br/>
              <br/></td>
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
          &nbsp;&nbsp;<a href="{$fsfeurope}/fsfe.xsl" class="T1">XSL Style
	  Sheet</a>&nbsp;&nbsp;|
          &nbsp;&nbsp;<a href="http://savannah.gnu.org/cgi-bin/viewcvs/fsfe/{$path}?cvsroot=www.gnu.org" class="T1">Modifications</a><br/>
	</td>
	<td class="TopTitle" align="right">
	  &nbsp;<a href="mailto:webmaster@fsfeurope.org"
                   class="T1">webmaster@fsfeurope.org</a>
        </td>
      </tr>
      <tr>
	<td class="Body" align="center">
	<font size="-2">
	  Copyright (C) 2001 FSF Europe<br/>
            La reproduction exacte et la distribution intégrale de cet article
            sont permises sur n'importe quel support d'archivage, pourvu que
            cette notice soit préservée.
	</font>
	</td>
        <td class="Body">&nbsp;</td>
      </tr>
    </table>
  </xsl:template> 

</xsl:stylesheet>

