<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet [<!ENTITY nbsp "&#160;">]>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="/html[@lang='de']/body/div">
    <!-- FSF related sites -->
    <table cellspacing="0" cellpadding="1" width="100%" border="0"> 
      <tr valign="middle"> 
	  <td class="newstext">
	    &nbsp;&nbsp;
            <a href="{$fsfeurope}/">FSF Europe</a>
          </td>
          <td class="newstext" align="right">
	    <a href="{$fsf}/home.de.html">FSF</a>
            &nbsp;&nbsp;|&nbsp;&nbsp;
	    <a href="{$gnu}/home.de.html">GNU</a>
            &nbsp;&nbsp;|&nbsp;&nbsp;
	    <a href="http://es.gnu.org/">GNU Spain</a><br/>
	  </td>
       </tr>
    </table>

    <!-- Top menu line -->
    <table width="100%" border="0" cellspacing="0" cellpadding="4">
      <tr>
	<td class="TopTitle">
	  &nbsp;<a href="{$fsffrance}/index.fr.html">France</a> |
	    Germany
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
	<xsl:apply-templates select="@*|node()"/>
        </div>
	</td>
	<!-- Menu column. On the right to be Lynx friendly.  -->
	<td>&nbsp;</td>
	<td valign="top" class="TopBody">
		<table summary="" width="150" border="0" cellspacing="0" cellpadding="4">
			<tr>
				<td class="TopTitle" align="center">Projekte</td>
			</tr>
			<tr>
				<td class="TopBody" align="right">
					<a href="{$fsfeurope}/law/law.de.html">Freie Software sichern</a><br/>
					<a href="{$fsfeurope}/coposys/index.en.html">Coposys</a><br />
					<a href="{$fsfeurope}/documents/whyfs.de.html">Wir sprechen von Freier Software</a><br />
				</td>
			</tr>

            <tr>
              <td class="TopTitle" align="center">Sections</td>
            </tr>
            <tr>
              <td align="right" class="TopBody"><br/>
              <xsl:choose>
                <xsl:when test="$path='index.de.xhtml'">Home</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/index.de.html">Home</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='contact/contact.de.xhtml'">Kontakt</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/contact/contact.de.html">Kontakt</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='about/index.xhtml'">Über</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/about/index.html">Über</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='help/help.de.xhtml'">Helfen</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/help/help.de.html">Helfen</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='background.de.xhtml'">Hintergrund</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/background.de.html">Hintergrund</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='documents/documents.de.xhtml'">Dokumente</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/documents/documents.de.html">Dokumente</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='mailman/index.de.xhtml'">Mailinglisten</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/mailman/index.de.html">Mailinglisten</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='education/education.de.xhtml'">Bildung</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/education/education.de.html">Bildung</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='news/news.de.xhtml'">Nachrichten</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/news/news.de.html">Nachrichten</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <!--<xsl:choose>
                <xsl:when test="$path='events/events.de.xhtml'">Events</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/events/events.de.html">Events</a>
                </xsl:otherwise>
              </xsl:choose><br/>-->
              <xsl:choose>
                <xsl:when test="$path='press/index.de.xhtml'">Presse</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/press/index.de.html">Presse</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='speakers/speakers.de.xhtml'">Sprecher</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/speakers/speakers.de.html">Sprecher</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='gbn/index.de.xhtml'">GNU Business Network</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/gbn/index.de.html">GNU Business Network</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='order/announce.de.xhtml'">Fanartikel</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/order/announce.de.html">Fanartikel</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <br/></td>
            </tr>
        	<tr><td class="TopTitle" align="center">assoziierte Organisationen</td></tr>
		<tr>
		  <td class="TopBody" align="right">
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
                  >Projektübersicht</a><br/>
              <a href="http://www.gnu.org/server/standards/"
                  >GNU Guide</a><br/>
              <a href="http://savannah.gnu.org/pm/?group_id=53"
                  >Aufgaben</a><br/>
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
	  Sheet</a>&nbsp;&nbsp;| <a
	  href="http://savannah.gnu.org/cgi-bin/viewcvs/fsfe/{$path}?cvsroot=www.gnu.org"
	 >Veränderungen</a><br/>
	</td>
	<td class="TopTitle" align="right">
	  &nbsp;<a href="mailto:webmaster@fsfeurope.org"
                  >webmaster@fsfeurope.org</a>
        </td>
      </tr>
      <tr>
	<td class="newstext" align="center">
	<font size="-2">
	  Copyright (C) 2001 FSF Europe<br/>
	  Zitat und Verteilung des vollständigen Artikels ist über jedes
	    Medium gestattet, solange dieser Hinweis erhalten bleibt.
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
