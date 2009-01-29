<?xml version="1.0" encoding="utf-8"?>

<!-- XSL stylesheet for generation RSS feeds.  It's currently using RSS 2.0. -->

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dt="http://xsltsl.org/date-time">

  <xsl:import href="date-time.xsl" />

  <xsl:output method="xml" encoding="utf-8" indent="yes" />

  <!-- $today = current date (given as <html date="...">) -->
  <xsl:variable name="today">
    <xsl:value-of select="/html/@date" />
  </xsl:variable>

  <!-- ============= -->
  <!-- Link handling -->
  <!-- ============= -->

  <xsl:template match="link">
    <xsl:param name="lang" />

    <!-- Original link text -->
    <xsl:variable name="link">
      <xsl:value-of select="normalize-space(.)" />
    </xsl:variable>

    <!-- Add leading "http://www.fsfeurope.org" if necessary -->
    <xsl:variable name="full-link">
      <xsl:choose>
        <xsl:when test="starts-with ($link, 'http:')">
          <xsl:value-of select="$link" />
        </xsl:when>
        <xsl:when test="starts-with ($link, 'https:')">
          <xsl:value-of select="$link" />
        </xsl:when>
        <xsl:otherwise>http://www.fsfeurope.org<xsl:value-of select="$link" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- Insert language into link -->
    <xsl:choose>
      <xsl:when test="starts-with ($full-link, 'http://www.fsfeurope.org/')
                      and substring-before ($full-link, '.html') != ''">
        <xsl:value-of select="concat (substring-before ($full-link, '.html'),
                                      '.', $lang, '.html')" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$full-link" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- ============ -->
  <!-- Main routine -->
  <!-- ============ -->

  <xsl:template match="html">

    <!-- Language -->
    <xsl:variable name="lang">
      <xsl:value-of select="@lang" />
    </xsl:variable>

    <!-- Header -->
    <rss version="2.0">
      <channel>
        <title>FSFE News</title>
        <description>News from the Free Software Foundation Europe</description>
        <link>http://www.fsfeurope.org/news/</link>
        <language><xsl:value-of select="$lang" /></language>
        <copyright>Copyright (c) FSF Europe. Verbatim copying and distribution
          of this entire article is permitted in any medium, provided this
          notice is preserved.</copyright>
        <managingEditor>press@fsfeurope.org (FSFE Press Team)</managingEditor>
        <webMaster>web@fsfeurope.org (FSFE Webmaster Team)</webMaster>
        <image>
          <url>http://fsfeurope.org/news/fsfe-news.png</url>
          <title>FSFE News</title>
          <width>88</width>
          <height>31</height>
          <link>http://www.fsfeurope.org/news/</link>
        </image>

        <!-- News items -->
        <xsl:for-each select="/html/set/news
          [translate (@date, '-', '') &lt;= translate ($today, '-', '')]">
          <xsl:sort select="@date" order="descending"/>
          <xsl:if test="position() &lt; 11">
            <xsl:element name="item">

              <!-- Title -->
              <xsl:element name="title">
                <xsl:value-of select="title"/>
                <xsl:text> (</xsl:text>
                <xsl:value-of select="@date"/>
                <xsl:text>)</xsl:text>
              </xsl:element>

              <!-- News body -->
              <xsl:element name="description">
                <xsl:value-of select="normalize-space(body)"/>
              </xsl:element>

              <!-- Link -->
              <xsl:if test="link != ''">
                <xsl:variable name="link">
                  <xsl:apply-templates select="link">
                    <xsl:with-param name="lang" select="$lang" />
                  </xsl:apply-templates>
                </xsl:variable>
                <xsl:element name="link">
                  <xsl:value-of select="normalize-space($link)" />
                </xsl:element>
              </xsl:if>

              <!-- Date -->
              <xsl:element name="pubDate">
                <xsl:variable name="weekdays">
                  <i ref="0">Sun</i>
                  <i ref="1">Mon</i>
                  <i ref="2">Tue</i>
                  <i ref="3">Wed</i>
                  <i ref="4">Thu</i>
                  <i ref="5">Fri</i>
                  <i ref="6">Sat</i>
                </xsl:variable>
                <xsl:variable name="day-of-week">
                  <xsl:call-template name="dt:calculate-day-of-the-week">
                    <xsl:with-param name="year" select="substring(@date, 0, 5)" />
                    <xsl:with-param name="month" select="substring(@date, 6, 2)" />
                    <xsl:with-param name="day" select="substring(@date, 9, 2)" />
                  </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="$weekdays[@ref=$day-of-week]" />, 
                <xsl:value-of select="substring(@date, 6, 2)" /> 
                <xsl:variable name="months">
                  <i ref="01">Jan</i>
                  <i ref="02">Feb</i>
                  <i ref="03">Mar</i>
                  <i ref="04">Apr</i>
                  <i ref="05">May</i>
                  <i ref="06">Jun</i>
                  <i ref="07">Jul</i>
                  <i ref="08">Aug</i>
                  <i ref="09">Sep</i>
                  <i ref="10">Oct</i>
                  <i ref="11">Nov</i>
                  <i ref="12">Dec</i>
                </xsl:variable>
                <xsl:variable name="month">
                  <xsl:value-of select="substr(@date, 6, 2)" />
                </xsl:variable>
                <xsl:value-of select="$months[@ref=$month]" /> 
                <xsl:value-of select="substr($@date, 0, 5)" />
                <xsl:text>00:00:00 +0100</xsl:text>
              </xsl:element>

            </xsl:element>
          </xsl:if>
        </xsl:for-each>

        <!-- Footer -->
      </channel>
    </rss>
  </xsl:template>
</xsl:stylesheet>
