<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet [<!ENTITY nbsp "&#160;">
                          <!ENTITY eur "&#128;">]>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="/html[@lang='pt']/body/div">
    <!-- FSF related sites -->
    <table cellspacing="0" cellpadding="1" width="100%" border="0"
     summary="FSF friend sites"> 
      <tr valign="middle"> 
	  <td class="newstext">
	    &nbsp;&nbsp;
            <a href="{$fsfeurope}/index.pt.html">FSF Europa</a>
          </td>
          <td class="newstext" align="right">
	    <a href="{$fsf}/home.pt.html">FSF</a>
            &nbsp;&nbsp;|&nbsp;&nbsp;
	    <a href="{$gnu}/home.pt.html">GNU</a>
            &nbsp;&nbsp;|&nbsp;&nbsp;
	    <a href="http://es.gnu.org/">GNU Espanha</a><br/>
	  </td>
       </tr>
    </table>

    <!-- Top menu line -->
    <table width="100%" border="0" cellspacing="0" cellpadding="4"
     summary="Top menu">
      <tr>
	<td class="TopTitle">
	  &nbsp;<a href="{$fsffrance}/index.fr.html">França</a> |
	    Alemanha
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
            <tr><td class="TopTitle" align="center">Projectos</td></tr>
              <tr>
                <td class="TopBody" align="right">
                  <a
      href="{$fsfeurope}/law/law.pt.html">Proteger&nbsp;o&nbsp;Software&nbsp;Livre</a><br />
                  <a href="{$fsfeurope}/coposys/index.en.html">Coposys</a><br />
         <a href="{$fsfeurope}/documents/whyfs.pt.html">Nós&nbsp;falamos&nbsp;de&nbsp;Software&nbsp;Livre</a><br />
              <a href="{$fsfeurope}/education/education.html">Free Software and Education</a><br />
                  <a href="{$fsfeurope}/law/eucd/eucd.en.html">EUCD</a>
                </td>
              </tr>
            <tr>
              <td class="TopTitle" align="center">Secções</td>
            </tr>
            <tr>
              <td align="right" class="TopBody"><br/>
              <xsl:choose>
                <xsl:when test="$path='index.pt.xhtml'">Principal</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/index.pt.html">Principal</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='contact/contact.pt.xhtml'">Contactos</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/contact/contact.pt.html">Contactos</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='about/about.pt.xhtml'">Sobre</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/about/about.pt.html">Sobre</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='background.pt.xhtml'">Contexto</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/background.pt.html">Contexto</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='documents/documents.pt.xhtml'">Documentos</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/documents/documents.pt.html">Documentos</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='mailman/index.pt.xhtml'">Listas de Correio</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/mailman/index.pt.html">Listas de Correio</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='news/news.pt.xhtml'">Noticias</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/news/news.pt.html">Noticias</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                 <xsl:when test="$path='press/index.pt.xhtml'">Para a Imprensa</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/press/index.pt.html">Para a Imprensa</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='gbn/index.pt.xhtml'">Rede Empresarial GNU</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/gbn/index.pt.html">Rede Empresarial GNU</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <br/></td>
            </tr>

            <tr>
              <td class="TopTitle" align="center">Organizações associadas</td>
            </tr>
            <tr>
              <td class="TopBody" align="right">
		    <a href="http://www.affs.org.uk/">AFFS</a><br />
		    <a href="http://www.ansol.org/">ANSOL</a><br />
                <a href="http://www.april.org/">APRIL</a><br />
                <a href="http://www.softwarelibero.it/">AsSoLi</a><br />
		<a href="http://www.ffii.org/">FFII</a><br />
		<a href="http://www.ffs.or.at/">FFS</a><br />
                <a href="http://www.ofset.org/">OFSET</a><br />
            </td>
            </tr>

             <tr>
              <td class="TopTitle" align="center">Administração</td>
            </tr>
            <tr>
              <td align="right"><br/>
              <a href="http://savannah.gnu.org/projects/fsfe/"
                  >Introdução</a><br/>
              <a href="http://www.gnu.org/server/standards/"
                  >Guia GNU</a><br/>
              <a href="http://savannah.gnu.org/pm/?group_id=53"
                  >Tarefas</a><br/>
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
	  Sheet</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a
          href="http://savannah.gnu.org/cgi-bin/viewcvs/fsfe/{$path}?cvsroot=www.gnu.org"
        >Modificações</a><br/>
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
          Cópia literal e distribuição deste artigo na íntegra são
          permitidas em qualquer meio, desde que este aviso seja preservado.
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
