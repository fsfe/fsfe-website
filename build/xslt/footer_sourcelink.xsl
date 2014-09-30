<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template name="footer_sourcelink">
    <xsl:element name="section">
      <xsl:attribute name="id">source</xsl:attribute>
  
      <!-- "Last changed" magic -->
      <p>
        <xsl:variable name="timestamp">
          <xsl:value-of select="/buildinfo/document/timestamp"/>
        </xsl:variable>
            <!-- FIXME: over time, all pages should have the timestamp -->
            <!--        tags, so this conditional could be removed     -->
        <xsl:if test="string-length($timestamp) &gt; 0">
          <xsl:variable name="Date">
            <xsl:value-of select="substring-before(substring-after($timestamp, 'Date: '), ' $')"/>
          </xsl:variable>
          <xsl:variable name="Author">
            <xsl:value-of select="substring-before(substring-after($timestamp, 'Author: '), ' $')"/>
          </xsl:variable>
          <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'lastchanged'" /></xsl:call-template>
          <xsl:value-of select="translate ($Date, '/', '-')"/>
          (<xsl:value-of select="$Author"/>)
        </xsl:if>
      </p>
  
      <ul><li>
        <!-- Link to the XHTML source -->
        <xsl:element name="a">
          <xsl:attribute name="href">
            <xsl:text>/source</xsl:text>
            <xsl:value-of select="/buildinfo/@filename"/>
            <xsl:text>.</xsl:text>
            <xsl:value-of select="/buildinfo/document/@language"/>
            <xsl:text>.xhtml</xsl:text>
          </xsl:attribute>
          <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'source'" /></xsl:call-template>
        </xsl:element>
      </li><li>
        <xsl:element name="a">
          <xsl:attribute name="href"><xsl:value-of select="$linkresource"/>/contribute/web/</xsl:attribute>
          <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'contribute-web'" /></xsl:call-template>
        </xsl:element>
      </li></ul>
  
      <p>
        <xsl:element name="a">
          <xsl:attribute name="href"><xsl:value-of select="$linkresource"/>/contribute/translators/</xsl:attribute>
          <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'translate'" /></xsl:call-template>
        </xsl:element>
        <!-- Insert the appropriate translation notice -->
        <xsl:if test="/buildinfo/document/@language!=/buildinfo/@original">
          <xsl:element name="br"></xsl:element>
          <xsl:choose>
            <xsl:when test="/buildinfo/document/translator">
              <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'translator1a'" /></xsl:call-template>
              <xsl:value-of select="/buildinfo/document/translator"/>
              <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'translator1b'" /></xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'translator2'" /></xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'translator3a'" /></xsl:call-template>
          <xsl:element name="a">
            <xsl:attribute name="href">
              <xsl:value-of select="/buildinfo/@filename"/>
              <xsl:text>.en.html</xsl:text>
            </xsl:attribute>
            <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'translator3b'" /></xsl:call-template>
          </xsl:element>
          <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'translator3c'" /></xsl:call-template>
        </xsl:if>
      </p>
  
    </xsl:element>
    <!--/section#source-->
  </xsl:template>

</xsl:stylesheet>
