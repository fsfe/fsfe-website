<?xml version="1.0" encoding="ISO-8859-2"?>
<!DOCTYPE xsl:stylesheet [<!ENTITY nbsp "&#160;">
                          <!ENTITY eur "&#128;">]>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="/html[@lang='cs']/body/div">
    <!-- FSF related sites -->
    <table cellspacing="0" cellpadding="1" width="100%" border="0"> 
      <tr valign="middle"> 
	  <td class="newstext">
	    &nbsp;&nbsp;
            <a href="{$fsfeurope}/">FSF Evropa</a>
          </td>
          <td class="newstext" align="right">
	    <a href="{$fsf}/">FSF</a>
            &nbsp;&nbsp;|&nbsp;&nbsp;
	    <a href="{$gnu}/">GNU</a>
            &nbsp;&nbsp;|&nbsp;&nbsp;
	    <a href="http://es.gnu.org/">GNU �pan�lsko</a><br/>
	  </td>
       </tr>
    </table>

    <!-- Top menu line -->
    <table width="100%" border="0" cellspacing="0" cellpadding="4">
      <tr>
	<td class="TopTitle">
	  &nbsp;<a href="{$fsffrance}/index.en.html">Francie</a> |
	    N�m�cko
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

    <table width="100%" border="0" cellspacing="0">
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

   		<tr><td class="TopTitle" align="center">Projekty</td></tr>
		<tr>
		  <td class="TopBody" align="right">
		    <a href="{$fsfeurope}/law/law.en.html">Ochrana Svobodn�ho software</a><br />
		    <a href="{$fsfeurope}/coposys/index.en.html">Coposys</a><br />
		    <a href="{$fsfeurope}/documents/whyfs.en.html">Mluv�me o svobodn�m software</a><br />
              <a href="{$fsfeurope}/education/education.html">Svobodn� software a vzd�l�v�n�</a><br />
		  </td>
		</tr>

            <tr>
              <td class="TopTitle" align="center">Sekce</td>
            </tr>
            <tr>
              <td align="right" class="TopBody"><br/>
              <xsl:choose>
                <xsl:when test="$path='index.xhtml'">Hlavn� str�nka</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/index.html">Hlavn� str�nka</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='contact/contact.xhtml'">Kontakty</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/contact/contact.html">Kontakty</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='about/index.xhtml'">O n�s</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/about/index.html">O n�s</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='help/help.xhtml'">N�pov�da</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/help/help.html">N�pov�da</a>
                </xsl:otherwise>
              </xsl:choose><br/>

              <xsl:choose>
                <xsl:when test="$path='help/donate-2002.xhtml'">P�isp�jte</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/help/donate-2002.html">P�isp�jte</a>
                </xsl:otherwise>
              </xsl:choose><br/>

              <xsl:choose>
                <xsl:when test="$path='help/thankgnus-2002.xhtml'">Pod�kov�n�</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/help/thankgnus-2002.html">Pod�kov�n�</a>
                </xsl:otherwise>
              </xsl:choose><br/>

              <xsl:choose>
                <xsl:when test="$path='background.xhtml'">Souvislosti</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/background.html">Souvislosti</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='documents/documents.xhtml'">Dokumenty</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/documents/documents.html">Dokumenty</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='mailman/index.xhtml'">Emailov� konference</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/mailman/index.html">Emailov� konference</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='news/news.xhtml'">Novinky</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/news/news.html">Novinky</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='events/events.en.xhtml'">Ud�losti</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/events/events.en.html">Ud�losti</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='press/index.xhtml'">Pro tisk</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/press/index.html">Pro tisk</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='speakers/speakers.xhtml'">Mluv��</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/speakers/speakers.html">Mluv��</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='gbn/index.xhtml'">Obchodn� s� GNU</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/gbn/index.html">Obchodn� s� GNU</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <xsl:choose>
                <xsl:when test="$path='order/announce.de.xhtml'">fan articles</xsl:when>
                <xsl:otherwise>
                  <a href="{$fsfeurope}/order/announce.de.html">fan articles</a>
                </xsl:otherwise>
              </xsl:choose><br/>
              <br/></td>
            </tr>

        	<tr><td class="TopTitle" align="center">P�idru�en� organizace</td></tr>
		<tr>
		  <td class="TopBody" align="right">
		    <a href="http://www.ansol.org/">ANSOL</a><br />
		    <a href="http://www.april.org/">APRIL</a><br />
		    <a href="http://www.softwarelibero.it">AsSoLi</a><br />
		    <a href="http://www.fsf.or.at">FFS</a><br />
		    <a href="http://www.ofset.org/">OFSET</a><br />
	          </td>
		</tr>

            <tr>
              <td class="TopTitle" align="center">Admin</td>
            </tr>
            <tr>
              <td align="right"><br/>
              <a href="http://savannah.gnu.org/projects/fsfe/"
                   >O projektu</a><br/>
              <a href="http://www.gnu.org/server/standards/"
                   >Pr�vodce GNU</a><br/>
              <a href="http://savannah.gnu.org/pm/?group_id=53"
                   >�lohy</a><br/>
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
          <a href="{$filebase}.xhtml">XHTML zdroj</a>&nbsp;&nbsp;|
          &nbsp;&nbsp;<a href="{$fsfeurope}/fsfe.xsl">XSL stylesheet</a>&nbsp;&nbsp;| <a
      href="http://savannah.gnu.org/cgi-bin/viewcvs/fsfe/{$path}?cvsroot=www.gnu.org"
     >Zm�ny</a><br/>
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
	Doslovn� kop�rov�n� a distribuce tohoto dokumentu jsou povoleny
	na jak�mkoliv m�diu za p�edpokladu, �e bude zachov�no toto upozorn�n�.
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
