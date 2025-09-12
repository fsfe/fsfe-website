<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="../fsfe.xsl"/>
  <xsl:import href="../../global/xslt/internal/static-elements.xsl"/>
  <xsl:template match="/buildinfo/document/body/include-newsletter">
    <xsl:apply-templates/>
    <xsl:for-each select="/buildinfo/document/set/news[         translate(@date, '-', '') &lt;= translate(/buildinfo/@date, '-', '')       ]">
      <xsl:sort select="@date" order="descending"/>
      <p>
        <b>
          <xsl:value-of select="@date"/>
        </b>
        <br/>
        <xsl:value-of select="body"/>
        <xsl:variable name="link">
          <xsl:value-of select="link"/>
        </xsl:variable>
        <xsl:if test="$link!=''">
           <a href="{link}" class="learn-more"><xsl:value-of select="/buildinfo/document/text[@id='more']"/></a>
        </xsl:if>
      </p>
    </xsl:for-each>
  </xsl:template>
  <!--translated sentence "receive-newsletter"-->
  <xsl:template match="receive-newsletter">
    <xsl:call-template name="gettext">
      <xsl:with-param name="id" select="'receive-newsletter'"/>
    </xsl:call-template>
  </xsl:template>
</xsl:stylesheet>
