<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet [<!ENTITY nbsp "&#160;">
                          <!ENTITY eur "&#128;">]>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="/html[@lang='es']/body/div">
    <!-- FSF related sites -->
    <table cellspacing="0" cellpadding="1" width="100%" border="0"
     summary="FSF friend sites"> 
      <tr valign="middle"> 
	  <td class="newstext">
	    &nbsp;&nbsp;
            <a href="{$fsfeurope}/index.es.html">FSF Europa</a>
          </td>
          <td class="newstext" align="right">
	    <a href="{$fsf}/home.es.html">FSF</a>
            &nbsp;&nbsp;|&nbsp;&nbsp;
	    <a href="{$gnu}/home.es.html">GNU</a>
            &nbsp;&nbsp;|&nbsp;&nbsp;
	    <a href="http://es.gnu.org/">GNU España</a><br/>
	  </td>
       </tr>
    </table>

    <!-- Top menu line -->
    <table width="100%" border="0" cellspacing="0" cellpadding="4"
     summary="Top menu">
      <tr>
	<td class="TopTitle">
	  &nbsp;<a href="{$fsffrance}/index.fr.html">Francia</a> |
	    Alemania
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
	<!-- Columna de menú. Al lado derecho para que Lynx la vea mejor.  -->
	<td>&nbsp;</td>
	<td valign="top" class="TopBody">
          <table summary="" width="150" border="0" cellspacing="0"
          cellpadding="4">
            <tr><td class="TopTitle" align="center">Proyectos</td></tr>
              <tr>
                <td class="TopBody" align="right">
                  <a href="{$fsfeurope}/law/law.en.html">Proteger el Software Libre</a><br />
                  <a href="{$fsfeurope}/coposys/index.en.html">Coposys</a><br />
		  <a href="{$fsfeurope}/documents/whyfs.es.html">Nosotros
                  hablamos de Software Libre</a><br />
              <a href="{$fsfeurope}/education/education.html">Free Software and Education</a><br />
                  <a href="{$fsfeurope}/law/eucd/eucd.en.html">EUCD</a><br />
                  <a href="{$fsfeurope}/projects/mankind/mankind.en.html">Free Software and World Heritage</a>
                </td>
              </tr>
            <tr>
              <td class="TopTitle" align="center">Secciones</td>
            </tr>
            <tr>
              <td align="right" class="TopBody"><br/>
              <xsl:choose>
                <xsl:when test="$path='index.es.xhtml'">Principal</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/index.es.html">Principal</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='contact/contact.xhtml'">Contactos</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/contact/contact.html">Contactos</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='about/about.xhtml'">Acerca de FSFE</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/about/about.html">Acerca
      de FSFE</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='background.xhtml'">Contexto</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/background.html">Contexto</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='documents/documents.xhtml'">Documentos</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/documents/documents.html">Documentos</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='mailman/index.xhtml'">Listas de Correo</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/mailman/index.html">Listas de Correo</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='news/news.xhtml'">Noticias</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/news/news.html">Noticias</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                 <xsl:when test="$path='press/index.xhtml'">Para la Prensa</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/press/index.html">Para la Prensa</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='gbn/index.xhtml'">Red Empresarial GNU</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/gbn/index.html">Red Empresarial GNU</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='order/order.en.xhtml'">Order</xsl:when>
                <xsl:otherwise>
		  <a href="{$fsfeurope}/order/order.en.html">Order</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <br/></td>
            </tr>

            <tr>
              <td class="TopTitle" align="center">Organizaciones associadas</td>
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
              <td class="TopTitle" align="center">Administración</td>
            </tr>
            <tr>
              <td align="right"><br/>
              <a href="http://savannah.gnu.org/projects/fsfe/"
                  >Introducción</a><br/>
              <a href="http://www.gnu.org/server/standards/"
                  >Guía GNU</a><br/>
              <a href="http://savannah.gnu.org/pm/?group_id=53"
                  >Tareas</a><br/>
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
          <a href="{$filebase}.xhtml">Fuente XHTML</a>&nbsp;&nbsp;|
          &nbsp;&nbsp;<a href="{$fsfeurope}/fsfe.xsl">Página de
    estilo XSL</a><br/>
	</td>
	<td class="TopTitle" align="right">
	  &nbsp;<a href="mailto:webmaster@fsfeurope.org"
                  >webmaster@fsfeurope.org</a>
        </td>
      </tr>
      <tr>
	<td class="newstext" align="center">
	<font size="-2">
	  Copyright (C) 2001 FSF Europa<br/>
          Se permite la copia textual y distribución de este artículo en su
	  totalidad, por cualquier medio, siempre y cuando se mantenga esta
	  nota de copyright.
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
