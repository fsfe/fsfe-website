<?xml version="1.0" encoding="utf-8"?>

<!-- XSL stylesheet for generation RSS feeds.  It's currently using RSS 2.0. -->

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dt="http://xsltsl.org/date-time"
                xmlns:weekdays="."
                xmlns:months="."
                xmlns:content="http://purl.org/rss/1.0/modules/content/">

  <xsl:import href="date-time.xsl" />

  <xsl:output method="xml" encoding="utf-8" indent="yes"/>

  <!-- $today = current date (given as <html date="...">) -->
  <xsl:variable name="today">
    <xsl:value-of select="/html/@date" />
  </xsl:variable>

  <!-- ======== -->
  <!-- Weekdays --> 
  <!-- ======== -->

  <weekdays:weekday-names>
    <weekdays:day ref="0">Sun</weekdays:day> <!-- it seems that the module returns 0 for Sunday, on the "English" calendar model (Sundays first) -->
    <weekdays:day ref="1">Mon</weekdays:day>
    <weekdays:day ref="2">Tue</weekdays:day>
    <weekdays:day ref="3">Wed</weekdays:day>
    <weekdays:day ref="4">Thu</weekdays:day>
    <weekdays:day ref="5">Fri</weekdays:day>
    <weekdays:day ref="6">Sat</weekdays:day>
    <weekdays:day ref="7">Sun</weekdays:day>
  </weekdays:weekday-names>

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

    <!-- Add leading "http://www.fsfeurope.org" if necessary -->
    <xsl:variable name="full-link">
      <xsl:choose>
        <xsl:when test="starts-with ($link, 'http:')">
          <xsl:value-of select="$link" />
        </xsl:when>
        <xsl:when test="starts-with ($link, 'https:')">
          <xsl:value-of select="$link" />
        </xsl:when>
        <xsl:otherwise>http://fsfe.org<xsl:value-of select="$link" />
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
              
              <!-- guid -->
              <xsl:element name="guid">
                <xsl:attribute name="isPermaLink">false</xsl:attribute>
                <xsl:value-of select="@filename"/>
              </xsl:element>
              
              
              
              <!-- Title -->
              <xsl:element name="title">
                <xsl:value-of select="title"/>
              </xsl:element>

              <!-- News description -->
              <xsl:element name="description">
                <xsl:copy-of select="normalize-space(body)"/>
                <xsl:text>
Support FSFE, join the Fellowship: https://fellowship.fsfe.org/login/join.php
Make a one time donation: http://fsfe.org/donate/donate.html</xsl:text>
              </xsl:element>
              
              <!-- News body -->
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
                
                <xsl:element name="p">
                  
                  <xsl:text>Support FSFE, </xsl:text>
                  <xsl:element name="a">
                    <xsl:attribute name="href">https://fellowship.fsfe.org/login/join.php</xsl:attribute>
                    <xsl:text>join the Fellowship</xsl:text>
                  </xsl:element>
                  
                  <xsl:element name="br" />
                  
                  <xsl:text>Make a </xsl:text>
                  <xsl:element name="a">
                    <xsl:attribute name="href">http://fsfe.org/donate/donate.html</xsl:attribute>
                    <xsl:text>one time donation</xsl:text>
                  </xsl:element>
                  
                </xsl:element>
                
                <xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
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
                <xsl:variable name="day-of-week">
                  <xsl:call-template name="dt:calculate-day-of-the-week">
                    <xsl:with-param name="year" select="substring(@date, 0, 5)" />
                    <xsl:with-param name="month" select="substring(@date, 6, 2)" />
                    <xsl:with-param name="day" select="substring(@date, 9, 2)" />
                  </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="document('')/*/weekdays:weekday-names/weekdays:day[@ref=$day-of-week]" />
                <xsl:text>, </xsl:text>
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

            </xsl:element>
          </xsl:if>
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
            <xsl:text>http://fsfe.org</xsl:text>
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
  
  <!-- remove newsteaser from <p> -->
  <xsl:template match="p">
    <xsl:element name="p">
      
      <xsl:apply-templates select="node()" />
      
    </xsl:element>
  </xsl:template>
  
  <!-- as well as images -->
  <xsl:template match="img">
    <xsl:element name="img">
      <xsl:attribute name="src">
        <xsl:choose>
          <xsl:when test="substring(@src,1,1) = '/'">
            <xsl:text>http://fsfe.org</xsl:text>
            <xsl:value-of select="@src" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="@src" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>
  
  <!-- Do not copy <body-complete> to output at all -->
  <xsl:template match="body-complete"/>
  
  <!-- For all other nodes, copy verbatim -->
  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>
