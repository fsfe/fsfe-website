<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet [<!ENTITY nbsp "&#160;">]>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="/html[@lang='es']/body/div">
    <!-- FSF related sites -->
    <table cellspacing="0" cellpadding="0" width="100%" border="0"><tr bgcolor="#e7e7e7"><td><img src="{$fsfeurope}/images/pix.png" width="1" height="1" alt="" /></td></tr></table> 
    <table cellspacing="0" cellpadding="1" width="100%" border="0"> 
      <tr valign="middle"> 
	  <td class="newstext">
	    &nbsp;&nbsp;
            <a class="topbanner" href="{$fsfeurope}/index.es.html">FSF Europa</a>
          </td>
          <td class="newstext" align="right">
	    <a class="topbanner" href="{$fsf}/home.es.html">FSF</a>
            &nbsp;&nbsp;|&nbsp;&nbsp;
	    <a class="topbanner" href="{$gnu}/home.es.html">GNU</a>
            &nbsp;&nbsp;|&nbsp;&nbsp;
	    <a class="topbanner" href="http://es.gnu.org/">GNU España</a><br/>
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
	  &nbsp;<a href="{$fsffrance}/index.fr.html" class="T1">Francia</a> |
	    Alemania
	</td>
      </tr>
    </table>

    <!-- Title bar -->
    <table width="100%" border="0" cellspacing="0" cellpadding="4">
	<tr>
	  <td class="TopBody">
          <!--
	    <a href="{$fsfeurope}/index.es.html">
	      <img src="{$fsfeurope}/images/gnulogo.jpg" alt="Logo de GNU" border="0" />
	    </a>
	  -->&nbsp;
	  </td>
	  <td class="TopBody" width="99%" height="99%">
	    <a class="TopTitleB">FSF Europa</a>
	    <br/>
	    <!--
	    <a class="TopTitle">Software Libre - igualdad de oportunidades para personas y empresas</a>
	    -->
	  </td>
	  <td align="right" valign="top" class="TopBody">
	    <a href="{$fsfeurope}/documents/freesoftware.html" class="T2">Qué&nbsp;es&nbsp;Software&nbsp;Libre?</a><br/>
	    <a href="{$fsfeurope}/documents/gnuproject.html" class="T2">Qué&nbsp;es&nbsp;el&nbsp;proyecto&nbsp;GNU?</a><br/>
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
	<!-- Columna de menú. Al lado derecho para que Lynx la vea mejor.  -->
	<td>&nbsp;</td>
	<td valign="top" class="TopBody">
          <table summary="" width="150" border="0" cellspacing="0"
          cellpadding="4">
            <tr><td class="TopTitle" align="center">Proyectos</td></tr>
              <tr>
                <td class="TopBody" align="right">
                  <a href="{$fsfeurope}/law/law.en.html" class="T2">Proteger&nbsp;el&nbsp;Software&nbsp;Libre</a><br />
                  <a href="{$fsfeurope}/coposys/index.en.html" class="T2">Coposys</a><br />
                </td>
              </tr>
            <tr>
              <td class="TopTitle" align="center">Secciones</td>
            </tr>
            <tr>
              <td align="right" class="Section"><br/>
              <xsl:choose>
                <xsl:when test="$path='index.es.xhtml'">Principal</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/index.es.html" class="T2">Principal</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='contact/contact.xhtml'">Contactos</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/contact/contact.html" class="T2">Contactos</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='about/about.xhtml'">Acerca de FSFE</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/about/about.html" class="T2">Acerca
      de FSFE</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='background.xhtml'">Contexto</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/background.html" class="T2">Contexto</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='documents/documents.xhtml'">Documentos</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/documents/documents.html" class="T2">Documentos</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='mailman/index.xhtml'">Listas de Correo</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/mailman/index.html" class="T2">Listas de Correo</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='news/news.xhtml'">Noticias</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/news/news.html" class="T2">Noticias</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                 <xsl:when test="$path='press/index.xhtml'">Para la Prensa</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/press/index.html" class="T2">Para la Prensa</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='gbn/index.xhtml'">Red Empresarial GNU</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/gbn/index.html" class="T2">Red Empresarial GNU</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <br/></td>
            </tr>

            <tr>
              <td class="TopTitle" align="center">Organizaciones associadas</td>
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
              <td class="TopTitle" align="center">Administración</td>
            </tr>
            <tr>
              <td align="right"><br/>
              <a href="http://savannah.gnu.org/projects/fsfe/"
                   class="T2">Introducción</a><br/>
              <a href="http://www.gnu.org/server/standards/"
                   class="T2">Guía GNU</a><br/>
              <a href="http://savannah.gnu.org/pm/?group_id=53"
                   class="T2">Tareas</a><br/>
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
          <a href="{$filebase}.xhtml" class="T1">Fuente XHTML</a>&nbsp;&nbsp;|
          &nbsp;&nbsp;<a href="{$fsfeurope}/fsfe.xsl" class="T1">Página de
    estiol XSL</a><br/>
	</td>
	<td class="TopTitle" align="right">
	  &nbsp;<a href="mailto:webmaster@fsfeurope.org"
                   class="T1">webmaster@fsfeurope.org</a>
        </td>
      </tr>
      <tr>
	<td class="Body" align="center">
	<font size="-2">
	  Copyright (C) 2001 FSF Europa<br/>
          Se permite la copia textual y distribución de este artículo en su
	  totalidad, por cualquier medio, siempre y cuando se mantenga esta
	  nota de copyright.
	</font>
	</td>
        <td class="Body">&nbsp;</td>
      </tr>
    </table>
  </xsl:template> 

</xsl:stylesheet>

