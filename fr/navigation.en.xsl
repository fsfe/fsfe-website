<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet [<!ENTITY nbsp "&#160;">]>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="/html[@lang='en']/body/div">
    <!-- FSF related sites -->
    <table cellspacing="0" cellpadding="0" width="100%" border="0"><tr bgcolor="#e7e7e7"><td><img src="{$fsffrance}/images/pix.png" width="1" height="1" alt="" /></td></tr></table> 
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
	  <a class="topbanner" href="http://es.gnu.org/">GNU Espagne</a>
	  &nbsp;&nbsp;|&nbsp;&nbsp;
	  <a class="topbanner" href="http://www.april.org/index.html.en">APRIL</a>
	  &nbsp;&nbsp;|&nbsp;&nbsp;
	  <a class="topbanner" href="http://www.ofset.org/">OFSET</a>
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
	  &nbsp;Local chapters&nbsp;: <a href="{$fsffrance}/index.en.html" class="T1">France</a> |
	    Germany
	</td>
      </tr>
    </table>

    <!-- Title bar -->
    <table width="100%" border="0" cellspacing="0" cellpadding="4">
	<tr>
	  <td class="TopBody">
	    <a href="{$fsffrance}/index.en.html">
	      <img src="{$fsffrance}/images/gnulogo.jpg" alt="GNU Logo" border="0" height="73" width="60" />
	    </a>
	  </td>
	  <td class="TopBody" width="99%" height="99%">
	    <a class="TopTitleB">FSF France</a>
	    <br />
	    <a class="TopTitle">Free Software - equal chances for people and economy</a>
	  </td>
	  <td align="right" valign="bottom" class="TopBody">
	    <a href="{$fsffrance}/index.en.html" class="T2">France</a> <br />
	    <a href="{$fsfeurope}/" class="T2">Europe</a> <br />
	    <a href="{$fsf}/home.en.html" class="T2">United-States</a> <br />
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
		    <a href="{$fsffrance}/gpl/gpl.en.html" class="T2">French GPL</a><br />
		    <a href="{$fsffrance}/libre.en.html" class="T2">Freedom</a><br />	          </td>
		</tr>
		<tr><td class="TopTitle" align="center">FSF France</td></tr>
		<tr>
		  <td align="right">
		    <a href="http://agenda.lolix.org/" class="T2">Calendar</a><br />
		    <a href="{$fsffrance}/news/news.en.html" class="T2">News</a><br />
		    <a href="http://savannah.gnu.org/pm/task.php?group_project_id=37&amp;group_id=53&amp;func=browse" class="T2">Tasks</a><br />
		    <a href="{$gnu}/jobs/jobsFR.fr.html" class="T2">Jobs</a><br />
		    <a href="{$fsffrance}/press/press.fr.html" class="T2">Press Section</a><br />
		    <a href="http://mail.gnu.org/mailman/listinfo/fsfe-france" class="T2">Mailing List</a><br />
		    <a href="{$fsffrance}/donations/donations.en.html" class="T2">Donations</a><br />
		    <a href="{$fsffrance}/about/about.en.html" class="T2">About</a><br />
		    <a href="{$fsffrance}/contact.en.html" class="T1">Contact</a> <br />
		    <a href="{$fsffrance}/thanks.fr.html" class="T1">Thanks</a> 
		  </td>
		</tr>
		<tr><td class="TopTitle" align="center">Sysadmin</td></tr>
		<tr>
		  <td class="TopBody" align="right">
		    <a href="{$fsffrance}/stats/stats.fr.html" class="T1">Statistics</a> <br />
		    <a href="{$fsffrance}/server/server.en.html" class="T2">Guide</a><br />
		    <a href="http://savannah.gnu.org/projects/fsffr/" class="T2">Accounts</a><br />
		    <a href="{$fsffrance}/birth/birth.en.html" class="T2">Birth</a><br />
		  </td>
		</tr>
		<tr><td class="TopTitle" align="center">Webmaster</td></tr>
		<tr>
		  <td class="TopBody" align="right">
		    <a href="{$fsffrance}/server/server.en.html#Web" class="T2">Guide</a><br />
		    <a href="{$gnu}/server/standards/" class="T2">GNU Guide</a><br />
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
	    Verbatim copying and distribution of this entire article is
	    permitted in any medium, provided this notice is preserved.
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
