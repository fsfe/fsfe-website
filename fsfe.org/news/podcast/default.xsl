<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="../../fsfe.xsl"/>
  <!-- Podcast audio player for both MP3 and OPUS -->
  <xsl:template match="audio-player">
    <xsl:element name="audio">
      <xsl:attribute name="controls"/>
      <xsl:attribute name="preload">none</xsl:attribute>
      <xsl:attribute name="style">width:100%;</xsl:attribute>
      <!-- OPUS -->
      <xsl:element name="source">
        <xsl:attribute name="src">
          <xsl:value-of select="/buildinfo/document/podcast/opus/url"/>
          <xsl:text>?ref=player</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="type">audio/ogg;codecs=opus</xsl:attribute>
      </xsl:element>
      <!-- MP3 -->
      <xsl:element name="source">
        <xsl:attribute name="src">
          <xsl:value-of select="/buildinfo/document/podcast/mp3/url"/>
          <xsl:text>?ref=player</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="type">audio/mp3</xsl:attribute>
      </xsl:element>
      <xsl:text>Your browser dows not support the audio element.</xsl:text>
    </xsl:element>
    <!-- Subscribe feed / Download file row -->
    <xsl:element name="div">
      <xsl:attribute name="class">podcast-interact inline-buttons clearfix</xsl:attribute>
      <!-- feed -->
      <xsl:element name="span">
        <xsl:attribute name="class">share-buttons</xsl:attribute>
        <!-- TODO: language-variable links -->
        <xsl:element name="a">
          <xsl:attribute name="href">feed://fsfe.org/news/podcast-opus.en.rss</xsl:attribute>
          <xsl:attribute name="class">button share-rss</xsl:attribute>
          <xsl:text>OPUS Feed</xsl:text>
        </xsl:element>
        <xsl:element name="a">
          <xsl:attribute name="href">feed://fsfe.org/news/podcast.en.rss</xsl:attribute>
          <xsl:attribute name="class">button share-rss</xsl:attribute>
          <xsl:text>MP3 Feed</xsl:text>
        </xsl:element>
      </xsl:element>
      <!-- download -->
      <xsl:element name="span">
        <xsl:attribute name="class">download</xsl:attribute>
        <xsl:element name="em">
          <xsl:call-template name="gettext">
            <xsl:with-param name="id" select="'download'"/>
          </xsl:call-template>
        </xsl:element>
        <xsl:text>: </xsl:text>
        <xsl:element name="a"><xsl:attribute name="href"><xsl:value-of select="/buildinfo/document/podcast/opus/url"/><xsl:text>?ref=download</xsl:text></xsl:attribute>
          OPUS
        </xsl:element>
        <xsl:text> | </xsl:text>
        <xsl:element name="a"><xsl:attribute name="href"><xsl:value-of select="/buildinfo/document/podcast/mp3/url"/><xsl:text>?ref=download</xsl:text></xsl:attribute>
          MP3
        </xsl:element>
        <xsl:text> | </xsl:text>
        <xsl:element name="a"><xsl:attribute name="href"><xsl:value-of select="/buildinfo/document/podcast/transcript/url"/><xsl:text>?ref=download</xsl:text></xsl:attribute>
          Transcript
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
