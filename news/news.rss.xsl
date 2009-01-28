<?xml version="1.0" encoding="UTF-8"?>

<!-- XSL stylesheet for generation RSS feeds.  It's currently using RSS 2.0. -->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" encoding="UTF-8" indent="yes" />

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

  <!-- =============== -->
  <!-- Date conversion -->
  <!-- =============== -->

  <xsl:template match="date">
    <xsl:param name="date" />
    <xsl:analyze-string select="$date" regex="(\d{{4}})-(\d{{2}})-(\d{{2}})T([\d:]*)Z">
      <xsl:matching-substring>
        <xsl:value-of select="regex-group(3)" />
        <xsl:text> </xsl:text>
        <xsl:variable name="month" select="number(regex-group(2))" />
        <xsl:choose>
          <xsl:when test="$month=1">Jan</xsl:when>
          <xsl:when test="$month=2">Feb</xsl:when>
          <xsl:when test="$month=3">Mar</xsl:when>
          <xsl:when test="$month=4">Apr</xsl:when>
          <xsl:when test="$month=5">May</xsl:when>
          <xsl:when test="$month=6">Jun</xsl:when>
          <xsl:when test="$month=7">Jul</xsl:when>
          <xsl:when test="$month=8">Sug</xsl:when>
          <xsl:when test="$month=9">Sep</xsl:when>
          <xsl:when test="$month=10">Oct</xsl:when>
          <xsl:when test="$month=11">Nov</xsl:when>
          <xsl:when test="$month=12">Dec</xsl:when>
        </xsl:choose>
        <xsl:value-of select="concat(' ', regex-group(1), ' ', regex-group(4), ' CET')" />
      </xsl:matching-substring>
    </xsl:analyze-string>
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
                <xsl:text><![CDATA[</xsl:text>
                <xsl:value-of select="normalize-space(body)"/>
                <xsl:text>]]></xsl:text>
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
                <xsl:apply-templates select="date">
                  <xsl:with-param name="date" select="@date" />
                </xsl:apply-templates>
              </xsl:element>

            </xsl:element>
          </xsl:if>
        </xsl:for-each>

        <!-- Footer -->
      </channel>
    </rss>
  </xsl:template>
</xsl:stylesheet>
