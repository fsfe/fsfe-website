<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dt="http://xsltsl.org/date-time" xmlns:str="http://xsltsl.org/string" version="1.0" exclude-result-prefixes="dt">
  <xsl:import href="../thirdparty/date-time.xsl"/>
  <xsl:import href="../thirdparty/string.xsl"/>
  <!-- ==================================================================== -->
  <!-- News image with or without link                                      -->
  <!-- ==================================================================== -->
  <!-- Define the URL of the image -->
  <xsl:template name="news-image">
    <xsl:param name="shrink"/>
    <xsl:if test="image/@url != ''">
      <!-- the URL of the image -->
      <xsl:variable name="img-src">
        <xsl:choose>
          <!-- use a "small" version of the image, e.g.:
                https://pics.fsfe.org/uploads/medium/abc123.png
              => https://pics.fsfe.org/uploads/small/abc123.png -->
          <xsl:when test="$shrink = 'yes'">
            <xsl:call-template name="str:subst">
              <xsl:with-param name="text">
                <xsl:call-template name="str:subst">
                  <xsl:with-param name="text" select="image/@url"/>
                  <xsl:with-param name="replace" select="'/big/'"/>
                  <xsl:with-param name="with" select="'/small/'"/>
                </xsl:call-template>
              </xsl:with-param>
              <xsl:with-param name="replace" select="'/medium/'"/>
              <xsl:with-param name="with" select="'/small/'"/>
            </xsl:call-template>
          </xsl:when>
          <!-- else, take the given URL -->
          <xsl:otherwise>
            <xsl:value-of select="image/@url"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <!-- create an <img> element, optionally wrapped in an a element -->
      <xsl:choose>
        <!-- XML file provides a link (default for news items) -->
        <xsl:when test="link != ''">
          <xsl:element name="a">
            <xsl:attribute name="href">
              <xsl:value-of select="link"/>
            </xsl:attribute>
            <xsl:element name="img">
              <xsl:attribute name="src">
                <xsl:value-of select="$img-src"/>
              </xsl:attribute>
              <xsl:attribute name="alt">
                <xsl:value-of select="image/@alt"/>
              </xsl:attribute>
              <xsl:attribute name="title">
                <xsl:value-of select="image/@alt"/>
              </xsl:attribute>
            </xsl:element>
            <!-- img -->
          </xsl:element>
          <!-- a -->
        </xsl:when>
        <!-- No link given for the item -->
        <xsl:otherwise>
          <xsl:element name="img">
            <xsl:attribute name="src">
              <xsl:value-of select="$img-src"/>
            </xsl:attribute>
            <xsl:attribute name="alt">
              <xsl:value-of select="image/@alt"/>
            </xsl:attribute>
            <xsl:attribute name="title">
              <xsl:value-of select="image/@alt"/>
            </xsl:attribute>
          </xsl:element>
          <!-- img -->
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>
  <!-- ==================================================================== -->
  <!-- News title with or without link                                      -->
  <!-- ==================================================================== -->
  <xsl:template name="news-title">
    <xsl:choose>
      <xsl:when test="link">
        <xsl:element name="a">
          <xsl:attribute name="href">
            <xsl:value-of select="link"/>
          </xsl:attribute>
          <xsl:value-of select="title"/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="title"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- ==================================================================== -->
  <!-- News date, written out                                               -->
  <!-- ==================================================================== -->
  <xsl:template name="news-date">
    <xsl:value-of select="substring(@date,9,2)"/>
    <xsl:text> </xsl:text>
    <xsl:call-template name="dt:get-month-name">
      <xsl:with-param name="month" select="substring(@date,6,2)"/>
    </xsl:call-template>
    <xsl:text> </xsl:text>
    <xsl:value-of select="substring(@date,1,4)"/>
  </xsl:template>
  <!-- ==================================================================== -->
  <!-- Newsteaser text, with or without "read more" link                    -->
  <!-- ==================================================================== -->
  <xsl:template name="news-teaser">
    <xsl:variable name="link" select="link"/>
    <xsl:for-each select="body/*">
      <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
        <xsl:if test="position()=last() and $link">
          <xsl:text> </xsl:text>
          <xsl:element name="a">
            <xsl:attribute name="class">learn-more</xsl:attribute>
            <xsl:attribute name="href">
              <xsl:value-of select="$link"/>
            </xsl:attribute>
          </xsl:element>
          <!-- a/learn-more -->
        </xsl:if>
      </xsl:copy>
    </xsl:for-each>
  </xsl:template>
  <!-- ==================================================================== -->
  <!-- List of news items (as elements of an unsorted list)                 -->
  <!-- ==================================================================== -->
  <xsl:template name="news-list">
    <!-- Number of news items to display -->
    <xsl:variable name="count">
      <xsl:choose>
        <xsl:when test="@count">
          <xsl:value-of select="@count"/>
        </xsl:when>
        <xsl:otherwise>5</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!-- Build list -->
    <xsl:element name="ul">
      <xsl:attribute name="class">news-list</xsl:attribute>
      <xsl:for-each select="/buildinfo/document/set/news[           translate(@date,'-','') &lt;= translate(/buildinfo/@date,'-','')         ]">
        <xsl:sort select="@date" order="descending"/>
        <xsl:if test="position() &lt;= $count">
          <xsl:element name="li">
            <xsl:call-template name="news-title"/>
            <xsl:text> </xsl:text>
            <xsl:element name="span">
              <xsl:attribute name="class">date</xsl:attribute>
              <xsl:call-template name="news-date"/>
            </xsl:element>
            <!-- span -->
          </xsl:element>
          <!-- li -->
        </xsl:if>
      </xsl:for-each>
    </xsl:element>
    <!-- ul -->
  </xsl:template>
  <!-- ==================================================================== -->
  <!-- Verbose news feed                                                    -->
  <!-- ==================================================================== -->
  <xsl:template name="news-feed">
    <!-- Number of news items to display -->
    <xsl:variable name="count">
      <xsl:choose>
        <xsl:when test="@count">
          <xsl:value-of select="@count"/>
        </xsl:when>
        <xsl:otherwise>5</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!-- Build list -->
    <xsl:for-each select="/buildinfo/document/set/news[         translate(@date,'-','') &lt;= translate(/buildinfo/@date,'-','')       ]">
      <xsl:sort select="@date" order="descending"/>
      <xsl:if test="position() &lt;= $count">
        <xsl:element name="article">
          <xsl:attribute name="class">news</xsl:attribute>
          <xsl:attribute name="id">
            <xsl:value-of select="@filename"/>
          </xsl:attribute>
          <!-- Title -->
          <xsl:element name="h3">
            <xsl:call-template name="news-title"/>
          </xsl:element>
          <!-- Date -->
          <xsl:element name="p">
            <xsl:attribute name="class">meta</xsl:attribute>
            <xsl:call-template name="news-date"/>
          </xsl:element>
          <!-- Text -->
          <xsl:call-template name="news-teaser"/>
        </xsl:element>
        <!-- article -->
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
