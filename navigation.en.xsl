<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet [<!ENTITY nbsp "&#160;">
                          <!ENTITY eur "&#128;">]>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="/html[@lang='en']/body/div">
    <!-- FSF related sites -->
    <table cellspacing="0" cellpadding="1" width="100%" border="0"
     summary="FSF friend sites"> 
      <tr valign="middle"> 
	  <td class="newstext">
	    &nbsp;&nbsp;
            <a href="{$fsfeurope}/">FSF Europe</a>
          </td>
          <td class="newstext" align="right">
	    <a href="{$fsf}/">FSF</a>
            &nbsp;&nbsp;|&nbsp;&nbsp;
	    <a href="{$gnu}/">GNU</a>
            &nbsp;&nbsp;|&nbsp;&nbsp;
	    <a href="http://es.gnu.org/">GNU Spain</a><br/>
	  </td>
       </tr>
    </table>

    <!-- Top menu line -->
    <table width="100%" border="0" cellspacing="0" cellpadding="4"
     summary="Top menu">
      <tr>
	<td class="TopTitle">
	  &nbsp;<a href="{$fsffrance}/index.en.html">France</a> |
	    Germany
	</td>
      </tr>
    </table>

    <!-- Title bar -->
    <table width="100%" border="0" cellspacing="0" cellpadding="8"
     summary="Title bar">
	<tr>
	  <td class="TopBody">
	    <a href="{$fsfeurope}/">
	      <img src="{$fsfeurope}/images/fsfe-logo.png" alt="FSFE Logo"
    border="0" width="259" height="76" align="left"/>
	    </a>
	  </td>
	</tr>
    </table>

    <table width="100%" border="0" cellspacing="0" cellpadding="0"
     summary="Languages">
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

   		<tr><td class="TopTitle" align="center">Projects</td></tr>
		<tr>
		  <td class="TopBody" align="right">
		    <a href="{$fsfeurope}/law/law.en.html">Secure Free Software</a><br />
		    <a href="{$fsfeurope}/coposys/index.en.html">Coposys</a><br />
		    <a href="{$fsfeurope}/documents/whyfs.en.html">We speak about Free Software</a><br />
              <a href="{$fsfeurope}/education/education.html">Free Software and Education</a><br />
                  <a href="{$fsfeurope}/law/eucd/eucd.en.html">EUCD</a><br />
                  <a href="{$fsfeurope}/projects/mankind/mankind.en.html">Free Software and World Heritage</a>
		  </td>
		</tr>

            <tr>
              <td class="TopTitle" align="center">Sections</td>
            </tr>
            <tr>
              <td align="right" class="TopBody"><br/>
              <xsl:choose>
                <xsl:when test="$path='index.xhtml'">Home</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/index.html">Home</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='contact/contact.xhtml'">Contact</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/contact/contact.html">Contact</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='about/about.xhtml'">About</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/about/about.html">About</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='help/help.xhtml'">Help</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/help/help.html">Help</a>
                </xsl:otherwise>
              </xsl:choose><br/>

              <xsl:choose>
                <xsl:when test="$path='help/donate-2002.xhtml'">Donate</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/help/donate-2002.html">Donate</a>
                </xsl:otherwise>
              </xsl:choose><br/>

              <xsl:choose>
                <xsl:when test="$path='help/thankgnus-2002.xhtml'">ThankGNUs</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/help/thankgnus-2002.html">ThankGNUs</a>
                </xsl:otherwise>
              </xsl:choose><br/>

              <xsl:choose>
                <xsl:when test="$path='background.xhtml'">Background</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/background.html">Background</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='documents/documents.xhtml'">Documents</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/documents/documents.html">Documents</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='mailman/index.xhtml'">Mailing Lists</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/mailman/index.html">Mailing Lists</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='news/news.xhtml'">News</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/news/news.html">News</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='events/events.en.xhtml'">Events</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/events/events.en.html">Events</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='press/index.xhtml'">Press Section</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/press/index.html">Press Section</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='speakers/speakers.xhtml'">Speakers</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/speakers/speakers.html">Speakers</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='gbn/index.xhtml'">GNU Business Network</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/gbn/index.html">GNU Business Network</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='order/announce.de.xhtml'">Fan Products</xsl:when>
                <xsl:otherwise>
		  <a href="{$fsfeurope}/order/announce.de.html">Fan Products</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <br/></td>
            </tr>

        	<tr><td class="TopTitle" align="center">Associate organizations</td></tr>
		<tr>
		  <td class="TopBody" align="right">
		    <a href="http://www.affs.org.uk/">AFFS</a><br />
		    <a href="http://www.ansol.org/">ANSOL</a><br />
		    <a href="http://www.april.org/">APRIL</a><br />
		    <a href="http://www.softwarelibero.it/">AsSoLi</a><br />
		    <a href="http://www.ffii.org/index.en.html">FFII</a><br />
		    <a href="http://www.ffs.or.at/">FFS</a><br />
		    <a href="http://www.ofset.org/">OFSET</a><br />
	          </td>
		</tr>

            <tr>
              <td class="TopTitle" align="center">Admin</td>
            </tr>
            <tr>
              <td align="right"><br/>
              <a href="http://savannah.gnu.org/projects/fsfe/"
                   >Project Summary</a><br/>
              <a href="http://www.gnu.org/server/standards/"
                   >GNU Guide</a><br/>
              <a href="http://savannah.gnu.org/pm/?group_id=53"
                   >Tasks</a><br/>
              <br/></td>
            </tr>
          </table>
        </td>
      </tr>
    </table>

    <!-- Bottom line -->
    <table width="100%" border="0" cellspacing="0" cellpadding="2"
     summary="Bottom line">
      <tr>
	<td class="TopTitle">
          <a href="{$filebase}.xhtml">XHTML Source</a>&nbsp;&nbsp;|
          &nbsp;&nbsp;<a href="{$fsfeurope}/fsfe.xsl">XSL Style
	  Sheet</a>&nbsp;&nbsp;| <a
      href="http://savannah.gnu.org/cgi-bin/viewcvs/fsfe/{$path}?cvsroot=www.gnu.org"
     >Changes</a><br/>
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
	  Verbatim copying and distribution of this entire article is
	    permitted in any medium, provided this notice is preserved.
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
