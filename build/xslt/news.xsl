<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dt="http://xsltsl.org/date-time"
                exclude-result-prefixes="dt">

  <xsl:import href="../../tools/xsltsl/date-time.xsl"/>


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
  <!-- List of news items (as elements of an unsorted list)                 -->
  <!-- ==================================================================== -->

  <xsl:template match="news-list">

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
      <xsl:for-each select="/buildinfo/document/set/news[
          translate(@date,'-','') &lt;= translate(/buildinfo/@date,'-','')
        ]">
        <xsl:sort select="@date" order="descending"/>
        <xsl:if test="position() &lt;= $count">
          <xsl:element name="li">
            <xsl:call-template name="news-title"/>
            <xsl:text> (</xsl:text>
            <xsl:call-template name="news-date"/>
            <xsl:text>)</xsl:text>
          </xsl:element><!-- li -->
        </xsl:if>
      </xsl:for-each>
    </xsl:element><!-- ul -->

  </xsl:template>


  <!-- ==================================================================== -->
  <!-- Verbose news feed                                                    -->
  <!-- ==================================================================== -->

  <xsl:template match="news-feed">

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
    <xsl:for-each select="/buildinfo/document/set/news[
        translate(@date,'-','') &lt;= translate(/buildinfo/@date,'-','')
      ]">
      <xsl:sort select="@date" order="descending"/>
      <xsl:if test="position() &lt;= $count">
        <xsl:element name="div">
          <xsl:attribute name="class">entry</xsl:attribute>
          <xsl:attribute name="id">
            <xsl:value-of select="@filename"/>
          </xsl:attribute>

          <!-- Title -->
          <xsl:element name="h3">
            <xsl:call-template name="news-title"/>
          </xsl:element>

          <!-- Date -->
          <xsl:element name="p">
            <xsl:attribute name="class">date</xsl:attribute>
            <xsl:call-template name="news-date"/>
          </xsl:element>

          <!-- Text -->
          <xsl:element name="div">
            <xsl:attribute name="class">text</xsl:attribute>
            <xsl:apply-templates select="body/node()"/>
          </xsl:element>

        </xsl:element><!-- div/entry -->
      </xsl:if>
    </xsl:for-each>

  </xsl:template>

</xsl:stylesheet>
