<?xml version="1.0" encoding="UTF-8"?>

<!-- XSL stylesheet for generating RSS feeds. We use RSS 0.91 for now -->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

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
  <!-- Date Convertion -->
  <!-- =============== -->

  <!--
    Converts 2009-01-28 to Wed, 28 Jan 2009 00:00:00 +0100
    (RFC822), required by RSS 2.0.
  -->

  <xsl:template name="rfc822date">
    <xsl:param name="date" />
    <xsl:value-of select="date:day-abbreviation($date)" />, <xsl:value-of select="date:day-in-month($date)"/><xsl:text> </xsl:text>
    <xsl:value-of select="date:month-abbreviation($date)" /><xsl:text> </xsl:text>
    <xsl:value-of select="date:year($date)" /><xsl:text> </xsl:text> 
    <!--<xsl:value-of select="date:hour-in-day($date)" />:<xsl:value-of select="date:minute-in-hour($date)"/>:<xsl:value-of select="date:second-in-minute($date)"/> +0100-->
    00:00:00 +0100
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
                <xsl:text>&lt;![CDATA[</xsl:text>
                <xsl:value-of select="normalize-space(body)"/>
                <xsl:text>]]&gt;</xsl:text>
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
                <xsl:apply-templates select="rfc822date">
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
