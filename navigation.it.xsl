<!DOCTYPE xsl:stylesheet [<!ENTITY nbsp "&#160;">]>
<xsl:stylesheet version="1.0" 
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
 
 <xsl:template match="/html[@lang='it']/body/div">
  <!-- FSF related sites -->
  <table cellspacing="0" cellpadding="1" width="100%" border="0"> 
   <tr valign="middle"> 
    <td>
     &nbsp;&nbsp;
     <a href="{$fsfeurope}/">FSF Europe</a>
    </td>
    <td align="right">
     <a href="{$fsf}/">FSF</a>
     &nbsp;&nbsp;|&nbsp;&nbsp;
     <a href="{$gnu}/">GNU</a>
     &nbsp;&nbsp;|&nbsp;&nbsp;
     <a href="http://es.gnu.org/">GNU Spagna</a><br/>
    </td>
   </tr>
  </table>
  
  <!-- Top menu line -->
  <table width="100%" border="0" cellspacing="0" cellpadding="4">
   <tr>
    <td class="TopTitle">
     &nbsp;<a href="{$fsffrance}">Francia</a> |
     Germania
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
     <table summary="" width="150" border="0" cellspacing="0"
      cellpadding="4">
      
      <tr><td class="TopTitle" align="center">Progetti</td></tr>
      <tr>
       <td class="TopBody" align="right">
	 <a href="{$fsfeurope}/law/law.it.html">Software Libero sicuro</a><br />
	 <a href="{$fsfeurope}/coposys/index.en.html">Coposys</a><br />
       </td>
      </tr>
      
      <tr>
       <td class="TopTitle" align="center">Sezioni</td>
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
	 <xsl:when test="$path='contact/contact.xhtml'">Contatti</xsl:when>
	 <xsl:otherwise>
	  <a href="{$fsfeurope}/contact/contact.html">Contatti</a>
	 </xsl:otherwise>
	</xsl:choose><br/>
	<xsl:choose>
	 <xsl:when test="$path='about/index.xhtml'">Informazioni</xsl:when>
	 <xsl:otherwise>
	  <a href="{$fsfeurope}/about/index.html">Informazioni</a>
	 </xsl:otherwise>
	</xsl:choose><br/>
	<xsl:choose>
	 <xsl:when test="$path='help/help.it.xhtml'">Aiuto</xsl:when>
	 <xsl:otherwise>
	  <a href="{$fsfeurope}/help/help.it.html">Aiuto</a>
	 </xsl:otherwise>
	</xsl:choose><br/>
	<xsl:choose>
	 <xsl:when test="$path='background.xhtml'">Sfondo</xsl:when>
	 <xsl:otherwise>
	  <a href="{$fsfeurope}/background.html">Sfondo</a>
	 </xsl:otherwise>
	</xsl:choose><br/>
	<xsl:choose>
	 <xsl:when test="$path='documents/documents.xhtml'">Documenti</xsl:when>
	 <xsl:otherwise>
	  <a href="{$fsfeurope}/documents/documents.html">Documenti</a>
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
	 <xsl:when test="$path='press/index.xhtml'">Agenzia di Stampa</xsl:when>
	 <xsl:otherwise>
	  <a href="{$fsfeurope}/press/index.html">Agestia di Stampa</a>
	 </xsl:otherwise>
	</xsl:choose><br/>
	<xsl:choose>
	 <xsl:when test="$path='speakers/speakers.xhtml'">Oratori</xsl:when>
	 <xsl:otherwise>
	  <a href="{$fsfeurope}/speakers/speakers.html">Oratori</a>
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
	<a href="http://www.april.org/">APRIL</a><br />
        <a href="http://www.softwarelibero.it">AsSoLi</a><br />
	<a href="http://www.fsf.or.at">FFS</a><br />
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
  <table width="100%" border="0" cellspacing="0" cellpadding="2">
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
