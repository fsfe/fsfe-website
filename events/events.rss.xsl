<?xml version="1.0" encoding="UTF-8"?>

<!-- XSL stylesheet for generating RSS feeds. We use RSS 0.91 for now -->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes"
    indent="yes" />

  <!-- ============= -->
  <!-- Link handling -->
  <!-- ============= -->

  <xsl:template match="link">
    <xsl:param name="lang" />

    <!-- Original link text -->
    <!-- We remove leading "http://fsfe.org" by default -->
    <xsl:variable name="link">
      <xsl:choose>
        <xsl:when test="starts-with (normalize-space(.), 'http://fsfe.org')">
          <xsl:value-of select="substring-after(normalize-space(.), 'http://fsfe.org')" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="normalize-space(.)" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- Add leading "http://fsfe.org" if necessary -->
    <xsl:variable name="full-link">
      <xsl:choose>
        <xsl:when test="starts-with ($link, 'http:')">
          <xsl:value-of select="$link" />
        </xsl:when>
        <xsl:when test="starts-with ($link, 'https:')">
          <xsl:value-of select="$link" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>http://fsfe.org</xsl:text>
          <xsl:value-of select="$link" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- Insert language into link -->
    <xsl:choose>
      <xsl:when test="starts-with ($full-link, 'http://fsfe.org/')
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

    <!-- Language -->
    <xsl:variable name="lang">
      <xsl:value-of select="@language" />
    </xsl:variable>

    <!-- Header -->
    <rss version="0.91">
      <channel>
        <title>FSFE Events</title>
        <description>Free Software Events</description>
        <link>http://fsfe.org/events/</link>
        <language><xsl:value-of select="$lang" /></language>
        <copyright>Copyright (c) Free Software Foundation Europe. Verbatim copying and distribution
          of this entire article is permitted in any medium, provided this
          notice is preserved.</copyright>
        <managingEditor>press@fsfe.org (FSFE Press Team)</managingEditor>
        <webMaster>web@lists.fsfe.org (FSFE Webmaster Team)</webMaster>
        <image>
          <url>http://fsfe.org/events/fsfe-events.png</url>
          <title>FSFE Events</title>
          <width>88</width>
          <height>31</height>
          <link>http://fsfe.org/events/</link>
        </image>

        <!-- Event items -->
        <xsl:for-each select="/buildinfo/document/set/event[
            translate(@end, '-', '') &gt;= translate(/buildinfo/@date, '-', '')
          ]">
          <xsl:sort select="@start" />
          <xsl:if test="position() &lt; 11">
            <xsl:variable name="start"><xsl:value-of select="@start" /></xsl:variable>
            <xsl:variable name="end"><xsl:value-of select="@end" /></xsl:variable>
            <item>

              <!-- <guid> (is also a permalink to the event page, with anchor -->
              <xsl:element name="guid">
                <xsl:text>http://fsfe.org/events/events.html#</xsl:text>
                <xsl:value-of select="@filename"/>
              </xsl:element>

              <!-- Title -->
              <xsl:element name="title">
                <xsl:value-of select="title"/>
                <xsl:text> (</xsl:text>
                <xsl:value-of select="@start"/>
                <xsl:if test="$start != $end">
                  <xsl:text> - </xsl:text>
                  <xsl:value-of select="@end"/>
                </xsl:if>
                <xsl:text>)</xsl:text>
              </xsl:element>

              <!-- News body -->
              <xsl:element name="description">
                <xsl:value-of select="normalize-space(body)"/>
              </xsl:element>

              <!-- Link -->
              <xsl:element name="link">
                <xsl:choose>

                  <!-- link is already given → normalise it -->
                  <xsl:when test="link != ''">

                    <xsl:variable name="link">
                      <xsl:apply-templates select="link">
                        <xsl:with-param name="lang" select="$lang"/>
                      </xsl:apply-templates>
                    </xsl:variable>

                    <xsl:value-of select="normalize-space($link)"/>

                  </xsl:when>

                  <!-- link is not present, link to events.html#… -->
                  <xsl:otherwise>
                    <xsl:text>http://fsfe.org</xsl:text>
                    <xsl:text>/events/events.</xsl:text>
                    <xsl:value-of select="$lang" />
                    <xsl:text>.html#</xsl:text>
                    <xsl:value-of select="@filename" />
                  </xsl:otherwise>

                </xsl:choose>

              </xsl:element>

            </item>
          </xsl:if>
        </xsl:for-each>

        <!-- Footer -->
      </channel>
    </rss>
  </xsl:template>
</xsl:stylesheet>
