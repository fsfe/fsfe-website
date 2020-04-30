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
  <!-- List of events (as elements of an unsorted list)                     -->
  <!-- ==================================================================== -->

  <xsl:template match="event-list">

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
      <xsl:for-each select="/buildinfo/document/set/event[
          translate(@end,'-','') &gt;= translate(/buildinfo/@date,'-','')
        ]">
        <xsl:sort select="@start"/>
        <xsl:if test="position() &lt;= $count">
          <xsl:element name="li">
            <xsl:call-template name="event-date"/>
            <xsl:text>: </xsl:text>
            <xsl:call-template name="event-title"/>
          </xsl:element><!-- li -->
        </xsl:if>
      </xsl:for-each>
    </xsl:element><!-- ul -->

  </xsl:template>

  <!-- ==================================================================== -->
  <!-- Verbose event feed                                                   -->
  <!-- ==================================================================== -->

  <xsl:template match="event-feed">

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
        <xsl:element name="div">
          <xsl:attribute name="class">entry</xsl:attribute>
          <xsl:attribute name="id">
            <xsl:value-of select="@filename"/>
          </xsl:attribute>

          <!-- Title -->
          <xsl:element name="h3">
            <xsl:call-template name="event-title"/>
          </xsl:element>

          <!-- Date -->
          <xsl:element name="p">
            <xsl:attribute name="class">date</xsl:attribute>
            <xsl:call-template name="event-date"/>
          </xsl:element>

          <!-- Details -->
          <xsl:element name="div">
            <xsl:attribute name="class">text</xsl:attribute>
            <xsl:apply-templates select="body/node()"/>
          </xsl:element>

        </xsl:element><!-- div/entry -->
      </xsl:if>
    </xsl:for-each>

  </xsl:template>

</xsl:stylesheet>
