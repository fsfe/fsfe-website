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
	  <a href="http://es.gnu.org/">GNU Spain</a>
	</td>
      </tr>
    </table>

    <!-- Title bar -->
    <table width="100%" border="0" cellspacing="0" cellpadding="8">
      <tr>
	<td class="TopBody">
	  <a href="{$fsfeurope}">
	    <img src="{$fsffrance}/images/fsfe-logo.png" alt="FSFE Logo"
	      border="0" width="259" height="76" align="left"/>
	  </a>
	</td>
	<td class="TopBody">
	  FSF France
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
		<a href="{$fsffrance}/gpl/gpl.en.html">GPL in French</a><br />
		<a href="{$fsffrance}/libre.en.html">Freedoms</a><br />	          
		<a href="http://www.fsfeurope.org/law/law.en.html">Secure Free Software</a><br />
		<a href="{$fsffrance}/collecte/collecte.en.html">Press review</a><br />
		<a href="{$fsffrance}/voting/voting.en.html">E-Vote</a><br />
		<a href="{$fsfeurope}/coposys/index.en.html">Coposys</a><br />
		<a href="{$fsfeurope}/documents/whyfs.en.html">We speak about Free Software</a><br />
		<a href="{$fsffrance}/science/science.en.html">Science and FS</a><br />
	      </td>
	    </tr>
	    <tr><td class="TopTitle" align="center">Sections</td></tr>
	    <tr>
	      <td align="right">
		<a href="{$fsffrance}/index.en.html">Home</a><br />
		<a href="{$fsffrance}/philosophy/philosophy.en.html">Philosophy</a><br />
		<a href="http://agenda.lolix.org/">Calendar</a><br />
		<a href="{$fsffrance}/news/news.en.html">News</a><br />
		<a href="{$fsffrance}/events/events.en.html">Events</a><br />
		<a href="http://savannah.gnu.org/pm/task.php?group_project_id=37&amp;group_id=53&amp;func=browse">Tasks</a><br />
		<a href="{$gnu}/jobs/jobsFR.fr.html">Jobs</a><br />
		<a href="{$fsffrance}/press/press.fr.html">Press Section</a><br />
		<a href="{$fsffrance}/lists/lists.en.html">Mailing List</a><br />
		<a href="{$fsffrance}/donations/donations.fr.html">Donations</a><br />
		<a href="{$fsffrance}/about/speakers.en.html">Speakers</a><br />
		<a href="{$fsffrance}/about/about.en.html">About</a><br />
		<a href="{$fsffrance}/contact.en.html">Contact</a> <br />
		<a href="{$fsffrance}/thanks.fr.html">Thanks</a> 
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
		<a href="{$fsffrance}/stats/stats.fr.html">Statistics</a> <br />
		<a href="{$fsffrance}/server/server.en.html">Guide</a><br />
		<a href="http://savannah.gnu.org/projects/fsffr/">Accounts</a><br />
		<a href="{$fsffrance}/birth/birth.en.html">Birth</a><br />
	      </td>
	    </tr>
	    <tr><td class="TopTitle" align="center">Webmaster</td></tr>
	    <tr>
	      <td class="TopBody" align="right">
		<a href="{$fsffrance}/server/server.en.html#Web">Guide</a><br />
		<a href="{$gnu}/server/standards/">GNU Guide</a><br />
		<a href="{$fsffrance}/boilerplate.fr.html">Boilerplate</a><br />
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
	    Copyright (C) 2002 FSF France,
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
