<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet [<!ENTITY nbsp "&#160;">]>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="/html[@lang='de']/body/div">
    <!-- FSF related sites -->
    <table cellspacing="0" cellpadding="0" width="100%" border="0"><tr bgcolor="#e7e7e7"><td><img src="{$fsfeurope}/images/pix.png" width="1" height="1" alt="" /></td></tr></table> 
    <table cellspacing="0" cellpadding="1" width="100%" border="0"> 
      <tr valign="middle"> 
	  <td class="newstext">
	    &nbsp;&nbsp;
            <a class="topbanner" href="{$fsfeurope}/">FSF Europe</a>
          </td>
          <td class="newstext" align="right">
	    <a class="topbanner" href="{$fsf}/home.de.html">FSF</a>
            &nbsp;&nbsp;|&nbsp;&nbsp;
	    <a class="topbanner" href="{$gnu}/home.de.html">GNU</a>
            &nbsp;&nbsp;|&nbsp;&nbsp;
	    <a class="topbanner" href="http://es.gnu.org/">GNU Spain</a><br/>
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
	    Germany
	</td>
      </tr>
    </table>

    <!-- Title bar -->
    <table width="100%" border="0" cellspacing="0" cellpadding="4">
	<tr>
	  <td class="TopBody">
	  <!--
	    <a href="{$fsfeurope}/index.de.html">
	      <img src="{$fsfeurope}/images/gnulogo.jpg" alt="GNU Logo" border="0" />
	    </a>
	  -->&nbsp;
	  </td>
	  <td class="TopBody" width="99%" height="99%">
	    <a class="TopTitleB">FSF Europe</a>
	    <br/>
	    <!--
	    <a class="TopTitle">Freie Software - gleiche Chancen für die Bevölkerung und die Wirtschaft</a>
	    -->
	  </td>
	  <td align="right" valign="top" class="TopBody">
	    <a href="{$fsfeurope}/documents/freesoftware.de.html" class="T2">Was&nbsp;ist&nbsp;Freie&nbsp;Software?</a><br/>
	    <a href="{$fsfeurope}/documents/gnuproject.de.html" class="T2">Was&nbsp;ist&nbsp;das&nbsp;GNU-Projekt?</a><br/>
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
              <td align="right" class="Section"><br/>
              <xsl:choose>
                <xsl:when test="$path='index.de.xhtml'">Home</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/index.de.html" class="T2">Home</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='contact/index.de.xhtml'">Kontakt</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/contact/index.de.html" class="T2">Kontakt</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='about/index.xhtml'">Über</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/about/index.html" class="T2">Über</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='help/help.de.xhtml'">Helfen</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/help/help.de.html" class="T2">Helfen</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='background.de.xhtml'">Hintergrund</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/background.de.html" class="T2">Hintergrund</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='documents/documents.de.xhtml'">Dokumente</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/documents/documents.de.html" class="T2">Dokumente</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='mailman/index.de.xhtml'">Mailingslisten</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/mailman/index.de.html" class="T2">Mailingslisten</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <a href="http://savannah.gnu.org/pm/?group_id=53" class="T2">Aufgabe</a><br />
              <xsl:choose>
                <xsl:when test="$path='press/index.de.xhtml'">Presse</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/press/index.de.html" class="T2">Presse</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='gbn/index.de.xhtml'">GNU Business Network</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/gbn/index.de.html" class="T2">GNU Business Network</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <br/></td>
            </tr>
        	<tr><td class="TopTitle" align="center">assoziierte Organisationen</td></tr>
		<tr>
		  <td class="TopBody" align="right">
		    <a href="http://www.april.org/" class="T2">APRIL</a><br />
		    <a href="http://www.fsf.or.at" class="T2">FFS</a><br />
		    <a href="http://www.ofset.org/" class="T2">OFSET</a><br />
	          </td>
		</tr>
            <tr>
              <td class="TopTitle" align="center">Admin</td>
            </tr>
            <tr>
              <td align="right"><br/>
              <a href="http://savannah.gnu.org/projects/fsfe/"
                   class="T2">Project Summary</a><br/>
              <a href="http://www.gnu.org/server/standards/"
                   class="T2">GNU Guide</a><br/>
              <a href="http://savannah.gnu.org/pm/?group_id=53"
                   class="T2">Tasks</a><br/>
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
	  Sheet</a>&nbsp;&nbsp;| <a
	  href="http://savannah.gnu.org/cgi-bin/viewcvs/fsfe/{$path}?cvsroot=www.gnu.org"
	  class="T1">Veränderungen</a><br/>
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
	  Zitat und Verteilung des vollständigen Artikels ist über jedes
	    Medium gestattet, solange dieser Hinweis erhalten bleibt.
	</font>
	</td>
        <td class="Body">&nbsp;</td>
      </tr>
    </table>
  </xsl:template> 

</xsl:stylesheet>

