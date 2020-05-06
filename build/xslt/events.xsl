<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dt="http://xsltsl.org/date-time"
                exclude-result-prefixes="dt">

  <xsl:import href="../../tools/xsltsl/date-time.xsl"/>


  <!-- ==================================================================== -->
  <!-- Event title with or without link                                     -->
  <!-- ==================================================================== -->

  <xsl:template name="event-title">
    <xsl:choose>
      <xsl:when test="link">
        <xsl:element name="a">
          <xsl:attribute name="href">
            <xsl:value-of select="link"/>
          </xsl:attribute>
          <xsl:value-of select="title"/>
        </xsl:element>
      </xsl:when>
      <xsl:when test="page">
        <xsl:element name="a">
          <xsl:attribute name="href">
            <xsl:value-of select="page"/>
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
  <!-- Event date, written out                                              -->
  <!-- ==================================================================== -->

  <xsl:template name="event-date">

    <!-- Create variables -->
    <xsl:variable name="start">
      <xsl:value-of select="@start"/>
    </xsl:variable>

    <xsl:variable name="start_day">
      <xsl:value-of select="substring($start,9,2)"/>
    </xsl:variable>

    <xsl:variable name="start_month">
      <xsl:call-template name="dt:get-month-name">
        <xsl:with-param name="month"
                        select="substring($start,6,2)"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="end">
      <xsl:value-of select="@end"/>
    </xsl:variable>

    <xsl:variable name="end_day">
      <xsl:value-of select="substring($end,9,2)"/>
    </xsl:variable>

    <xsl:variable name="end_month">
      <xsl:call-template name="dt:get-month-name">
        <xsl:with-param name="month"
                        select="substring($end,6,2)"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="end_year">
      <xsl:value-of select="substring($end,1,4)"/>
    </xsl:variable>

    <!-- Compile the date -->
    <xsl:choose>
      <xsl:when test="$start != $end">
          <xsl:value-of select="$start_day"/>
          <xsl:text> </xsl:text>
          <xsl:if test="$start_month != $end_month">
            <xsl:value-of select="$start_month"/>
          </xsl:if>
          <xsl:text> – </xsl:text>
          <xsl:value-of select="$end_day"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="$end_month"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="$end_year"/>
      </xsl:when>
      <xsl:otherwise>
          <xsl:value-of select="$start_day"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="$start_month"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="$end_year"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!-- ==================================================================== -->
  <!-- Event information, with or without "read more" link                  -->
  <!-- ==================================================================== -->

  <xsl:template name="event-info">
    <xsl:variable name="link">
      <xsl:choose>
        <xsl:when test="link">
          <xsl:value-of select="link"/>
        </xsl:when>
        <xsl:when test="page">
          <xsl:value-of select="page"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:for-each select="body/*">
      <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
        <xsl:if test="position()=last() and $link">
          <xsl:text>&#160;</xsl:text>
          <xsl:element name="a">
            <xsl:attribute name="class">learn-more</xsl:attribute>
            <xsl:attribute name="href">
              <xsl:value-of select="$link"/>
            </xsl:attribute>
          </xsl:element><!-- a/learn-more -->
        </xsl:if>
      </xsl:copy>
    </xsl:for-each>
  </xsl:template>


  <!-- ==================================================================== -->
  <!-- List of events (as elements of an unsorted list)                     -->
  <!-- ==================================================================== -->

  <xsl:template name="event-list">

    <!-- Number of events to display -->
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
      <xsl:attribute name="class">event-list</xsl:attribute>
      <xsl:for-each select="/buildinfo/document/set/event[
          translate(@end,'-','') &gt;= translate(/buildinfo/@date,'-','')
        ]">
        <xsl:sort select="@start"/>
        <xsl:if test="position() &lt;= $count">
          <xsl:element name="li">
            <xsl:call-template name="event-title"/>
            <xsl:text>&#160;</xsl:text>
            <xsl:element name="span">
              <xsl:attribute name="date"/>
              <xsl:call-template name="event-date"/>
            </xsl:element><!-- span -->
          </xsl:element><!-- li -->
        </xsl:if>
      </xsl:for-each>
    </xsl:element><!-- ul -->

  </xsl:template>

  <!-- ==================================================================== -->
  <!-- Verbose event feed                                                   -->
  <!-- ==================================================================== -->

  <xsl:template name="event-feed">

    <!-- Number of events to display -->
    <xsl:variable name="count">
      <xsl:choose>
        <xsl:when test="@count">
          <xsl:value-of select="@count"/>
        </xsl:when>
        <xsl:otherwise>5</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- Build list -->
    <xsl:for-each select="/buildinfo/document/set/event[
        translate(@end,'-','') &gt;= translate(/buildinfo/@date,'-','')
      ]">
      <xsl:sort select="@start"/>
      <xsl:if test="position() &lt;= $count">
        <xsl:element name="article">
          <xsl:attribute name="class">event</xsl:attribute>
          <xsl:attribute name="id">
            <xsl:value-of select="@filename"/>
          </xsl:attribute>

          <!-- Title -->
          <xsl:element name="h3">
            <xsl:call-template name="event-title"/>
          </xsl:element>

          <!-- Date -->
          <xsl:element name="p">
            <xsl:attribute name="class">meta</xsl:attribute>
            <xsl:call-template name="event-date"/>
          </xsl:element>

          <!-- Details -->
          <xsl:call-template name="event-info"/>

        </xsl:element><!-- article -->
      </xsl:if>
    </xsl:for-each>

  </xsl:template>

</xsl:stylesheet>
