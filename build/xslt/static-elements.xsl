<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dt="http://xsltsl.org/date-time"
                xmlns:weekdays="."
                xmlns:months="."
                xmlns:str='http://xsltsl.org/string'
                exclude-result-prefixes="dt weekdays months str">
  <xsl:import href="../../tools/xsltsl/string.xsl" />

  <!-- auto generate ID for headings if doesn't already exist -->
  <xsl:template name="generate-id">
    <xsl:copy>
      <xsl:call-template name="generate-id-attribute" />

      <xsl:if test="@class">
          <xsl:attribute name="class">
            <xsl:value-of select="@class" />
          </xsl:attribute>
      </xsl:if>

      <xsl:apply-templates select="node()"/>

    </xsl:copy>
  </xsl:template>


  <xsl:template name="generate-id-attribute">
    <xsl:param name="title" select="''" />

    <xsl:variable name="title2">
      <xsl:choose>
        <xsl:when test="normalize-space($title)=''">
          <xsl:apply-templates select="node()" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$title" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="not(@id) or normalize-space($title)!=''">
        <!-- replace spaces with dashes -->
        <xsl:variable name="punctuation">.,:;!?&#160;&quot;'()[]&lt;&gt;>{}</xsl:variable>
        <xsl:variable name="formattedTitle1" select="translate(normalize-space(translate($title2,$punctuation,' ')),' ','-')"/>

        <xsl:variable   name="accents">áàâäãéèêëíìîïóòôöõúùûüçğ</xsl:variable>
        <xsl:variable name="noaccents">aaaaaeeeeiiiiooooouuuucg</xsl:variable>

        <xsl:variable name="formattedTitle2">
          <xsl:call-template name="str:to-lower">
            <xsl:with-param name="text" select="$formattedTitle1" />
          </xsl:call-template>
        </xsl:variable>

        <xsl:attribute name="id">
          <xsl:value-of select="concat('id-',translate($formattedTitle2,$accents,$noaccents))" />
        </xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="id">
          <xsl:value-of select="@id" />
        </xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
