<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet [<!ENTITY nbsp "&#160;">
                          <!ENTITY eur "&#128;">]>
<xsl:stylesheet version="1.0" 
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
 
 <xsl:template match="/html[@lang='it']/body/div">
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
     <a href="http://es.gnu.org/">GNU Spagna</a><br/>
    </td>
   </tr>
  </table>
  
  <!-- Top menu line -->
  <table width="100%" border="0" cellspacing="0" cellpadding="4"
   summary="Top menu">
   <tr>
    <td class="TopTitle">
     &nbsp;<a href="{$fsffrance}">Francia</a> |
     Germania
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
      
      <tr><td class="TopTitle" align="center">Progetti</td></tr>
      <tr>
       <td class="TopBody" align="right">
	 <a href="{$fsfeurope}/law/law.it.html">Software Libero sicuro</a><br />
	 <a href="{$fsfeurope}/coposys/index.en.html">Coposys</a><br />
         <a href="{$fsfeurope}/documents/whyfs.it.html">Parliamo di Software Libero</a><br />
              <a href="{$fsfeurope}/education/education.html">Free Software and Education</a><br />
                  <a href="{$fsfeurope}/law/eucd/eucd.en.html">EUCD</a>
       </td>
      </tr>
      
      <tr>
       <td class="TopTitle" align="center">Sezioni</td>
      </tr>
      <tr>
       <td align="right" class="TopBody"><br/>
	<xsl:choose>
	 <xsl:when test="$path='index.it.xhtml'">Home</xsl:when>
	 <xsl:otherwise>
	  <a href="{$fsfeurope}/index.it.html">Home</a>
	 </xsl:otherwise>
	</xsl:choose><br/>
	<xsl:choose>
	 <xsl:when test="$path='contact/contact.it.xhtml'">Contatti</xsl:when>
	 <xsl:otherwise>
	  <a href="{$fsfeurope}/contact/contact.it.html">Contatti</a>
	 </xsl:otherwise>
	</xsl:choose><br/>
	<xsl:choose>
	 <xsl:when test="$path='about/about.it.xhtml'">Informazioni</xsl:when>
	 <xsl:otherwise>
	  <a href="{$fsfeurope}/about/about.it.html">Informazioni</a>
	 </xsl:otherwise>
	</xsl:choose><br/>
	<xsl:choose>
	 <xsl:when test="$path='help/help.it.xhtml'">Aiuto</xsl:when>
	 <xsl:otherwise>
	  <a href="{$fsfeurope}/help/help.it.html">Aiuto</a>
	 </xsl:otherwise>
	</xsl:choose><br/>
	<xsl:choose>
	 <xsl:when test="$path='background.it.xhtml'">Sfondo</xsl:when>
	 <xsl:otherwise>
	  <a href="{$fsfeurope}/background.it.html">Sfondo</a>
	 </xsl:otherwise>
	</xsl:choose><br/>
	<xsl:choose>
	 <xsl:when test="$path='documents/documents.it.xhtml'">Documenti</xsl:when>
	 <xsl:otherwise>
	  <a href="{$fsfeurope}/documents/documents.it.html">Documenti</a>
	 </xsl:otherwise>
	</xsl:choose><br/>

	<xsl:choose>
	 <xsl:when test="$path='mailman/index.xhtml'">Mailing Lists</xsl:when>
	 <xsl:otherwise>
	  <a href="{$fsfeurope}/mailman/index.html">Mailing Lists</a>
	 </xsl:otherwise>
	</xsl:choose><br/>


	<xsl:choose>
	 <xsl:when test="$path='news/news.en.xhtml'">Novita'</xsl:when>
	 <xsl:otherwise>
	  <a href="{$fsfeurope}/news/news.en.html">Novita'</a>
	 </xsl:otherwise>
	</xsl:choose><br/>

	<xsl:choose>
	 <xsl:when test="$path='events/events.en.xhtml'">Eventi</xsl:when>
	 <xsl:otherwise>
	  <a href="{$fsfeurope}/events/events.en.html">Eventi</a>
	 </xsl:otherwise>
	</xsl:choose><br/>
	<xsl:choose>
	 <xsl:when test="$path='press/index.it.xhtml'">Agenzia di Stampa</xsl:when>
	 <xsl:otherwise>
	  <a href="{$fsfeurope}/press/index.it.html">Agenzia di Stampa</a>
	 </xsl:otherwise>
	</xsl:choose><br/>
	<xsl:choose>
	 <xsl:when test="$path='speakers/speakers.it.xhtml'">Relatori</xsl:when>
	 <xsl:otherwise>
	  <a href="{$fsfeurope}/speakers/speakers.it.html">Relatori</a>
	 </xsl:otherwise>
	</xsl:choose><br/>
	<xsl:choose>
	 <xsl:when test="$path='gbn/index.xhtml'">GNU Business Network</xsl:when>
	 <xsl:otherwise>
	  <a href="{$fsfeurope}/gbn/index.html">GNU Business Network</a>
	 </xsl:otherwise>
	</xsl:choose><br/>
	<br/></td>
      </tr>
      
      <tr><td class="TopTitle" align="center">Organizzazioni Associate</td></tr>
      <tr>
       <td class="TopBody" align="right">
		    <a href="http://www.affs.org.uk/">AFFS</a><br />
		    <a href="http://www.ansol.org/">ANSOL</a><br />
	<a href="http://www.april.org/">APRIL</a><br />
        <a href="http://www.softwarelibero.it/">AsSoLi</a><br />
	<a href="http://www.ffii.org/index.it.html">FFII</a><br />
	<a href="http://www.ffs.or.at/">FFS</a><br />
	<a href="http://www.ofset.org/">OFSET</a><br />
       </td>
      </tr>
      
      <tr>
       <td class="TopTitle" align="center">Amministrazione</td>
      </tr>
      <tr>
       <td align="right"><br/>
	<a href="http://savannah.gnu.org/projects/fsfe/"
	>Sommario del progetto</a><br/>
	<a href="http://www.gnu.org/server/standards/"
	>Guida GNU</a><br/>
	<a href="http://savannah.gnu.org/pm/?group_id=53"
	>Lavori in corso</a><br/>
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
     <a href="{$filebase}.xhtml">Sorgente XHTML</a>&nbsp;&nbsp;|
     &nbsp;&nbsp;<a href="{$fsfeurope}/fsfe.xsl">Style Sheet XSL
     </a><br/>
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
      La copia letterale e la distribuzione del materiale qui
      raccolto nella sua integrita' sono permesse con qualsiasi mezzo, a
      condizione> che questa nota sia riprodotta.
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
