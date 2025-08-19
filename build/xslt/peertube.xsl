<?xml version="1.0" encoding="UTF-8"?>
<!-- ====================================================================== -->
<!-- XSLT for embedding peertube videos nicely                     -->
<!-- ====================================================================== -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:template name="peertube" match="peertube">
    <xsl:param name="url" select="@url"/>
    <xsl:variable name="uuid_url">
      <xsl:text>https://download.fsfe.org/videos/peertube/</xsl:text>
      <xsl:value-of select="substring-after($url,'https://media.fsfe.org/w/')"/>
    </xsl:variable>
    <xsl:element name="video">
      <xsl:attribute name="crossorigin">crossorigin</xsl:attribute>
      <xsl:attribute name="poster">
        <xsl:value-of select="$uuid_url"/>
        <xsl:text>.jpg</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="controls">controls</xsl:attribute>
      <!-- MP4 1080p -->
      <xsl:element name="source">
        <xsl:attribute name="type">video/mp4; codecs="avc1.42E01E, mp4a.40.2"</xsl:attribute>
        <xsl:attribute name="media">screen and (min-width:1200px)</xsl:attribute>
        <xsl:attribute name="src">
          <xsl:value-of select="$uuid_url"/>
          <xsl:text>_1080p.mp4</xsl:text>
        </xsl:attribute>
      </xsl:element>
      <!-- MP4 720p -->
      <xsl:element name="source">
        <xsl:attribute name="type">video/mp4; codecs="avc1.42E01E, mp4a.40.2"</xsl:attribute>
        <xsl:attribute name="media">screen and (max-width:1199px)</xsl:attribute>
        <xsl:attribute name="src">
          <xsl:value-of select="$uuid_url"/>
          <xsl:text>_720p.mp4</xsl:text>
        </xsl:attribute>
      </xsl:element>
      <!-- MP4 360p -->
      <xsl:element name="source">
        <xsl:attribute name="type">video/mp4; codecs="avc1.42E01E, mp4a.40.2"</xsl:attribute>
        <xsl:attribute name="media">screen and (max-width:420px)</xsl:attribute>
        <xsl:attribute name="src">
          <xsl:value-of select="$uuid_url"/>
          <xsl:text>_360p.mp4</xsl:text>
        </xsl:attribute>
      </xsl:element>
      <!-- WEBM 1080p -->
      <xsl:element name="source">
        <xsl:attribute name="type">video/webm; codecs="vp9, opus"</xsl:attribute>
        <xsl:attribute name="media">screen and (min-width:1200px)</xsl:attribute>
        <xsl:attribute name="src">
          <xsl:value-of select="$uuid_url"/>
          <xsl:text>_1080p.webm</xsl:text>
        </xsl:attribute>
      </xsl:element>
      <!-- WEBM 720p -->
      <xsl:element name="source">
        <xsl:attribute name="type">video/webm; codecs="vp9, opus"</xsl:attribute>
        <xsl:attribute name="media">screen and (max-width:1199px)</xsl:attribute>
        <xsl:attribute name="src">
          <xsl:value-of select="$uuid_url"/>
          <xsl:text>_720p.webm</xsl:text>
        </xsl:attribute>
      </xsl:element>
      <!-- WEBM 360p -->
      <xsl:element name="source">
        <xsl:attribute name="type">video/webm; codecs="vp9, opus"</xsl:attribute>
        <xsl:attribute name="media">screen and (max-width:420px)</xsl:attribute>
        <xsl:attribute name="src">
          <xsl:value-of select="$uuid_url"/>
          <xsl:text>_360p.webm</xsl:text>
        </xsl:attribute>
      </xsl:element>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
