<?xml version='1.0'?>
<xsl:stylesheet
          xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>
<xsl:output method="html"/>

<xsl:param name="lang"/>

<xsl:template match="translation">
<HTML><HEAD><TITLE>
<xsl:value-of select="./transinfo/title[@lang=$lang]"/>
</TITLE>
</HEAD>
<BODY>

<center>
<xsl:choose>
  <xsl:when test="$lang">
    <h1>
      <xsl:value-of select="./transinfo/title[@lang=$lang]"/>
    </h1>
  </xsl:when>
  <xsl:otherwise>
    <h1>
      <xsl:value-of select="./transinfo/title[@lang=/translation@dst]"/>
    </h1>
    <h2>
      (<xsl:value-of select="./transinfo/title[@lang=/translation@src]"/>)
    </h2>
  </xsl:otherwise>
</xsl:choose>

<b>
<xsl:apply-templates select="transinfo/authorgroup"/>
</b>
</center>

<p>
<em>
<xsl:choose>
  <xsl:when test="$lang">
    <p>
      <xsl:value-of select="./transinfo/abstract[@lang=$lang]"/>
    </p>
  </xsl:when>
  <xsl:otherwise>
    <table cellpadding="5" width="100%">
      <tr valign="top">
        <td width="50%">
	  <b>Original:</b><p/>
          <em><xsl:value-of select="./transinfo/abstract[@lang=/translation@src]"/></em>
        </td>
        <td width="10" background="vertical.jpeg"><font color="White">.</font></td>
        <td>
          <b>Traduction:</b><p/>
          <em><xsl:value-of select="./transinfo/abstract[@lang=/translation@dst]"/></em>
        </td>
      </tr>
    </table>
  </xsl:otherwise>
</xsl:choose>
</em>
</p>
<hr/>
 
<xsl:apply-templates select="section"/>

<p/>

</BODY>
</HTML>
</xsl:template>

<xsl:template match="authorgroup/author">
<p>
<xsl:value-of select="name"/>, <xsl:if test="organisation">
<xsl:value-of select="organisation"/>, 
</xsl:if>
<a>
<xsl:attribute name="href">mailto:<xsl:value-of select="email"/>
</xsl:attribute>
<xsl:value-of select="email"/>
</a>
</p>
</xsl:template>

<xsl:template match="section">
<xsl:choose>
  <xsl:when test="$lang">
    <h2>
      <xsl:value-of select="title[@lang=$lang]"/>
    </h2>
  </xsl:when>
  <xsl:otherwise>
    <h2>
      <xsl:value-of select="title[@lang=/translation@dst]"/>
      (<xsl:value-of select="title[@lang=/translation@src]"/>)
    </h2>
  </xsl:otherwise>
</xsl:choose>

<xsl:apply-templates select="para"/>

</xsl:template>

<xsl:template match="para">
<p>
<xsl:choose>
  <xsl:when test="$lang">
    <xsl:if test="$lang=/translation/@dst">
      <xsl:apply-templates select="dst"/>
    </xsl:if>
    <xsl:if test="$lang=/translation/@src">
      <xsl:apply-templates select="src"/>
    </xsl:if>
  </xsl:when>
  <xsl:otherwise>
    <table cellpadding="5" width="100%" valign="top">
      <tr valign="top">
        <td width="50%">
	  <b>Original:</b><p/>
          <xsl:apply-templates select="src"/>
        </td>
        <td width="10" background="vertical.jpeg"><font color="White">.</font></td>
        <td width="50%">
	  <b>Traduction:</b><p/>
          <xsl:apply-templates select="dst"/>
        </td>
      </tr>
    </table>
  </xsl:otherwise>
</xsl:choose>
</p>
<xsl:apply-templates select="notes"/>
</xsl:template>


<xsl:template match="para/notes">
<table bgcolor="LightSteelBlue" width="100%">
<tr><td>
<xsl:choose>
  <xsl:when test="$lang">
    <xsl:choose>
      <xsl:when test="@lang">
        <xsl:if test="@lang=$lang">
          <xsl:apply-templates/>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:when>
  <xsl:otherwise>
    <xsl:apply-templates/>
  </xsl:otherwise>
</xsl:choose>
</td></tr>
</table>
</xsl:template>

</xsl:stylesheet>
