<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" encoding="UTF-8" indent="yes" />

  <!-- Insert local menu -->
  <xsl:template match="localmenu">
    <xsl:variable name="set">
      <xsl:choose>
    <xsl:when test="@set">
      <xsl:value-of select="@set"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>0</xsl:text>
    </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="dir">
      <xsl:value-of select="/buildinfo/@dirname"/>
    </xsl:variable>
    <xsl:variable name="language">
      <xsl:value-of select="/buildinfo/@language"/>
    </xsl:variable>
    <xsl:element name="div">
      <xsl:attribute name="class">localmenu</xsl:attribute>
      <xsl:element name="p">
    <xsl:text>[ </xsl:text>
    <xsl:for-each select="/buildinfo/localmenuset/localmenuitems/menu[@dir=$dir and @set=$set]">
      <xsl:sort select="@id"/>
      <xsl:variable name="style"><xsl:value-of select="@style"/></xsl:variable>
      <xsl:variable name="id"><xsl:value-of select="@id"/></xsl:variable>
      <xsl:variable name="localmenutext">
        <xsl:choose>
          <xsl:when
        test="/buildinfo/localmenuset/translate/lang_part[@dir=$dir and @id=$id and @language=$language]">
        <xsl:value-of
          select="/buildinfo/localmenuset/translate/lang_part[@dir=$dir and @id=$id and @language=$language]"/>
          </xsl:when>
          <xsl:otherwise>
        <xsl:value-of
          select="/buildinfo/localmenuset/translate/lang_part[@dir=$dir and @id=$id and @language='en']"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:element name="span">
        <xsl:attribute name="class">local_menu_item</xsl:attribute>
        <xsl:choose>
          <xsl:when test="not(substring-before(concat(/buildinfo/@filename ,'.html'), string(.)))">
        <xsl:element name="a">
          <xsl:attribute name="href"><xsl:value-of select="."/></xsl:attribute>
          <xsl:value-of select="$localmenutext"/>
        </xsl:element>
          </xsl:when>
          <xsl:otherwise>
        <xsl:attribute name="href">bamboo</xsl:attribute>
          <xsl:value-of select="$localmenutext"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:element>
      <xsl:if test="position()!=last()">
        <xsl:choose>
          <xsl:when test="$style='number'">
        <xsl:text> | </xsl:text>
          </xsl:when>
          <xsl:otherwise>
        <xsl:text> ] [ </xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
    </xsl:for-each>
    <xsl:text> ]</xsl:text>
    
      </xsl:element><!--end wrapper-->
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>

