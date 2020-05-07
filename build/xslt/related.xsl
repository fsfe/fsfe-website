<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="gettext.xsl"/>
  <xsl:import href="news.xsl"/>
  <xsl:import href="events.xsl"/>


  <!-- ==================================================================== -->
  <!-- Short list of related news and events                                -->
  <!-- ==================================================================== -->

  <xsl:template match="related-list">

    <!-- Related news -->
    <xsl:if test="/buildinfo/document/set/news[
        translate(@date,'-','') &lt;= translate(/buildinfo/@date,'-','')
      ]">
      <xsl:element name="h3">
        <xsl:call-template name="fsfe-gettext">
          <xsl:with-param name="id">related-news</xsl:with-param>
        </xsl:call-template>
      </xsl:element>
      <xsl:call-template name="news-list"/>
    </xsl:if>

    <!-- Related events -->
    <xsl:if test="/buildinfo/document/set/event[
        translate(@end,'-','') &gt;= translate(/buildinfo/@date,'-','')
      ]">
      <xsl:element name="h3">
        <xsl:call-template name="fsfe-gettext">
          <xsl:with-param name="id">related-events</xsl:with-param>
        </xsl:call-template>
      </xsl:element>
      <xsl:call-template name="event-list"/>
    </xsl:if>

    <!-- Link to tag page -->
    <xsl:if test="@tag">
      <xsl:element name="p">
        <xsl:element name="a">
          <xsl:attribute name="href">
            <xsl:text>/tags/tagged-</xsl:text>
            <xsl:value-of select="@tag"/>
            <xsl:text>.html</xsl:text>
          </xsl:attribute>
          <xsl:call-template name="fsfe-gettext">
            <xsl:with-param name="id">related-all</xsl:with-param>
          </xsl:call-template>
        </xsl:element><!-- a -->
      </xsl:element><!-- p -->
    </xsl:if>

  </xsl:template>


  <!-- ==================================================================== -->
  <!-- Verbose feed of related news and events                              -->
  <!-- ==================================================================== -->

  <xsl:template match="related-feed">

    <!-- Related news -->
    <xsl:if test="/buildinfo/document/set/news[
        translate(@date,'-','') &lt;= translate(/buildinfo/@date,'-','')
      ]">
      <xsl:element name="section">
        <xsl:attribute name="id">related-news</xsl:attribute>
        <xsl:element name="h2">
          <xsl:call-template name="fsfe-gettext">
            <xsl:with-param name="id">related-news</xsl:with-param>
          </xsl:call-template>
        </xsl:element><!-- h2 -->
        <xsl:call-template name="news-feed"/>
      </xsl:element><!-- section -->
    </xsl:if>

    <!-- Related events -->
    <xsl:if test="/buildinfo/document/set/event[
        translate(@end,'-','') &gt;= translate(/buildinfo/@date,'-','')
      ]">
      <xsl:element name="section">
        <xsl:attribute name="id">related-events</xsl:attribute>
        <xsl:element name="h2">
          <xsl:call-template name="fsfe-gettext">
            <xsl:with-param name="id">related-events</xsl:with-param>
          </xsl:call-template>
        </xsl:element><!-- h2 -->
        <xsl:call-template name="event-feed"/>
      </xsl:element><!-- section -->
    </xsl:if>

    <!-- Link to tag page -->
    <xsl:if test="@tag">
      <xsl:element name="p">
        <xsl:element name="a">
          <xsl:attribute name="href">
            <xsl:text>/tags/tagged-</xsl:text>
            <xsl:value-of select="@tag"/>
            <xsl:text>.html</xsl:text>
          </xsl:attribute>
          <xsl:call-template name="fsfe-gettext">
            <xsl:with-param name="id">related-all</xsl:with-param>
          </xsl:call-template>
        </xsl:element><!-- a -->
      </xsl:element><!-- p -->
    </xsl:if>

  </xsl:template>

</xsl:stylesheet>
