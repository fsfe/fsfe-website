<?xml version="1.0" encoding="iso-8859-1" ?>
<!DOCTYPE xsl:stylesheet [<!ENTITY nbsp "&#160;">
<!ENTITY copy "&#169;">]>
<xsl:stylesheet version="1.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" encoding="iso-8859-1" doctype-public="-//W3C//DTD HTML 1.0 Transitional//EN&quot; &quot;http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" />

<!-- $Id: fsfe.xsl,v 1.1 2001-04-20 10:43:13 villate Exp $ -->
<xsl:template match="webpage">
<html>
  <head>
    <title>
    <xsl:text></xsl:text><xsl:value-of select="title"/>
    </title>
    <link rel="stylesheet" type="text/css" href="blue.css"/>
  </head>
  <body>
    <xsl:apply-templates select="webfolders"/>

    <!-- Title bar -->
    <table summary="" width="100%" border="0" cellspacing="0" cellpadding="4">
	<tr>
	  <td class="TopBody">
	    <a href="http://france.fsfeurope.org/index.fr.shtml">
	      <img src="images/gnulogo.jpg" alt="GNU Logo" border="0" />
	    </a>
	  </td>
	  <td class="TopBody" width="99%" height="99%">
	    <a class="TopTitleB">FSF Europe</a>
	    <br />
	    <a class="TopTitle">Free Software is the concience of software</a>
	  </td>
	  <td align="right" valign="bottom" class="TopBody">
	    <a href="http://france.fsfeurope.org/index.fr.shtml" class="T2">France</a><br/>
	    <a href="http://www.fsfeurope.org/index.fr.html" class="T2">Europe</a><br/>
	    <a href="http://www.fsf.org/home.fr.html" class="T2">Etats-Unis</a>
	  </td>
	</tr>
    </table>
    <table summary="" width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
	  <td width="99%" valign="top">
            <div align="center">
            <xsl:apply-templates select="translations"/>
            </div>
            <xsl:apply-templates select="para|sect1|news|itemizedlist|figure|
              simplelist|variablelist|orderedlist|programlisting|form|table"/>
	    <br/>
	  </td>

	  <!-- Menu column. On the right to be Lynx friendly.  -->
	  <td>&nbsp;</td>
	  <td valign="top" class="TopBody">
            <xsl:apply-templates select="webmenu"/>
	  </td>
    	</tr>
    </table>

    <!-- Bottom line -->
    <table summary="" width="100%" border="0" cellspacing="0" cellpadding="2">
	<tr>
	  <td class="TopTitle">
	    &nbsp;<a href="mailto:webmaster@fsfeurope.org" class="T1">webmaster@fsfeurope.org</a><br />
	  </td>
	</tr>
	<tr>
	  <td class="TopBody" align="center">
	    <p>Copyright (C) 2001 FSF Europe</p>
	    <p>Verbatim copying and distribution of this entire article is
             permitted in any medium, provided this notice is preserved.</p>
	  </td>
	</tr>
    </table>
  Last update:
<!-- timestamp start -->
$Date: 2001-04-20 10:43:13 $ $Author: villate $
<!-- timestamp end -->
  </body>
</html>
</xsl:template>

<xsl:template match="webmenu">
	    <table summary="" width="120" border="0" cellspacing="0" cellpadding="4">
               <xsl:apply-templates />
	    </table>
</xsl:template>


<xsl:template match="menudiv">
		<tr><td class="TopTitle" align="center"><xsl:apply-templates select="title"/></td></tr>
		<tr>
		  <td align="right">
                  <xsl:apply-templates select="menuentry" />
		  </td>
		</tr>
</xsl:template>

<xsl:template match="menuentry">
                   <xsl:element name="a">
                     <xsl:attribute name="href">
	               <xsl:value-of select="@url"/>
                     </xsl:attribute>
                     <xsl:attribute name="class">T2</xsl:attribute>
                     <xsl:apply-templates/>
                   </xsl:element><br/>
</xsl:template>

<xsl:template match="webfolders">
  <xsl:apply-templates />
</xsl:template>


<xsl:template match="foldersdiv[1]">
    <table summary="" cellspacing="0" cellpadding="0" width="100%" border="0">
      <tr valign="middle" bgcolor="#6f6f6f">
      <td><img src="images/pix.png" width="1" height="1" alt="" /></td>
      </tr>
    </table>
    <table summary="" cellspacing="0" cellpadding="1" width="100%" border="0"> 
	<tr valign="middle"> 
	  <td class="newstext">
	    &nbsp;
          <xsl:apply-templates select="folderentry" />
	  </td>
       </tr>
    </table>
</xsl:template>

<xsl:template match="foldersdiv[2]">
    <table summary="" cellspacing="0" cellpadding="0" width="100%" border="0">
	<tr valign="middle" bgcolor="#6f6f6f">
	  <td><img src="images/pix.png" width="1" height="1" alt="" /></td>
	</tr>
    </table>

    <!-- Top menu line -->
    <table summary="" width="100%" border="0" cellspacing="0" cellpadding="4">
	<tr>
	  <td class="TopTitle">
          <xsl:for-each select="folderentry">
            <xsl:choose>
            <xsl:when test="position()=last()"></xsl:when>
            <xsl:otherwise>
            <xsl:element name="a">
              <xsl:attribute name="href">
              <xsl:value-of select="@url"/>
              </xsl:attribute>
              <xsl:attribute name="class">T1</xsl:attribute>
              <xsl:apply-templates/>
            </xsl:element> |
            </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
	  </td>
	  <td class="TopTitle" align="right">
          <xsl:for-each select="folderentry">
            <xsl:choose>
            <xsl:when test="position()=last()">
            <xsl:element name="a">
              <xsl:attribute name="href">
              <xsl:value-of select="@url"/>
              </xsl:attribute>
              <xsl:attribute name="class">T1</xsl:attribute>
              <xsl:apply-templates/>
            </xsl:element>
            </xsl:when>
            <xsl:otherwise></xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
	  </td>
	</tr>
    </table>
</xsl:template>

<xsl:template match="folderentry">
              <xsl:element name="a">
                <xsl:attribute name="href">
                <xsl:value-of select="@url"/>
                </xsl:attribute>
                <xsl:attribute name="class">topbanner</xsl:attribute>
                <xsl:apply-templates/>
              </xsl:element>&nbsp;·&nbsp;
</xsl:template>

<xsl:template match="language">
[ 
  <xsl:choose>
    <xsl:when test="@url">
      <xsl:element name="a">
        <xsl:attribute name="href">
          <xsl:value-of select="@url"/>
        </xsl:attribute>
        <xsl:apply-templates/>
      </xsl:element>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>
 ]
</xsl:template>

<xsl:template match="news">
  <h2>News</h2>
  <dl>
    <xsl:apply-templates/>
  </dl>
</xsl:template>

<xsl:template match="newsentry">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="newsentry/date">
  <dt>
    <b><xsl:apply-templates/></b>
  </dt>
</xsl:template>

<xsl:template match="newsentry/para">
  <dd>
     <xsl:apply-templates/>
  </dd>
</xsl:template>

<xsl:template match="sect1">
  <xsl:apply-templates/>
</xsl:template>

  <xsl:template match="sect1/title">
    <xsl:element name="h2">
      <xsl:choose>
	<xsl:when test="ancestor::sect1[@id]">
	  <xsl:element name="a">
	    <xsl:attribute name="name">
	      <xsl:value-of select="ancestor::sect1/@id"/>
	    </xsl:attribute>
	    <xsl:apply-templates/>
	  </xsl:element>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:apply-templates/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>

<xsl:template match="sect1/title" mode="crossref">
  <i><xsl:apply-templates/></i>
</xsl:template>

<xsl:template match="sect2">
  <xsl:apply-templates/>
</xsl:template>

  <xsl:template match="sect2/title">
    <xsl:element name="h3">
      <xsl:choose>
	<xsl:when test="ancestor::sect2[@id]">
	  <xsl:element name="a">
	    <xsl:attribute name="name">
	      <xsl:value-of select="ancestor::sect2/@id"/>
	    </xsl:attribute>
	    <xsl:apply-templates/>
	  </xsl:element>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:apply-templates/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>

<xsl:template match="sect2/title" mode="crossref">
  <i><xsl:apply-templates/></i>
</xsl:template>

<xsl:template match="sect3">
  <xsl:apply-templates/>
</xsl:template>

  <xsl:template match="sect3/title">
    <xsl:element name="h4">
      <xsl:choose>
	<xsl:when test="ancestor::sect3[@id]">
	  <xsl:element name="a">
	    <xsl:attribute name="name">
	      <xsl:value-of select="ancestor::sect3/@id"/>
	    </xsl:attribute>
	    <xsl:apply-templates/>
	  </xsl:element>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:apply-templates/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>

<xsl:template match="sect3/title" mode="crossref">
  <i><xsl:apply-templates/></i>
</xsl:template>

<xsl:template match="sect4">
  <xsl:apply-templates/>
</xsl:template>

  <xsl:template match="sect4/title">
    <xsl:element name="h5">
      <xsl:choose>
	<xsl:when test="ancestor::sect4[@id]">
	  <xsl:element name="a">
	    <xsl:attribute name="name">
	      <xsl:value-of select="ancestor::sect4/@id"/>
	    </xsl:attribute>
	    <xsl:apply-templates/>
	  </xsl:element>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:apply-templates/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>

<xsl:template match="sect4/title" mode="crossref">
  <i><xsl:apply-templates/></i>
</xsl:template>

<xsl:template match="sect5">
  <xsl:apply-templates/>
</xsl:template>

  <xsl:template match="sect5/title">
    <xsl:element name="h5">
      <xsl:choose>
	<xsl:when test="ancestor::sect5[@id]">
	  <xsl:element name="a">
	    <xsl:attribute name="name">
	      <xsl:value-of select="ancestor::sect5/@id"/>
	    </xsl:attribute>
	    <xsl:apply-templates/>
	  </xsl:element>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:apply-templates/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>

<xsl:template match="sect5/title" mode="crossref">
  <i><xsl:apply-templates/></i>
</xsl:template>

<xsl:template match="bibliography/title">
<h2><xsl:apply-templates/></h2>
</xsl:template>

<xsl:template match="bibliomset/title">
<i><xsl:apply-templates/></i>
</xsl:template>

<xsl:template match="jobtitle">
  <br/><xsl:apply-templates/>
</xsl:template>

<xsl:template match="orgname">
  <br/><i><xsl:apply-templates/></i>
</xsl:template>

<xsl:template match="address">
  <br/><i><xsl:apply-templates/></i>
</xsl:template>

<xsl:template match="email">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="artheader/date">
<br/><br/><xsl:apply-templates/>
</xsl:template>

<xsl:template match="itemizedlist">
  <ul>
    <xsl:apply-templates/>
  </ul>
</xsl:template>

<xsl:template match="orderedlist">
  <ol>
    <xsl:apply-templates/>
  </ol>
</xsl:template>

<xsl:template match="variablelist">
  <dl>
    <xsl:apply-templates/>
  </dl>
</xsl:template>

<xsl:template match="programlisting">
  <div align="center">
  <table width="90%" border="0" bgcolor="#999999" summary="program-listing">
<tr><td><br/><br/><pre><xsl:apply-templates/></pre></td></tr>
  </table>
  </div>
</xsl:template>

<xsl:template match="varlistentry/term">
  <dt>
    <b><xsl:apply-templates/></b>
  </dt>
</xsl:template>

<xsl:template match="varlistentry/listitem">
  <dd>
    <xsl:apply-templates/>
  </dd>
</xsl:template>

<xsl:template match="itemizedlist/listitem">
  <li>
    <xsl:apply-templates/>
  </li>
</xsl:template>

<xsl:template match="orderedlist/listitem">
  <li>
    <xsl:apply-templates/>
  </li>
</xsl:template>

<xsl:template match="footnote/para">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="para">
  <p>
    <xsl:apply-templates/>
  </p>
</xsl:template>

<xsl:template match="quote">
&quot;<xsl:apply-templates/>&quot;
</xsl:template>

<xsl:template match="command">
<b><xsl:apply-templates/></b>
</xsl:template>

<xsl:template match="emphasis">
  <b><xsl:apply-templates/></b>
</xsl:template>

<xsl:template match="literal">
  <tt><xsl:apply-templates/></tt>
</xsl:template>

<xsl:template match="footnote">
  (<small><xsl:apply-templates/></small>)
</xsl:template>

<xsl:template match="ulink">
  <xsl:element name="a">
  <xsl:attribute name="href">
  <xsl:value-of select="./@url"/>
  </xsl:attribute>
  <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="figure">
  <br/><br/>
  <xsl:element name="div">
  <xsl:attribute name="align">
  <xsl:choose>
  <xsl:when test='@align'>
  <xsl:value-of select="@align"/>
  </xsl:when>
  <xsl:otherwise>
  <xsl:text>center</xsl:text>
  </xsl:otherwise>
  </xsl:choose>
  </xsl:attribute>
  <xsl:for-each select="graphic">
  <xsl:element name="img">
  <xsl:attribute name="src">
  <xsl:value-of select="@fileref"/>.<xsl:value-of select="@format"/>
  </xsl:attribute>
  <xsl:attribute name="alt">
  <xsl:value-of select="@fileref"/>.<xsl:value-of select="@format"/>
  </xsl:attribute>
  </xsl:element>
  </xsl:for-each>
  <br/><br/>
  <b>Fig. <xsl:value-of select="@label"/></b><xsl:apply-templates select="title"/>
  </xsl:element>
  <br/><br/>
</xsl:template>

<xsl:template match="figure/title">
<xsl:text>: </xsl:text><xsl:apply-templates/>
</xsl:template>

<xsl:template match="inlinegraphic">
  <xsl:element name="img">
  <xsl:attribute name="src">
  <xsl:value-of select="@fileref"/>.<xsl:value-of select="@format"/>
  </xsl:attribute>
  <xsl:attribute name="alt">
  <xsl:value-of select="@fileref"/>.<xsl:value-of select="@format"/>
  </xsl:attribute>
  </xsl:element>
</xsl:template>

<xsl:template match="anchor">
  <xsl:element name="a">
    <xsl:attribute name="name">
      <xsl:value-of select="./@id"/>
    </xsl:attribute>
  </xsl:element>
</xsl:template>

  <xsl:template match="link">
    <xsl:element name="a">
      <xsl:attribute name="href">
	<xsl:text>#</xsl:text><xsl:value-of select="./@linkend"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="xref">
    <xsl:variable name="linkend" select="@linkend"/>
    <xsl:element name="a">
      <xsl:attribute name="href">
	<xsl:text>#</xsl:text><xsl:value-of select="$linkend"/>
      </xsl:attribute>
      <xsl:apply-templates select="//*[@id=$linkend]/title"
			   mode="crossref"/>
    </xsl:element>
  </xsl:template>

<xsl:template match="bibliography">
  <xsl:choose>
  <xsl:when test='title'>
  <xsl:apply-templates select="title"/>
  </xsl:when>
  <xsl:otherwise>
  <h2>Bibliografia</h2>
  </xsl:otherwise>
  </xsl:choose>
  <xsl:apply-templates select="bibliomixed"/>
</xsl:template>

<xsl:template match="bibliomixed">
  <ol>
  <xsl:apply-templates/>
  </ol>
</xsl:template>

<xsl:template match="bibliomset">
  <li><xsl:apply-templates/></li>
</xsl:template>

<xsl:template match="volumenum">
  <b><xsl:apply-templates/></b>
</xsl:template>

<xsl:template match="firstname">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="surname">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="issuenum">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="publishername">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="corpname">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="editor">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="pubdate">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="edition">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="pagenums">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="isbn">
  ISBN: <xsl:apply-templates/>
</xsl:template>

<xsl:template match="issn">
  ISNN: <xsl:apply-templates/>
</xsl:template>

<xsl:template match="releaseinfo">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="simplelist">
  <table summary="list">
  <xsl:apply-templates/>
  </table>
</xsl:template>

<xsl:template match="member">
  <tr><td><xsl:apply-templates/></td></tr>
</xsl:template>

<xsl:template match="form">
  <xsl:element name="form">
  <xsl:attribute name="action">
  <xsl:value-of select="@action"/>
  </xsl:attribute>
  <xsl:attribute name="method">
  <xsl:value-of select="@method"/>
  </xsl:attribute><xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="input">
  <xsl:element name="input">
  <xsl:attribute name="type">
  <xsl:value-of select="@type"/>
  </xsl:attribute>
  <xsl:if test="@name">
  <xsl:attribute name="name">
  <xsl:value-of select="@name"/>
  </xsl:attribute>
  </xsl:if>
  <xsl:if test="@value">
  <xsl:attribute name="value">
  <xsl:value-of select="@value"/>
  </xsl:attribute>
  </xsl:if>
  <xsl:if test="@checked">
  <xsl:attribute name="checked">
  <xsl:value-of select="@checked"/>
  </xsl:attribute>
  </xsl:if>
  <xsl:if test="@size">
  <xsl:attribute name="size">
  <xsl:value-of select="@size"/>
  </xsl:attribute>
  </xsl:if>
  <xsl:if test="@maxlength">
  <xsl:attribute name="maxlength">
  <xsl:value-of select="@maxlength"/>
  </xsl:attribute>
  </xsl:if>
  <xsl:if test="@src">
  <xsl:attribute name="src">
  <xsl:value-of select="@src"/>
  </xsl:attribute>
  </xsl:if>
  <xsl:if test="@align">
  <xsl:attribute name="align">
  <xsl:value-of select="@align"/>
  </xsl:attribute>
  </xsl:if>
  </xsl:element>
</xsl:template>

<xsl:template match="select">
  <xsl:element name="select">
  <xsl:if test="@name">
  <xsl:attribute name="name">
  <xsl:value-of select="@name"/>
  </xsl:attribute>
  </xsl:if>
  <xsl:if test="@size">
  <xsl:attribute name="size">
  <xsl:value-of select="@size"/>
  </xsl:attribute>
  </xsl:if>
  <xsl:if test="@multiple">
  <xsl:attribute name="multiple">
  <xsl:value-of select="@multiple"/>
  </xsl:attribute>
  </xsl:if>
  <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="option">
  <xsl:element name="option">
  <xsl:if test="@selected">
  <xsl:attribute name="selected">
  <xsl:value-of select="@selected"/>
  </xsl:attribute>
  </xsl:if>
  <xsl:if test="@value">
  <xsl:attribute name="value">
  <xsl:value-of select="@value"/>
  </xsl:attribute>
  </xsl:if>
  <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="textarea">
  <xsl:element name="textarea">
  <xsl:if test="@name">
  <xsl:attribute name="name">
  <xsl:value-of select="@name"/>
  </xsl:attribute>
  </xsl:if>
  <xsl:if test="@wrap">
  <xsl:attribute name="wrap">
  <xsl:value-of select="@wrap"/>
  </xsl:attribute>
  </xsl:if>
  <xsl:attribute name="rows">
  <xsl:value-of select="@rows"/>
  </xsl:attribute>
  <xsl:attribute name="cols">
  <xsl:value-of select="@cols"/>
  </xsl:attribute>
  <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

</xsl:stylesheet>
