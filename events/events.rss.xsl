<?xml version="1.0" encoding="ISO-8859-1"?>

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
    <xsl:variable name="link">
      <xsl:value-of select="normalize-space(.)" />
    </xsl:variable>

    <!-- Add leading "http://www.fsfeurope.org" if necessary -->
    <xsl:variable name="full-link">
      <xsl:choose>
        <xsl:when test="starts-with ($link, 'http:')">
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
    <rss version="0.91">
      <channel>
        <title>FSFE Events</title>
        <description>Free Software Events</description>
        <link>http://www.fsfeurope.org/</link>
        <language><xsl:value-of select="$lang" /></language>
        <copyright>Copyright (c) FSF Europe. Verbatim copying and distribution
          of this entire article is permitted in any medium, provided this
          notice is preserved.</copyright>
        <managingEditor>press@fsfeurope.org</managingEditor>
        <webMaster>web@fsfeurope.org</webMaster>
        <image>
          <url>http://fsfeurope.org/news/fsfe-events.png</url>
          <title>FSFE Events</title>
          <width>180</width>
          <height>47</height>
          <link>http://fsfeurope.org/events/</link>
        </image>

        <!-- News items -->
        <xsl:for-each select="/html/set/event
          [translate (@end, '-', '') &gt; translate ($today, '-', '')]">
          <xsl:sort select="@start" />
          <xsl:if test="position() &lt; 6">
            <xsl:variable name="start"><xsl:value-of select="@start" /></xsl:variable>
            <xsl:variable name="end"><xsl:value-of select="@end" /></xsl:variable>
            <item>

              <!-- Title -->
              <title>
                <xsl:value-of select="title" />
                (<xsl:value-of select="@start" /><xsl:if test="$start != $end"> - <xsl:value-of select="@end" /></xsl:if>)
              </title>

              <!-- News body -->
              <description>
                <xsl:value-of select="body" />
              </description>

              <!-- Link -->
              <xsl:if test="link != ''">
                <xsl:variable name="link">
                  <xsl:apply-templates select="link">
                    <xsl:with-param name="lang" select="$lang" />
                  </xsl:apply-templates>
                </xsl:variable>
                <link><xsl:value-of select="normalize-space($link)" /></link>
              </xsl:if>

            </item>
          </xsl:if>
        </xsl:for-each>

        <!-- Footer -->
      </channel>
    </rss>
  </xsl:template>
</xsl:stylesheet>
