<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dt="http://xsltsl.org/date-time"
  exclude-result-prefixes="dt">
 
  <xsl:import href="../../fsfe.xsl" />
  <xsl:output method="html" encoding="utf-8" indent="yes" doctype-system="about:legacy-compat" />

  <!-- Podcast audio player for both MP3 and OPUS -->
  <xsl:template match="audio-player">
    <xsl:element name="audio">
      <xsl:attribute name="controls" />
      <xsl:attribute name="style">width:100%;</xsl:attribute>
      <!-- OPUS -->
      <xsl:element name="source">
        <xsl:attribute name="src">
          <xsl:value-of select="/buildinfo/document/podcast/opus/url" />
        </xsl:attribute>
        <xsl:attribute name="type">audio/ogg;codecs=opus</xsl:attribute>
      </xsl:element>
      <!-- MP3 -->
      <xsl:element name="source">
        <xsl:attribute name="src">
          <xsl:value-of select="/buildinfo/document/podcast/mp3/url" />
        </xsl:attribute>
        <xsl:attribute name="type">audio/mp3</xsl:attribute>
      </xsl:element>
      <xsl:text>Your browser dows not support the audio element.</xsl:text>
    </xsl:element>

    <!-- Subscribe feed / Download file row -->
    <xsl:element name="div">
      <xsl:attribute name="class">podcast-interact clearfix</xsl:attribute>
      <!-- feed -->
      <xsl:element name="span">
        <xsl:attribute name="class">share-buttons-inline pull-left</xsl:attribute>
        <!-- TODO: language-variable links -->
        <xsl:element name="a">
          <xsl:attribute name="href">feed://fsfe.org/news/podcast-opus.en.rss</xsl:attribute>
          <xsl:element name="button">
            <xsl:attribute name="class">share-button-sidebar share-podcast</xsl:attribute>
            <xsl:text>OPUS Feed</xsl:text>
          </xsl:element>
        </xsl:element>
        <xsl:element name="a">
          <xsl:attribute name="href">feed://fsfe.org/news/podcast.en.rss</xsl:attribute>
          <xsl:element name="button">
            <xsl:attribute name="class">share-button-sidebar share-podcast</xsl:attribute>
            <xsl:text>MP3 Feed</xsl:text>
          </xsl:element>
        </xsl:element>
      </xsl:element>
      <!-- download -->
      <xsl:element name="span">
        <xsl:attribute name="class">pull-right</xsl:attribute>
        <xsl:element name="em">
          <xsl:call-template name="gettext">
            <xsl:with-param name="id" select="'download'" />
          </xsl:call-template>
        </xsl:element>
        <xsl:text>: </xsl:text>
        <xsl:element name="a">
          <xsl:attribute name="href">
            <xsl:value-of select="/buildinfo/document/podcast/opus/url" />
          </xsl:attribute>
          OPUS
        </xsl:element>
        <xsl:text> | </xsl:text>
        <xsl:element name="a">
          <xsl:attribute name="href">
            <xsl:value-of select="/buildinfo/document/podcast/mp3/url" />
          </xsl:attribute>
          MP3
        </xsl:element>
      </xsl:element>
    </xsl:element>

  </xsl:template>
  
</xsl:stylesheet> 
