<!DOCTYPE xsl:stylesheet [<!ENTITY nbsp "&#160;">]>
<xsl:stylesheet version="1.0" 
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
 
 <xsl:template match="/html[@lang='it']/body/div">
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
     <a class="topbanner" href="http://es.gnu.org/">GNU Spagna</a><br/>
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
     &nbsp;<a href="{$fsffrance}" class="T1">Francia</a> |
     Germania
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
    </td>
    <td align="right" valign="top" class="TopBody">
     <a href="{$fsfeurope}/documents/freesoftware.html" class="T2">Cosa&nbsp;e'&nbsp;il&nbsp;software&nbsp;libero?</a><br/>
     <a href="{$fsfeurope}/documents/gnuproject.html" class="T2">Cosa&nbsp;e'&nbsp;il&nbsp;Progetto&nbsp;GNU?</a><br/>
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
      
      <tr><td class="TopTitle" align="center">Progetti</td></tr>
      <tr>
       <td class="Section" align="right">
	 <a href="{$fsfeurope}/law/law.it.html" class="T2">Software Libero sicuro</a><br />
	 <a href="{$fsfeurope}/coposys/coposys.en.html" class="T2">Coposys</a><br />
       </td>
      </tr>
      
      <tr>
       <td class="TopTitle" align="center">Sezioni</td>
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
	 <xsl:when test="$path='contact/index.xhtml'">Contatti</xsl:when>
	 <xsl:otherwise>
	  <a href="{$fsfeurope}/contact/index.html" class="T2">Contatti</a>
	 </xsl:otherwise>
	</xsl:choose><br/>
	<xsl:choose>
	 <xsl:when test="$path='about/index.xhtml'">Informazioni</xsl:when>
	 <xsl:otherwise>
	  <a href="{$fsfeurope}/about/index.html" class="T2">Informazioni</a>
	 </xsl:otherwise>
	</xsl:choose><br/>
	<xsl:choose>
	 <xsl:when test="$path='help/help.it.xhtml'">Aiuto</xsl:when>
	 <xsl:otherwise>
	  <a href="{$fsfeurope}/help/help.it.html" class="T2">Aiuto</a>
	 </xsl:otherwise>
	</xsl:choose><br/>
	<xsl:choose>
	 <xsl:when test="$path='background.xhtml'">Sfondo</xsl:when>
	 <xsl:otherwise>
	  <a href="{$fsfeurope}/background.html" class="T2">Sfondo</a>
	 </xsl:otherwise>
	</xsl:choose><br/>
	<xsl:choose>
	 <xsl:when test="$path='documents/documents.xhtml'">Documenti</xsl:when>
	 <xsl:otherwise>
	  <a href="{$fsfeurope}/documents/documents.html" class="T2">Documenti</a>
	 </xsl:otherwise>
	</xsl:choose><br/>

	<xsl:choose>
	 <xsl:when test="$path='mailman/index.xhtml'">Mailing Lists</xsl:when>
	 <xsl:otherwise>
	  <a href="{$fsfeurope}/mailman/index.html" class="T2">Mailing Lists</a>
	 </xsl:otherwise>
	</xsl:choose><br/>


	<xsl:choose>
	 <xsl:when test="$path='news/news.en.xhtml'">Novita'</xsl:when>
	 <xsl:otherwise>
	  <a href="{$fsfeurope}/news/news.en.html" class="T2">Novita'</a>
	 </xsl:otherwise>
	</xsl:choose><br/>

	<xsl:choose>
	 <xsl:when test="$path='events/events.en.xhtml'">Eventi</xsl:when>
	 <xsl:otherwise>
	  <a href="{$fsfeurope}/events/events.en.html" class="T2">Eventi</a>
	 </xsl:otherwise>
	</xsl:choose><br/>
	<xsl:choose>
	 <xsl:when test="$path='press/index.xhtml'">Agenzia di Stampa</xsl:when>
	 <xsl:otherwise>
	  <a href="{$fsfeurope}/press/index.html" class="T2">Agestia di Stampa</a>
	 </xsl:otherwise>
	</xsl:choose><br/>
	<xsl:choose>
	 <xsl:when test="$path='speakers/index.xhtml'">Oratori</xsl:when>
	 <xsl:otherwise>
	  <a href="{$fsfeurope}/speakers/index.html" class="T2">Oratori</a>
	 </xsl:otherwise>
	</xsl:choose><br/>
	<xsl:choose>
	 <xsl:when test="$path='gbn/index.xhtml'">GNU Business Network</xsl:when>
	 <xsl:otherwise>
	  <a href="{$fsfeurope}/gbn/index.html" class="T2">GNU Business Network</a>
	 </xsl:otherwise>
	</xsl:choose><br/>
	<br/></td>
      </tr>
      
      <tr><td class="TopTitle" align="center">Organizzazioni Associate</td></tr>
      <tr>
       <td class="TopBody" align="right">
	<a href="http://www.april.org/" class="T2">APRIL</a><br />
        <a href="http://www.softwarelibero.it" class="T2">AsSoLi</a><br />
	<a href="http://www.fsf.or.at" class="T2">FFS</a><br />
	<a href="http://www.ofset.org/" class="T2">OFSET</a><br />
       </td>
      </tr>
      
      <tr>
       <td class="TopTitle" align="center">Amministrazione</td>
      </tr>
      <tr>
       <td align="right"><br/>
	<a href="http://savannah.gnu.org/projects/fsfe/"
	 class="T2">Sommario del progetto</a><br/>
	<a href="http://www.gnu.org/server/standards/"
	 class="T2">Guida GNU</a><br/>
	<a href="http://savannah.gnu.org/pm/?group_id=53"
	 class="T2">Lavori in corso</a><br/>
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
     <a href="{$filebase}.xhtml" class="T1">Sorgente XHTML</a>&nbsp;&nbsp;|
     &nbsp;&nbsp;<a href="{$fsfeurope}/fsfe.xsl" class="T1">Style Sheet XSL
     </a><br/>
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
      La copia letterale e la distribuzione del materiale qui
      raccolto nella sua integrita' sono permesse con qualsiasi mezzo, a
      condizione> che questa nota sia riprodotta.
     </font>
    </td>
    <td class="Body">&nbsp;</td>
   </tr>
  </table>
 </xsl:template> 
 
</xsl:stylesheet>

