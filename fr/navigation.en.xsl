<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet [<!ENTITY nbsp "&#160;">]>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="/html[@lang='en']/body/div">
    <!-- FSF related sites -->
    <table cellspacing="0" cellpadding="1" width="100%" border="0"> 
      <tr valign="middle"> 
	<td class="newstext">
	  &nbsp;&nbsp;
	  <a href="{$fsfeurope}/">FSF Europe</a>
	</td>
	<td align="right" class="newstext">
	  <a href="{$fsf}/">FSF</a>
	  &nbsp;&nbsp;|&nbsp;&nbsp;
	  <a href="{$gnu}/">GNU</a>
	  &nbsp;&nbsp;|&nbsp;&nbsp;
	  <a href="http://www.april.org/index.html.en">APRIL</a>
	  &nbsp;&nbsp;|&nbsp;&nbsp;
	  <a href="http://www.ofset.org/">OFSET</a>
	</td>
      </tr>
    </table>

    <!-- Top menu line -->
    <table width="100%" border="0" cellspacing="0" cellpadding="4">
      <tr>
	<td class="TopTitle">
	  &nbsp;Local chapters&nbsp;: <a href="{$fsffrance}/index.en.html">France</a> |
	    Germany
	</td>
      </tr>
    </table>

    <!-- Title bar -->
    <table width="100%" border="0" cellspacing="0" cellpadding="8">
      <tr>
	<td class="TopBody">
	  <a href="{$fsfeurope}">
	      <img src="{$fsffrance}/images/fsfe-logo.png" alt="to FSFE Logo"
    border="0" width="259" height="76" align="left"/>
	  </a>
	</td>
	<td class="TopBody">
<!-- If we are on the top level page of the local chapter's site, the
icon links to the top of the hub's site -->
        <xsl:choose>
        <xsl:when test="$path='index.en.xhtml'">
	  French Chapter
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
		<a href="http://cyberlink.idws.com/fsm/">Africa</a> <br />
		<a href="http://www.fsf.or.at/">Austria</a> <br />

		<a href="http://www.rons.net.cn/english/Links/fsf-china/">China</a> <br />
		<a href="http://www.gnu.cz/">Czech Republic</a> <br />
	      </td>
	      <td>
		<a href="{$fsfeurope}/">Europe</a> <br />
		<a href="{$fsffrance}/index.en.html">France</a> <br />
		<a href="http://fsf.org.in/">India</a> <br />
		<a href="http://korea.gnu.org/home.html">Korea</a> <br />
	      </td>
	      <td>
		<a href="http://www.gnulinux.org.mx/">Mexico</a> <br />
		<a href="http://www.ansol.org/">Portugal</a> <br />
		<a href="http://es.gnu.org/">Spain</a> <br />
		<a href="{$fsf}/home.html">United-States</a> <br />
	      </td>
	    </tr>
	    </table>
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
		<tr><td class="TopTitle" align="center">Projects</td></tr>
		<tr>
		  <td class="TopBody" align="right">
		    <xsl:choose>
                       <xsl:when test="$path='gpl/gpl.en.xhtml'">GPL in French</xsl:when>
                       <xsl:otherwise>
                          <a href="{$fsffrance}/gpl/gpl.en.html">GPL in French</a>
                       </xsl:otherwise>
                    </xsl:choose><br />
		    <xsl:choose>
                       <xsl:when test="$path='libre.en.xhtml'">Freedoms</xsl:when>
                       <xsl:otherwise>
                          <a href="{$fsffrance}/libre.en.html">Freedoms</a>
                       </xsl:otherwise>
                    </xsl:choose><br />	          
		    <a href="http://www.fsfeurope.org/law/law.en.html">Secure Free Software</a><br />
		    <xsl:choose>
                       <xsl:when test="$path='collecte/collecte.en.xhtml'">Press review</xsl:when>
                       <xsl:otherwise>
                          <a href="{$fsffrance}/collecte/collecte.en.html">Press review</a>
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
		  <td align="right">
		    <xsl:choose>
                       <xsl:when test="$path='index.en.xhtml'">Home</xsl:when>
                       <xsl:otherwise>
                          <a href="{$fsffrance}/index.en.html">Home</a>
                       </xsl:otherwise>
                    </xsl:choose><br />
		    <xsl:choose>
                       <xsl:when test="$path='philosophy/philosophy.en.xhtml'">Philosophy</xsl:when>
                       <xsl:otherwise>
                          <a href="{$fsffrance}/philosophy/philosophy.en.html">Philosophy</a>
                       </xsl:otherwise>
                    </xsl:choose><br />
		    <a href="http://agenda.lolix.org/">Calendar</a><br />
		    <xsl:choose>
                       <xsl:when test="$path='news/news.en.xhtml'">News</xsl:when>
                       <xsl:otherwise>
                          <a href="{$fsffrance}/news/news.en.html">News</a>
                       </xsl:otherwise>
                    </xsl:choose><br />
		    <xsl:choose>
                       <xsl:when test="$path='events/events.en.xhtml'">Events</xsl:when>
                       <xsl:otherwise>
                          <a href="{$fsffrance}/events/events.en.html">Events</a>
                       </xsl:otherwise>
                    </xsl:choose><br />
		    <a href="http://savannah.gnu.org/pm/task.php?group_project_id=37&amp;group_id=53&amp;func=browse">Tasks</a><br />
		    <a href="{$gnu}/jobs/jobsFR.fr.html">Jobs</a><br />
		    <xsl:choose>
                       <xsl:when test="$path='press/press.fr.xhtml'">Press Section</xsl:when>
                       <xsl:otherwise>
                          <a href="{$fsffrance}/press/press.fr.html">Press Section</a>
                       </xsl:otherwise>
                    </xsl:choose><br />
		    <xsl:choose>
                       <xsl:when test="$path='lists/lists.en.xhtml'">Mailing List</xsl:when>
                       <xsl:otherwise>
                          <a href="{$fsffrance}/lists/lists.en.html">Mailing List</a>
                       </xsl:otherwise>
                    </xsl:choose><br />
		    <xsl:choose>
                       <xsl:when test="$path='donations/donations.en.xhtml'">Donations</xsl:when>
                       <xsl:otherwise>
                          <a href="{$fsffrance}/donations/donations.en.html">Donations</a>
                       </xsl:otherwise>
                    </xsl:choose><br />
		    <xsl:choose>
                       <xsl:when test="$path='about/speakers.en.xhtml'">Speakers</xsl:when>
                       <xsl:otherwise>
                          <a href="{$fsffrance}/about/speakers.en.html">Speakers</a>
                       </xsl:otherwise>
                    </xsl:choose><br />
		    <xsl:choose>
                       <xsl:when test="$path='about/about.en.xhtml'">About</xsl:when>
                       <xsl:otherwise>
                          <a href="{$fsffrance}/about/about.en.html">About</a>
                       </xsl:otherwise>
                    </xsl:choose><br />
		    <xsl:choose>
                       <xsl:when test="$path='contact.en.xhtml'">Contact</xsl:when>
                       <xsl:otherwise>
                          <a href="{$fsffrance}/contact.en.html">Contact</a>
                       </xsl:otherwise>
                    </xsl:choose> <br />
		    <xsl:choose>
                       <xsl:when test="$path='thanks.fr.xhtml'">Thanks</xsl:when>
                       <xsl:otherwise>
                          <a href="{$fsffrance}/thanks.fr.html">Thanks</a>
                       </xsl:otherwise>
                    </xsl:choose> 
		  </td>
		</tr>

		<tr><td class="TopTitle" align="center">Associated organizations</td></tr>
		<tr>
		  <td class="TopBody" align="right">
		    <a href="http://www.april.org/">APRIL</a><br />
		     <a href="http://www.softwarelibero.it">AsSoLi</a><br />
		    <a href="http://www.fsf.or.at/">FFS</a><br />
		    <a href="http://www.ofset.org/">OFSET</a><br />
	          </td>
		</tr>

		<tr><td class="TopTitle" align="center">Sysadmin</td></tr>
		<tr>
		  <td class="TopBody" align="right">
		    <xsl:choose>
                       <xsl:when test="$path='stats/stats.fr.xhtml'">Statistics</xsl:when>
                       <xsl:otherwise>
                          <a href="{$fsffrance}/stats/stats.fr.html">Statistics</a>
                       </xsl:otherwise>
                    </xsl:choose> <br />
		    <xsl:choose>
                       <xsl:when test="$path='server/server.en.xhtml'">Guide</xsl:when>
                       <xsl:otherwise>
                          <a href="{$fsffrance}/server/server.en.html">Guide</a>
                       </xsl:otherwise>
                    </xsl:choose><br />
		    <a href="http://savannah.gnu.org/projects/fsffr/">Accounts</a><br />
		    <xsl:choose>
                       <xsl:when test="$path='birth/birth.en.xhtml'">Birth</xsl:when>
                       <xsl:otherwise>
                          <a href="{$fsffrance}/birth/birth.en.html">Birth</a>
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
		    <a href="{$gnu}/server/standards/">GNU Guide</a><br />
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
	<td  class="newstext" align="center">
	<font size="-2">
	    Copyright (C) 2001 FSF France,
	    8 rue de Valois, 75001 Paris, France
	    <br/>
	    Verbatim copying and distribution of this entire article is
	    permitted in any medium, provided this notice is preserved.
	</font>
	</td>
        <td  class="newstext">&nbsp;</td>
      </tr>
    </table>
  </xsl:template> 

<!--
Local Variables: ***
mode: xml ***
End: ***
-->
</xsl:stylesheet>
