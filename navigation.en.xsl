<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet [<!ENTITY nbsp "&#160;">]>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="/html[@lang='en']/body/div">
    <!-- FSF related sites -->
    <table cellspacing="0" cellpadding="0" width="100%" border="0"><tr bgcolor="#e7e7e7"><td><img src="{$fsfeurope}/images/pix.png" width="1" height="1" alt="" /></td></tr></table> 
    <table cellspacing="0" cellpadding="1" width="100%" border="0"> 
      <tr valign="middle"> 
	  <td class="newstext">
	    &nbsp;&nbsp;
            <a class="topbanner" href="{$fsfeurope}/">FSF Europe</a>
          </td>
          <td class="newstext" align="right">
	    <a class="topbanner" href="{$fsf}/">FSF</a>
            &nbsp;&nbsp;|&nbsp;&nbsp;
	    <a class="topbanner" href="{$gnu}/">GNU</a>
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
	  &nbsp;<a href="{$fsffrance}/index.en.html" class="T1">France</a> |
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
    border="0" width="259" height="66" align="left"/>
	    </a>
	  </td>
	</tr>
    </table>

    <table width="100%" border="0" cellspacing="0">
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

   		<tr><td class="TopTitle" align="center">Projects</td></tr>
		<tr>
		  <td class="TopBody" align="right">
		    <a href="{$fsfeurope}/law/law.en.html">Secure Free Software</a><br />
		    <a href="{$fsfeurope}/coposys/index.en.html">Coposys</a><br />
		  </td>
		</tr>

            <tr>
              <td class="TopTitle" align="center">Sections</td>
            </tr>
            <tr>
              <td align="right" class="Section"><br/>
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
                <xsl:when test="$path='about/index.xhtml'">About</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/about/index.html">About</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='help/help.xhtml'">Help</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/help/help.html">Help</a>
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
                <xsl:when test="$path='education/education.xhtml'">Education</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/education/education.html">Education</a>
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
                <xsl:when test="$path='order/announce.de.xhtml'">fan articles</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/order/announce.de.html">fan articles</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <br/></td>
            </tr>

        	<tr><td class="TopTitle" align="center">Associate organizations</td></tr>
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
    <table width="100%" border="0" cellspacing="0" cellpadding="2">
      <tr>
	<td class="TopTitle">
          <a href="{$filebase}.xhtml" class="T1">XHTML Source</a>&nbsp;&nbsp;|
          &nbsp;&nbsp;<a href="{$fsfeurope}/fsfe.xsl" class="T1">XSL Style
	  Sheet</a>&nbsp;&nbsp;| <a
      href="http://savannah.gnu.org/cgi-bin/viewcvs/fsfe/{$path}?cvsroot=www.gnu.org"
      class="T1">Changes</a><br/>
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
	  Verbatim copying and distribution of this entire article is
	    permitted in any medium, provided this notice is preserved.
	</font>
	</td>
        <td class="Body">&nbsp;</td>
      </tr>
    </table>
  </xsl:template> 

</xsl:stylesheet>

<!--
Local Variables: ***
mode: xml ***
End: ***
-->
