<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dt="http://xsltsl.org/date-time" xmlns:weekdays="." xmlns:months="." xmlns:nl="." xmlns:str="http://xsltsl.org/string" version="1.0" exclude-result-prefixes="dt weekdays months nl str">
  <xsl:import href="../thirdparty/string.xsl"/>
  <xsl:template name="subscribe-nl">
    <xsl:variable name="lang">
      <xsl:value-of select="/buildinfo/document/@language"/>
    </xsl:variable>
    <xsl:variable name="yourname">
      <xsl:call-template name="gettext">
        <xsl:with-param name="id" select="'yourname'"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="email">
      <xsl:call-template name="gettext">
        <xsl:with-param name="id" select="'email'"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="submit">
      <xsl:call-template name="fsfe-gettext">
        <xsl:with-param name="id" select="'subscribe'"/>
      </xsl:call-template>
    </xsl:variable>
    <form class="form-inline" id="formnl" name="formnl" method="POST" action="https://my.fsfe.org/subscribe">
      <input type="hidden" name="language" value="{$lang}"/>
      <input type="input" style="display: none !important" name="password" tabindex="-1" autocomplete="off"/>
      <input id="yourname" name="name" type="text" required="required" placeholder="{$yourname}"/>
      <input id="email" name="email1" type="email" required="required" placeholder="{$email}"/>
      <fsfe-cd-referrer-input/>
      <input type="hidden" name="wants_info" value="yes"/>
      <input type="hidden" name="wants_newsletter_info" value="yes"/>
      <input type="hidden" name="category" value="i"/>
      <input id="submit" type="submit" value="{$submit}"/>
    </form>
  </xsl:template>
  <!-- auto generate ID for headings if doesn't already exist -->
  <xsl:template name="generate-id">
    <xsl:copy>
      <xsl:call-template name="generate-id-attribute"/>
      <xsl:if test="@class">
        <xsl:attribute name="class">
          <xsl:value-of select="@class"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template name="generate-id-attribute">
    <xsl:param name="title" select="''"/>
    <xsl:variable name="title2">
      <xsl:choose>
        <xsl:when test="normalize-space($title)=''">
          <xsl:apply-templates select="node()"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$title"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="not(@id) or normalize-space($title)!=''">
        <!-- replace spaces with dashes -->
        <xsl:variable name="punctuation">.,:;!? "'()[]&lt;&gt;&gt;{}</xsl:variable>
        <xsl:variable name="formattedTitle1" select="translate(normalize-space(translate($title2,$punctuation,' ')),' ','-')"/>
        <xsl:variable name="accents">áàâäãéèêëíìîïóòôöõúùûüçğ</xsl:variable>
        <xsl:variable name="noaccents">aaaaaeeeeiiiiooooouuuucg</xsl:variable>
        <xsl:variable name="formattedTitle2">
          <xsl:call-template name="str:to-lower">
            <xsl:with-param name="text" select="$formattedTitle1"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:attribute name="id">
          <xsl:value-of select="concat('id-',translate($formattedTitle2,$accents,$noaccents))"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="id">
          <xsl:value-of select="@id"/>
        </xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
