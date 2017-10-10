<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dt="http://xsltsl.org/date-time">
  <xsl:import href="feeds.xsl" />
  <xsl:import href="events-utils.xsl" />

  <xsl:output method="xml" encoding="UTF-8" indent="yes" />

  <!--display dynamic list of tagged news items-->

  <xsl:template name="fetch-news">
    <xsl:param name="tag" select="''"/>
    <xsl:param name="today" select="/buildinfo/@date" />
    <xsl:param name="nb-items" select="''" />
    <xsl:param name="display-year" select="'yes'" />
    <xsl:param name="show-date" select="'yes'" />
    <xsl:param name="compact-view" select="'no'" />

    <xsl:for-each select="/buildinfo/document/set/news[
      translate(@date, '-', '') &lt;= translate($today, '-', '')
      and ($tag = '' or tags/tag[@key] = $tag or tags/tag = $tag)
      and not(tags/tag = 'newsletter' or tags/tag[@key] = 'newsletter')
      and not( @type = 'newsletter' ) ]"> <!-- Legacy -->
      <xsl:sort select="@date" order="descending" />

      <xsl:if test="$nb-items = '' or position() &lt;= $nb-items">
        <xsl:call-template name="news">
          <xsl:with-param name="show-date" select="$show-date" />
          <xsl:with-param name="compact-view" select="$compact-view" />
          <xsl:with-param name="display-year" select="$display-year" />
        </xsl:call-template>
      </xsl:if>
    </xsl:for-each>

  </xsl:template>

  <!--display dynamic list of (not yet tagged) newsletters items-->

  <xsl:template name="fetch-newsletters">
    <xsl:param name="today" select="/buildinfo/@date" />
    <xsl:param name="nb-items" select="''" />

    <xsl:for-each select="/buildinfo/document/set/news[
      translate(@date, '-', '') &lt;= translate($today, '-', '')
      and (tags/tag[@key] = 'newsletter' or tags/tag = 'newsletter'
      or @type = 'newsletter' ) ]">
      <xsl:sort select="@date" order="descending" />

      <xsl:if test="$nb-items = '' or position() &lt;= $nb-items">
        <xsl:call-template name="newsletter" />
      </xsl:if>
    </xsl:for-each>

  </xsl:template>


  <!--display dynamic list of tagged event items-->

  <xsl:template name="fetch-events">
    <xsl:param name="tag" select="''"/>
    <xsl:param name="today" select="/buildinfo/@date" />
    <xsl:param name="wanted-time" select="future" /> <!-- value in {"past", "present", "future"} -->
    <xsl:param name="header" select="''" />
    <xsl:param name="nb-items" select="''" />
    <xsl:param name="display-details" select="'no'" />
    <xsl:param name="display-year" select="'yes'" />

    <xsl:choose> <xsl:when test="$wanted-time = 'past'">
      <!-- Past events -->
      <xsl:for-each select="/buildinfo/document/set/event
        [translate (@end, '-', '') &lt; translate ($today, '-', '')
         and (tags/tag = $tag or $tag='')
        ]">
        <xsl:sort select="@end" order="descending" />
        <xsl:if test="position() &lt;= $nb-items or $nb-items=''">
          <xsl:call-template name="event">
            <xsl:with-param name="header" select="$header" />
            <xsl:with-param name="display-details" select="$display-details" />
            <xsl:with-param name="display-year" select="$display-year" />
          </xsl:call-template>
        </xsl:if>
      </xsl:for-each>

    </xsl:when> <xsl:when test="$wanted-time = 'present'">
      <!-- Current events -->
      <xsl:for-each select="/buildinfo/document/set/event
        [translate (@start, '-', '') &lt;= translate ($today, '-', '')
         and translate (@end,   '-', '') &gt;= translate ($today, '-', '')
         and (tags/tag = $tag or $tag='')
        ]">
        <xsl:sort select="@start" order="descending" />
        <xsl:if test="position() &lt;= $nb-items or $nb-items=''">
          <xsl:call-template name="event">
            <xsl:with-param name="header" select="$header" />
            <xsl:with-param name="display-details" select="$display-details" />
            <xsl:with-param name="display-year" select="$display-year" />
          </xsl:call-template>
        </xsl:if>
      </xsl:for-each>

    </xsl:when> <xsl:otherwise> <!-- if we were not told what to do, display future events -->
      <!-- Future events -->
      <xsl:for-each select="/buildinfo/document/set/event
        [translate (@start, '-', '') &gt; translate ($today, '-', '')
         and (tags/tag = $tag or $tag='')
        ]">
        <xsl:sort select="@start" />
        <xsl:if test="position() &lt;= $nb-items or $nb-items=''">
          <xsl:call-template name="event">
            <xsl:with-param name="header" select="$header" />
            <xsl:with-param name="display-details" select="$display-details" />
            <xsl:with-param name="display-year" select="$display-year" />
          </xsl:call-template>
        </xsl:if>
      </xsl:for-each>

    </xsl:otherwise> </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
