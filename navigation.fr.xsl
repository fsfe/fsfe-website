<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet [<!ENTITY nbsp "&#160;">
                          <!ENTITY eur "&#128;">]>
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
	    <a href="http://es.gnu.org/">GNU Espagne</a><br/>
	  </td>
       </tr>
    </table>

    <!-- Top menu line -->
    <table width="100%" border="0" cellspacing="0" cellpadding="4">
      <tr>
	<td class="TopTitle">
	  &nbsp;<a href="{$fsffrance}/index.fr.html">France</a> |
	    Allemagne
	</td>
      </tr>
    </table>

    <!-- Title bar -->
    <table width="100%" border="0" cellspacing="0" cellpadding="8">
	<tr>
	  <td class="TopBody">
	    <a href="{$fsfeurope}/">
	      <img src="{$fsfeurope}/images/fsfe-logo.png" alt="FSFE Logo"
    border="0" width="259" height="76" align="left"/>
	    </a>
	  </td>
	</tr>
    </table>

    <table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
	<td width="99%" valign="top">
        <div class="content">
        <center>
        <xsl:value-of select="$langlinks" disable-output-escaping="yes"/>
        </center>
	<xsl:apply-templates select="@*|node()"/>
        </div>
	</td>
	<!-- Menu column. On the right to be Lynx friendly.  -->
	<td>&nbsp;</td>
	<td valign="top" class="TopBody">
          <table summary="" width="150" border="0" cellspacing="0"
          cellpadding="4">

   	    <tr>
              <td class="TopTitle" align="center">Projets</td></tr>
		<tr>
		  <td class="TopBody" align="right">
		    <a href="{$fsfeurope}/law/law.fr.html">Protéger le Logiciel Libre</a><br />
		    <a href="{$fsfeurope}/coposys/index.fr.html">Coposys</a><br />
		    <a href="{$fsfeurope}/documents/whyfs.fr.html">Pourquoi nous parlons de Logiciel Libre</a><br />
                  <a href="{$fsfeurope}/education/education.fr.html">Logiciel et Libre Éducation</a>
                  <a href="{$fsfeurope}/law/eucd/eucd.fr.html">EUCD</a>
		  </td>
		</tr>

            <tr>
              <td class="TopTitle" align="center">Sections</td>
            </tr>
            <tr>
              <td align="right" class="TopBody"><br/>
              <xsl:choose>
                <xsl:when test="$path='index.fr.xhtml'">Accueil</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/index.fr.html">Accueil</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='contact/contact.fr.xhtml'">Contact</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/contact/contact.fr.html">Contact</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='about/index.xhtml'">À propos</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/about/index.html">À propos</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='background.fr.xhtml'">Contexte</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/background.fr.html">Contexte</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='documents/documents.fr.xhtml'">Documents</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/documents/documents.fr.html">Documents</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='mailman/index.fr.xhtml'">Listes de diffusion</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/mailman/index.fr.html">Listes de diffusion</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='news/news.fr.xhtml'">Nouvelles</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/news/news.fr.html">Nouvelles</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='events/events.fr.xhtml'">Evènements</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/events/events.fr.html">Evènements</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='press/index.fr.xhtml'">Section Presse</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/press/index.fr.html">Section Presse</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='speakers/speakers.fr.xhtml'">Intervenants</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/speakers/speakers.fr.html">Intervenants</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='gbn/index.fr.xhtml'">GNU Business Network</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/gbn/index.fr.html">GNU Business Network</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='order/announce.fr.xhtml'">Articles FSFE</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/order/announce.fr.html">Articles FSFE</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <br/></td>
            </tr>

            <tr><td class="TopTitle" align="center">Organisations associées</td></tr>
		<tr>
		  <td class="TopBody" align="right">
		    <a href="http://www.ansol.org/">ANSOL</a><br />
		    <a href="http://www.april.org/">APRIL</a><br />
                    <a href="http://www.softwarelibero.it">AsSoLi</a><br />
		    <a href="http://www.fsf.or.at">FFS</a><br />
		    <a href="http://www.ofset.org/">OFSET</a><br />
	          </td>
		</tr>

            <tr>
              <td class="TopTitle" align="center">Admin</td>
            </tr>
            <tr>
              <td align="right"><br/>
              <a href="http://savannah.gnu.org/projects/fsfe/"
                  >Résumé du Projet</a><br/>
              <a href="http://www.gnu.org/server/standards/"
                  >Guide GNU</a><br/>
              <a href="http://savannah.gnu.org/pm/?group_id=53"
                  >Tâches</a><br/>
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
          <a href="{$filebase}.xhtml">XHTML Source</a>&nbsp;&nbsp;|
          &nbsp;&nbsp;<a href="{$fsfeurope}/fsfe.xsl">XSL Style
	  Sheet</a>&nbsp;&nbsp;|
          &nbsp;&nbsp;<a href="http://savannah.gnu.org/cgi-bin/viewcvs/fsfe/{$path}?cvsroot=www.gnu.org">Modifications</a><br/>
	</td>
	<td class="TopTitle" align="right">
	  &nbsp;<a href="mailto:webmaster@fsfeurope.org">webmaster@fsfeurope.org</a>
        </td>
      </tr>
       <tr>
	<td class="newstext" align="center">
	<font size="-2">
	  Copyright (C) 2001 FSF Europe<br/>
            La reproduction exacte et la distribution intégrale de cet article
            sont permises sur n'importe quel support d'archivage, pourvu que
            cette notice soit préservée.
	</font>
	</td>
        <td class="newstext">&nbsp;</td>
      </tr>
    </table>
  </xsl:template> 

</xsl:stylesheet>

<!--
Local Variables: ***
mode: xml ***
End: ***
-->
