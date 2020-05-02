<?xml version="1.0" encoding="UTF-8"?>

<!-- XSL stylesheet for generating podcast RSS feeds -->

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dt="http://xsltsl.org/date-time"
                xmlns:weekdays="."
                xmlns:months="."
                xmlns:content="http://purl.org/rss/1.0/modules/content/"
                xmlns:atom="http://www.w3.org/2005/Atom"
                xmlns:psc="http://podlove.org/simple-chapters"
                xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd">

  <xsl:import href="../build/xslt/gettext.xsl" />

  <xsl:output method="xml" encoding="utf-8" indent="yes"/>

  <!-- ====== -->
  <!-- Months -->
  <!-- ====== -->

  <months:month-names>
    <months:month ref="01">Jan</months:month>
    <months:month ref="02">Feb</months:month>
    <months:month ref="03">Mar</months:month>
    <months:month ref="04">Apr</months:month>
    <months:month ref="05">May</months:month>
    <months:month ref="06">Jun</months:month>
    <months:month ref="07">Jul</months:month>
    <months:month ref="08">Aug</months:month>
    <months:month ref="09">Sep</months:month>
    <months:month ref="10">Oct</months:month>
    <months:month ref="11">Nov</months:month>
    <months:month ref="12">Dec</months:month>
  </months:month-names>

  <!-- ============= -->
  <!-- Link handling -->
  <!-- ============= -->

  <xsl:template match="link">
    <xsl:param name="lang" />

    <!-- Original link text -->
    <xsl:variable name="link">
      <xsl:value-of select="normalize-space(.)" />
    </xsl:variable>

    <!-- Add leading "https://fsfe.org" if necessary -->
    <xsl:variable name="full-link">
      <xsl:choose>
        <xsl:when test="starts-with ($link, 'http:')">
          <xsl:value-of select="$link" />
        </xsl:when>
        <xsl:when test="starts-with ($link, 'https:')">
          <xsl:value-of select="$link" />
        </xsl:when>
        <xsl:otherwise>https://fsfe.org<xsl:value-of select="$link" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- Insert language into link -->
    <xsl:choose>
      <xsl:when test="starts-with ($full-link, 'https://fsfe.org/')
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

  <xsl:template match="/buildinfo">
    <xsl:apply-templates select="document" />
  </xsl:template>

  <xsl:template match="/buildinfo/document">

    <!-- param audioformat mp3 or opus (or none), set variable $format and $alternateformat -->
    <xsl:param name="audioformat" />
    <xsl:variable name="format">
      <xsl:choose>
        <!-- default format is mp3 -->
        <xsl:when test="$audioformat = ''">
          <xsl:text>mp3</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$audioformat" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="alternateformat">
      <xsl:choose>
        <xsl:when test="$format = 'mp3'">
          <xsl:text>opus</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>mp3</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- Language -->
    <xsl:variable name="lang">
      <xsl:value-of select="@language" />
    </xsl:variable>

    <!-- Header -->
    <rss version="2.0">
      <channel>
        <title>Software Freedom Podcast</title>
        <description>The regular podcast about Free Software and ongoing activities hosted by the FSFE</description>
        <link>https://fsfe.org/news/podcast</link>
        <language><xsl:value-of select="$lang" /></language>
        <copyright>Copyright (c) Free Software Foundation Europe. Creative Commons BY-SA 4.0</copyright>
        <managingEditor>press@fsfe.org (FSFE Press Team)</managingEditor>
        <webMaster>web@lists.fsfe.org (FSFE Webmaster Team)</webMaster>
        <image>
          <url>https://fsfe.org/graphics/podcast-logo.png</url>
          <title>Software Freedom Podcast</title>
          <width>88</width>
          <height>31</height>
          <link>https://fsfe.org/news/podcast</link>
        </image>

        <!-- self and alternate feeds (atom:link -->
        <xsl:element name="atom:link">
          <xsl:attribute name="href">
            <xsl:text>https://fsfe.org/news/podcast</xsl:text>
            <xsl:choose>
              <xsl:when test="$format != 'mp3'">
                <xsl:text>-</xsl:text>
                <xsl:value-of select="$format" />
              </xsl:when>
            </xsl:choose>
            <xsl:text>.</xsl:text>
            <xsl:value-of select="$lang"/>.rss</xsl:attribute>
          <xsl:attribute name="rel">self</xsl:attribute>
          <xsl:attribute name="type">application/rss+xml</xsl:attribute>
          <xsl:attribute name="title">Software Freedom Podcast (<xsl:value-of select="$format"/> Audio)</xsl:attribute>
        </xsl:element>
        <xsl:element name="atom:link">
          <xsl:attribute name="href">
            <xsl:text>https://fsfe.org/news/podcast</xsl:text>
            <xsl:choose>
              <xsl:when test="$alternateformat != 'mp3'">
                <xsl:text>-</xsl:text>
                <xsl:value-of select="$alternateformat" />
              </xsl:when>
            </xsl:choose>
            <xsl:text>.</xsl:text>
            <xsl:value-of select="$lang"/>.rss</xsl:attribute>
          <xsl:attribute name="rel">alternate</xsl:attribute>
          <xsl:attribute name="type">application/rss+xml</xsl:attribute>
          <xsl:attribute name="title">Software Freedom Podcast (<xsl:value-of select="$alternateformat"/> Audio)</xsl:attribute>
        </xsl:element>

        <!-- PODCAST specific information -->
        <lastBuildDate>
          <xsl:variable name="timestamp">
            <xsl:value-of select="/buildinfo/document/timestamp"/>
          </xsl:variable>
          <xsl:value-of select="substring-before(substring-after($timestamp, 'Date: '), ' $')"/>
        </lastBuildDate>
        <generator>FSFE website build system: podcast.rss.xsl</generator>
        <itunes:type>episodic</itunes:type>
        <itunes:owner>
          <itunes:name>Free Software Foundation Europe (FSFE)</itunes:name>
          <itunes:email>contact@fsfe.org</itunes:email>
        </itunes:owner>
        <itunes:author>Free Software Foundation Europe (FSFE)</itunes:author>
        <itunes:category text="Technology" />
        <itunes:category text="News">
          <itunes:category text="Tech News" />
        </itunes:category>
        <itunes:keywords>free software, open source, libre, foss, floss, oss, programming, policy, talk, interview, news, tech, technology, freedom, liberty, fsfe, fsf, foundation</itunes:keywords>
        <itunes:image href="https://fsfe.org/graphics/podcast-logo.png" />
        <itunes:summary>The regular podcast about Free Software and ongoing activities hosted by the FSFE</itunes:summary>
        <itunes:subtitle>The monthly podcast about Free Software</itunes:subtitle>
        <itunes:block>false</itunes:block>
        <itunes:explicit>false</itunes:explicit>


        <!-- Podcast episodes -->
        <xsl:for-each select="/buildinfo/document/set/news[
            translate(@date, '-', '') &lt;= translate(/buildinfo/@date, '-', '')
          ]">
          <xsl:sort select="@date" order="descending"/>
          <xsl:element name="item">

            <!-- Title -->
            <xsl:element name="title">
              <xsl:value-of select="title"/>
            </xsl:element>
            <xsl:element name="itunes:title">
              <xsl:value-of select="title"/>
            </xsl:element>

            <!-- Podcast description -->
            <xsl:element name="description">
              <xsl:copy-of select="normalize-space(body)"/>
              <xsl:text> Join the FSFE community and support the podcast: https://my.fsfe.org/support?referrer=podcast</xsl:text>
            </xsl:element>
            <xsl:element name="itunes:summary">
              <xsl:copy-of select="normalize-space(body)"/>
              <xsl:text> Join the FSFE community and support the podcast: https://my.fsfe.org/support?referrer=podcast</xsl:text>
            </xsl:element>

            <!-- Podcast body -->
            <xsl:element name="content:encoded">
              <xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
              <xsl:choose>
                <xsl:when test="body-complete">
                  <xsl:apply-templates select="body-complete/*"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:copy-of select="normalize-space(body)"/>
                </xsl:otherwise>
              </xsl:choose>

              <!-- Link to discussion topic on community.fsfe.org -->
              <xsl:if test = "discussion/@href">
                <xsl:element name="p">
                  <xsl:element name="a">
                    <xsl:attribute name="class">learn-more</xsl:attribute>
                    <xsl:attribute name="href">
                      <xsl:value-of select="discussion/@href" />
                    </xsl:attribute>
                    <xsl:call-template name="fsfe-gettext">
                      <xsl:with-param name="id" select="'discuss-article'" />
                    </xsl:call-template>
                    <xsl:text> </xsl:text>
                  </xsl:element>
                </xsl:element>
              </xsl:if>

              <xsl:element name="p">
                <xsl:element name="a">
                  <xsl:attribute name="href">https://my.fsfe.org/support?referrer=podcast</xsl:attribute>
                  <xsl:text>Join the FSFE community and support the podcast</xsl:text>
                </xsl:element>
              </xsl:element>

              <xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
            </xsl:element>

            <!-- Link and GUID -->
            <xsl:if test="link != ''">
              <xsl:variable name="link">
                <xsl:apply-templates select="link">
                  <xsl:with-param name="lang" select="$lang" />
                </xsl:apply-templates>
              </xsl:variable>
              <xsl:element name="link">
                <xsl:value-of select="normalize-space($link)" />
              </xsl:element>
              <!-- guid -->
              <xsl:element name="guid">
                <xsl:attribute name="isPermaLink">false</xsl:attribute>
                <xsl:value-of select="normalize-space($link)"/>
              </xsl:element>
            </xsl:if>

            <!-- Date -->
            <xsl:element name="pubDate">
              <xsl:value-of select="substring-after(substring-after(@date, '-'), '-')" />
              <xsl:variable name="month">
                <xsl:value-of select="substring-before(substring-after(@date, '-'), '-')" />
              </xsl:variable>
              <xsl:text> </xsl:text>
              <xsl:value-of select="document('')/*/months:month-names/months:month[@ref=$month]" />
              <xsl:text> </xsl:text>
              <xsl:value-of select="substring-before(@date, '-')" />
              <xsl:text> 00:00:00 +0100</xsl:text>
            </xsl:element>

            <!-- PODCAST specific information (item) -->
            <itunes:author>Free Software Foundation Europe (FSFE)</itunes:author>
            <itunes:explicit>false</itunes:explicit>
            <itunes:block>false</itunes:block>
            <itunes:episodeType>
              <xsl:choose>
                <xsl:when test="podcast/type != ''">
                  <xsl:value-of select="podcast/type" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>full</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </itunes:episodeType>

            <!-- Episode subtitle -->
            <xsl:element name="itunes:subtitle">
              <xsl:value-of select="podcast/subtitle"/>
            </xsl:element>

            <!-- Duration -->
            <xsl:element name="itunes:duration">
              <xsl:value-of select="podcast/duration"/>
            </xsl:element>

            <!-- Episode number -->
            <xsl:if test="podcast/episode != ''">
              <xsl:element name="itunes:episode">
                <xsl:value-of select="podcast/episode"/>
              </xsl:element>
            </xsl:if>

            <!-- Enclosure (audio file path) -->
            <xsl:element name="enclosure">
              <xsl:attribute name="url">
                <xsl:value-of select="podcast/*[name()=$format]/url"/>
              </xsl:attribute>
              <xsl:attribute name="length">
                <xsl:value-of select="podcast/*[name()=$format]/length"/>
              </xsl:attribute>
              <xsl:attribute name="type">
                <xsl:text>audio/</xsl:text>
                <xsl:value-of select="$format" />
              </xsl:attribute>
            </xsl:element>

            <!-- Chapters -->
            <xsl:element name="psc:chapters">
              <xsl:for-each select="podcast/chapters/chapter">
                <xsl:element name="psc:chapter">
                  <xsl:attribute name="start"><xsl:value-of select="@start" /></xsl:attribute>
                  <xsl:attribute name="title"><xsl:value-of select="." /></xsl:attribute>
                </xsl:element>
              </xsl:for-each>
            </xsl:element>

          </xsl:element>
        </xsl:for-each>

        <!-- Footer -->
      </channel>
    </rss>
  </xsl:template>

  <!-- take care that links within <content:encoded> are not relative -->
  <xsl:template match="a">
    <xsl:element name="a">
      <xsl:attribute name="href">
        <xsl:choose>
          <xsl:when test="substring(@href,1,1) = '/'">
            <xsl:text>https://fsfe.org</xsl:text>
            <xsl:value-of select="@href" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="@href" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:value-of select="." />
    </xsl:element>
  </xsl:template>

  <!-- as well as images -->
  <xsl:template match="img">
    <xsl:element name="img">
      <xsl:attribute name="src">
        <xsl:choose>
          <xsl:when test="substring(@src,1,1) = '/'">
            <xsl:text>https://fsfe.org</xsl:text>
            <xsl:value-of select="@src" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="@src" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>

  <!-- Allow basic styling elements, copy them without attributes -->
  <xsl:template match="p|strong|em|ul|ol|li|h1|h2|h3|h4|h5|h6">
    <xsl:copy>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- Do not copy <body-complete> to output at all -->
  <xsl:template match="body-complete"/>

</xsl:stylesheet>
