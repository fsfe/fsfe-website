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

  <!-- ================== -->
  <!-- Weekday conversion -->
  <!-- ================== -->
  <xsl:template match="weekday">
    <xsl:param name="timestamp" />

    <xsl:variable name="weekdays">
      <d>Sun</d>
      <d>Mon</d>
      <d>Tue</d>
      <d>Wed</d>
      <d>Thu</d>
      <d>Fri</d>
      <d>Sat</d>
    </xsl:variable>

    <xsl:variable name="day-of-week">
      <xsl:call-template name="dt:calculate-day-of-the-week">
        <xsl:with-param name="year" select="substring(timestamp, 0, 4)" />
        <xsl:with-param name="month" select="substring(timestamp, 6, 2)" />
        <xsl:with-param name="day" select="substring(timestamp, 9, 2)" />
      </xsl:call-template>
    </xsl:variable>

    <xsl:value-of select="document('')/*/$weekdays/d[number($day-of-week)]" />

  </xsl:template>

  <!-- ================ -->
  <!-- Month conversion -->
  <!-- ================ -->
  <xsl:template match="month">
    <xsl:param name="timestamp" />

    <xsl:variable name="months">
      <m>Jan</m>
      <m>Feb</m>
      <m>Mar</m>
      <m>Apr</m>
      <m>May</m>
      <m>Jun</m>
      <m>Jul</m>
      <m>Aug</m>
      <m>Sep</m>
      <m>Oct</m>
      <m>Nov</m>
      <m>Dec</m>
    </xsl:variable>

    <xsl:variable name="month">
      <xsl:value-of select="substr(date, 6, 2)" />
    </xsl:variable>

    <xsl:value-of select="document('')/*/$months/m[number($month)]" />

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
                <xsl:apply-templates select="weekday"><xsl:with-param name="timestamp" select="@date" /></xsl:apply-templates>, 
                <xsl:value-of select="substring(@date, 6, 2)" /> 
                <xsl:apply-templates select="month"><xsl:with-param name="timestamp" select="@date" /></xsl:apply-templates> 
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
