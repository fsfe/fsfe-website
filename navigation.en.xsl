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
    <table width="100%" border="0" cellspacing="0" cellpadding="4">
	<tr>
	  <td class="TopBody">
          <!--
	    <a href="{$fsfeurope}/">
	      <img src="{$fsfeurope}/images/gnulogo.jpg" alt="GNU Logo" border="0" />
	    </a>
	  -->&nbsp;
	  </td>
	  <td class="TopBody" width="99%" height="99%">
	    <a class="TopTitleB">FSF Europe</a>
	    <br/>
	    <!--
	    <a class="TopTitle">Free Software - equal chances for people and economy</a>
	    -->
	  </td>
	  <td align="right" valign="top" class="TopBody">
	    <a href="{$fsfeurope}/documents/freesoftware.html" class="T2">What's&nbsp;Free&nbsp;Software?</a><br/>
	    <a href="{$fsfeurope}/documents/gnuproject.html" class="T2">What's&nbsp;the&nbsp;GNU&nbsp;Project?</a><br/>
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

   		<tr><td class="TopTitle" align="center">Projects</td></tr>
		<tr>
		  <td class="TopBody" align="right">
		    <a href="{$fsfeurope}/law/law.en.html" class="T2">Secure Free Software</a><br />
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
                  <a href="{$fsfeurope}/index.html" class="T2">Home</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='contact/index.xhtml'">Contact</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/contact/index.html" class="T2">Contact</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='about/index.xhtml'">About</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/about/index.html" class="T2">About</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='help/help.xhtml'">Help</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/help/help.html" class="T2">Help</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='background.xhtml'">Background</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/background.html" class="T2">Background</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='documents/documents.xhtml'">Documents</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/documents/documents.html" class="T2">Documents</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='mailman/index.xhtml'">Mailing Lists</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/mailman/index.html" class="T2">Mailing Lists</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='education/education.en.xhtml'">Education</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/education/education.html" class="T2">Education</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='news/news.en.xhtml'">News</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/news/news.en.html" class="T2">News</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='events/events.en.xhtml'">Events</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/events/events.en.html" class="T2">Events</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='press/index.xhtml'">Press Section</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/press/index.html" class="T2">Press Section</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='speakers/index.xhtml'">Speakers</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/speakers/index.html" class="T2">Speakers</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='gbn/index.xhtml'">GNU Business Network</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/gbn/index.html" class="T2">GNU Business Network</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='order/announce.de.xhtml'">fan articles</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/order/announce.de.html" class="T2">fan articles</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <br/></td>
            </tr>

        	<tr><td class="TopTitle" align="center">Associate organizations</td></tr>
		<tr>
		  <td class="TopBody" align="right">
		    <a href="http://www.april.org/" class="T2">APRIL</a><br />
		    <a href="http://http://www.softwarelibero.it" class="T2">AsSoLi</a><br />
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
	  Sheet</a><br/>
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

