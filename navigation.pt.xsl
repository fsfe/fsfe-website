<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet [<!ENTITY nbsp "&#160;">]>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="/html[@lang='pt']/body/div">
    <!-- FSF related sites -->
    <table cellspacing="0" cellpadding="0" width="100%" border="0"><tr bgcolor="#e7e7e7"><td><img src="{$fsfeurope}/images/pix.png" width="1" height="1" alt="" /></td></tr></table> 
    <table cellspacing="0" cellpadding="1" width="100%" border="0"> 
      <tr valign="middle"> 
	  <td class="newstext">
	    &nbsp;&nbsp;
            <a class="topbanner" href="{$fsfeurope}/index.pt.html">FSF Europa</a>
          </td>
          <td class="newstext" align="right">
	    <a class="topbanner" href="{$fsf}/home.pt.html">FSF</a>
            &nbsp;&nbsp;|&nbsp;&nbsp;
	    <a class="topbanner" href="{$gnu}/home.pt.html">GNU</a>
            &nbsp;&nbsp;|&nbsp;&nbsp;
	    <a class="topbanner" href="http://es.gnu.org/">GNU Espanha</a><br/>
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
	  &nbsp;<a href="{$fsffrance}/index.fr.html" class="T1">França</a> |
	    Alemanha
	</td>
      </tr>
    </table>

    <!-- Title bar -->
    <table width="100%" border="0" cellspacing="0" cellpadding="4">
	<tr>
	  <td class="TopBody">
          <!--
	    <a href="{$fsfeurope}/index.pt.html">
	      <img src="{$fsfeurope}/images/gnulogo.jpg" alt="GNU Logo" border="0" />
	    </a>
	  -->&nbsp;
	  </td>
	  <td class="TopBody" width="99%" height="99%">
	    <a class="TopTitleB">FSF Europa</a>
	    <br/>
	    <!--
	    <a class="TopTitle">Software Livre - igualdade de oportunidades para pessoas e empresas</a>
	    -->
	  </td>
	  <td align="right" valign="top" class="TopBody">
	    <a href="{$fsfeurope}/documents/freesoftware.pt.html" class="T2">O&nbsp;que&nbsp;é&nbsp;o&nbsp;Software&nbsp;Livre?</a><br/>
	    <a href="{$fsfeurope}/documents/gnuproject.pt.html" class="T2">O&nbsp;que&nbsp;é&nbsp;o&nbsp;projecto&nbsp;GNU?</a><br/>
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
            <tr><td class="TopTitle" align="center">Projectos</td></tr>
              <tr>
                <td class="TopBody" align="right">
                  <a href="{$fsfeurope}/law/law.pt.html" class="T2">Proteger&nbsp;o&nbsp;Software&nbsp;Livre</a><br />
                  <a href="{$fsfeurope}/coposys/coposys.en.html" class="T2">Coposys</a><br />
                </td>
              </tr>
            <tr>
              <td class="TopTitle" align="center">Secções</td>
            </tr>
            <tr>
              <td align="right" class="Section"><br/>
              <xsl:choose>
                <xsl:when test="$path='index.pt.xhtml'">Principal</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/index.pt.html" class="T2">Principal</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='contact/index.pt.xhtml'">Contactos</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/contact/index.pt.html" class="T2">Contactos</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='about/about.pt.xhtml'">Sobre</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/about/about.pt.html" class="T2">Sobre</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='background.pt.xhtml'">Contexto</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/background.pt.html" class="T2">Contexto</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='documents/documents.pt.xhtml'">Documentos</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/documents/documents.pt.html" class="T2">Documentos</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='mailman/index.pt.xhtml'">Listas de Correio</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/mailman/index.pt.html" class="T2">Listas de Correio</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='news/news.pt.xhtml'">Noticias</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/news/news.pt.html" class="T2">Noticias</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                 <xsl:when test="$path='press/index.pt.xhtml'">Para a Imprensa</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/press/index.pt.html" class="T2">Para a Imprensa</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='gbn/index.pt.xhtml'">Rede Empresarial GNU</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/gbn/index.pt.html" class="T2">Rede Empresarial GNU</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <br/></td>
            </tr>

            <tr>
              <td class="TopTitle" align="center">Organizações associadas</td>
            </tr>
            <tr>
              <td class="TopBody" align="right">
                <a href="http://www.april.org/" class="T2">APRIL</a><br />
                <a href="http://www.softwarelibero.it" class="T2">AsSoLi</a><br />
		<a href="http://www.fsf.or.at" class="T2">FFS</a><br />
                <a href="http://www.ofset.org/" class="T2">OFSET</a><br />
            </td>
            </tr>

             <tr>
              <td class="TopTitle" align="center">Administração</td>
            </tr>
            <tr>
              <td align="right"><br/>
              <a href="http://savannah.gnu.org/projects/fsfe/"
                   class="T2">Introdução</a><br/>
              <a href="http://www.gnu.org/server/standards/"
                   class="T2">Guia GNU</a><br/>
              <a href="http://savannah.gnu.org/pm/?group_id=53"
                   class="T2">Tarefas</a><br/>
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
          Cópia literal e distribuição deste artigo na íntegra são
          permitidas em qualquer meio, desde que este aviso seja preservado.
	</font>
	</td>
        <td class="Body">&nbsp;</td>
      </tr>
    </table>
  </xsl:template> 

</xsl:stylesheet>

