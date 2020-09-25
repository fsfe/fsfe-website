<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:str="http://exslt.org/strings"
  extension-element-prefixes="str">

  <xsl:output method="text" encoding="UTF-8" indent="no" />
  <xsl:strip-space elements="body"/>

  <!-- new line template -->
  <xsl:template name="nl"><xsl:text>&#13;&#10;</xsl:text></xsl:template>

  <!-- Show a single event -->
  <xsl:template name="event">

    <!-- Create variables -->
    <xsl:variable name="start">
      <xsl:value-of select="translate (@start, '-', '')" />
    </xsl:variable>

    <xsl:variable name="end">
      <xsl:value-of select="translate (@end, '-', '')" />
    </xsl:variable>

    <xsl:variable name="link">
      <xsl:value-of select="link" />
    </xsl:variable>

    <xsl:variable name="page">
      <xsl:value-of select="page" />
    </xsl:variable>

    <!-- Now, the event block -->
    <xsl:text>BEGIN:VEVENT</xsl:text><xsl:call-template name="nl" />

    <xsl:text>SUMMARY:</xsl:text>
    <xsl:call-template name="ical-escape">
      <xsl:with-param name="text" select="title" />
    </xsl:call-template>
    <xsl:call-template name="nl" />

    <xsl:text>DTSTART;VALUE=DATE:</xsl:text><xsl:value-of select="$start" /><xsl:call-template name="nl" />
    <xsl:if test="not($start = $end)">
      <xsl:text>DTEND;VALUE=DATE:</xsl:text><xsl:value-of select="$end" /><xsl:call-template name="nl" />
    </xsl:if>

    <xsl:text>URL:</xsl:text>
    <xsl:choose>
      <xsl:when test="$page != ''"><xsl:value-of select="$page" /></xsl:when>
      <xsl:otherwise>https://fsfe.org/events/events.<xsl:value-of select="/buildinfo/@language" />.html</xsl:otherwise>
    </xsl:choose>
    <xsl:call-template name="nl" />

    <xsl:text>DESCRIPTION:</xsl:text>
    <xsl:call-template name="ical-escape">
      <xsl:with-param name="text" select="normalize-space(body/node())" />
    </xsl:call-template>
    <xsl:call-template name="nl" />

    <xsl:text>END:VEVENT</xsl:text><xsl:call-template name="nl" />

  </xsl:template>

  <xsl:template match="/">
    <xsl:apply-templates select="/buildinfo/document" />
  </xsl:template>

  <xsl:template match="/buildinfo/document">
    <xsl:text>BEGIN:VCALENDAR</xsl:text><xsl:call-template name="nl" />
    <xsl:text>VERSION:2.0</xsl:text><xsl:call-template name="nl" />
    <xsl:text>PRODID:fsfe.org/events/events.ics.xsl</xsl:text><xsl:call-template name="nl" />
      <!-- Future events -->
      <xsl:for-each select="/buildinfo/document/set/event[
          translate(@start, '-', '') &gt;= translate(/buildinfo/@date, '-', '')
        ]">
        <xsl:sort select="@start" order="descending" />
        <xsl:call-template name="event"/>
      </xsl:for-each>
    <xsl:text>END:VCALENDAR</xsl:text>
  </xsl:template>


  <xsl:template name="ical-escape">
    <xsl:param name="text" />

    <!-- characters to be backslashed: \;, -->
    <xsl:value-of select="str:replace(str:replace(str:replace($text,'\','\\'),',','\,'),';','\;')" />
  </xsl:template>

</xsl:stylesheet>

