<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Insert local menu -->
  <xsl:template match="localmenu">

    <xsl:variable name="dir">
      <xsl:choose>
        <xsl:when test="@dir">
          <xsl:value-of select="@dir"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="/buildinfo/@dirname"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="set">
      <xsl:choose>
        <xsl:when test="@set">
          <xsl:value-of select="@set"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>default</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="own_id">
      <xsl:value-of select="@id"/>
    </xsl:variable>

    <xsl:variable name="language">
      <xsl:value-of select="/buildinfo/@language"/>
    </xsl:variable>

    <xsl:element name="ul">
      <xsl:attribute name="class">nav nav-tabs</xsl:attribute>
      <xsl:for-each select="/buildinfo/document/set/localmenuitems/menu[@dir=$dir and @set=$set]">
        <xsl:sort select="@id"/>

        <xsl:variable name="id">
          <xsl:value-of select="@id"/>
        </xsl:variable>

        <xsl:variable name="localmenutext">
          <xsl:choose>
            <xsl:when test="/buildinfo/document/set/translate/lang_part[@dir=$dir and @id=$id and @language=$language]">
              <xsl:value-of select="/buildinfo/document/set/translate/lang_part[@dir=$dir and @id=$id and @language=$language]"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="/buildinfo/document/set/translate/lang_part[@dir=$dir and @id=$id and @language='en']"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <xsl:element name="li">
          <xsl:attribute name="role">presentation</xsl:attribute>

          <xsl:if test="$id=$own_id">
            <xsl:attribute name="class">active</xsl:attribute>
          </xsl:if>

          <xsl:element name="a">
            <xsl:attribute name="href">
              <xsl:value-of select="@dir"/>
              <xsl:value-of select="."/>
            </xsl:attribute>
            <xsl:value-of select="$localmenutext"/>
          </xsl:element>
        </xsl:element><!-- /li -->

      </xsl:for-each>
    </xsl:element><!-- /ul -->
  </xsl:template>

</xsl:stylesheet>

