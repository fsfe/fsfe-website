<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="feeds.xsl" />

  <!--display dynamic list of tagged news items-->

  <xsl:template name="fetch-news">
    <xsl:param name="nb-items" select="''" />
    <xsl:param name="sidebar" select="'no'" />

    <xsl:for-each select="/buildinfo/document/set/news[
        translate(@date, '-', '') &lt;= translate(/buildinfo/@date, '-', '')
      ]">
      <xsl:sort select="@date" order="descending" />

      <xsl:if test="$nb-items = '' or position() &lt;= $nb-items">
        <xsl:call-template name="news">
          <xsl:with-param name="sidebar" select="$sidebar" />
        </xsl:call-template>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!--display dynamic list of tagged event items-->

  <xsl:template name="fetch-events">
    <xsl:param name="nb-items" select="''" />

    <xsl:for-each select="/buildinfo/document/set/event[
        translate (@end, '-', '') &gt;= translate (/buildinfo/@date, '-', '')
      ]">
      <xsl:sort select="@start"/>

      <xsl:if test="position() &lt;= $nb-items or $nb-items=''">
        <xsl:call-template name="event"/>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
