<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dt="http://xsltsl.org/date-time">
  <xsl:output method="xml"
              encoding="UTF-8"
              indent="yes" />
    
  <!-- define content type templates-->
    
  <!-- Show a single news item -->
  <xsl:template name="news">
    <xsl:param name="display-year" select="'no'" />
    <xsl:param name="show-date" select="'yes'" />
    
    <xsl:variable name="link">
      <xsl:value-of select="link" />
    </xsl:variable>
    
    <xsl:variable name="day">
      <xsl:value-of select="substring(@date,9,2)" />
    </xsl:variable>
    
    <xsl:variable name="month">
      <xsl:call-template name="dt:get-month-name">
        <xsl:with-param name="month" select="substring(@date,6,2)" />
      </xsl:call-template>
    </xsl:variable>
    
    <xsl:variable name="year">
      <xsl:value-of select="substring(@date,1,4)" />
    </xsl:variable>
    
    <!--<div class="entry">-->
    <xsl:element name="div">
      <xsl:attribute name="class">entry</xsl:attribute>
      
      <!-- title -->
      <xsl:choose>
        <xsl:when test="$link != ''">
          <h3>
            <a href="{link}">
              <xsl:value-of select="title" />
            </a>
          </h3>
        </xsl:when>
        <xsl:otherwise>
          <h3>
            <xsl:value-of select="title" />
          </h3>
        </xsl:otherwise>
      </xsl:choose>
      
      <!-- news date -->
      <xsl:if test="$show-date = 'yes'">
        <p class="date">
          <xsl:value-of select="$day" />
          <xsl:text> </xsl:text>
          <xsl:value-of select="$month" />
          <xsl:if test="$display-year = 'yes'">
            <xsl:text> </xsl:text>
            <xsl:value-of select="$year" />
          </xsl:if>
        </p>
      </xsl:if>
      
      <!-- news text -->
      <div class="text">
        <xsl:apply-templates select="body/node()" />
      </div>
      
    </xsl:element>
    
  </xsl:template>

  <!-- Show a single newsletter item -->
  <xsl:template name="newsletter">
    <xsl:variable name="link">
      <xsl:value-of select="link" />
    </xsl:variable>
    <li>
      <a href="{link}">
        <xsl:value-of select="title" />
      </a>
    </li>
  </xsl:template>

  <!-- Show a single event -->
  <xsl:template name="event">
    <xsl:param name="header" select="''" />
    <xsl:param name="display-details" select="'no'" />
    <xsl:param name="display-year" select="'no'" />
    
    <!-- Create variables -->
    <xsl:variable name="start">
      <xsl:value-of select="@start" />
    </xsl:variable>
    
    <xsl:variable name="start_day">
      <xsl:value-of select="substring($start,9,2)" />
    </xsl:variable>
    
    <xsl:variable name="start_month">
      <xsl:call-template name="dt:get-month-name">
        <xsl:with-param name="month"
                        select="substring($start,6,2)" />
      </xsl:call-template>
    </xsl:variable>
    
    <xsl:variable name="end">
      <xsl:value-of select="@end" />
    </xsl:variable>
    
    <xsl:variable name="end_day">
      <xsl:value-of select="substring($end,9,2)" />
    </xsl:variable>
    
    <xsl:variable name="end_month">
      <xsl:call-template name="dt:get-month-name">
        <xsl:with-param name="month"
                        select="substring($end,6,2)" />
      </xsl:call-template>
    </xsl:variable>
    
    <xsl:variable name="end_year">
      <xsl:value-of select="substring($end,1,4)" />
    </xsl:variable>
    
    <xsl:variable name="link">
      <xsl:value-of select="link" />
    </xsl:variable>
    
    <xsl:variable name="page">
      <xsl:value-of select="page" />
    </xsl:variable>

    <!-- Before the first event, include the header -->
    <xsl:if test="position() = 1 and $header != ''">
      <h2>
        <xsl:value-of select="/html/text [@id = $header]" />
      </h2>
    </xsl:if>
    
    
    <!-- Now, the event block -->
    <xsl:element name="div">
      <xsl:attribute name="class">div</xsl:attribute>
      <xsl:attribute name="id">
        <xsl:value-of select="@filename" />
      </xsl:attribute>
      
      <!-- event title with or without link -->
      <xsl:choose>
        <xsl:when test="$link != ''">
          <h3>
            <a href="{link}">
              <xsl:value-of select="title" />
            </a>
          </h3>
        </xsl:when>
        <xsl:when test="$page != ''">
          <h3>
            <a href="{page}">
              <xsl:value-of select="title" />
            </a>
          </h3>
        </xsl:when>
        <xsl:otherwise>
          <h3>
            <xsl:value-of select="title" />
          </h3>
        </xsl:otherwise>
      </xsl:choose>
      
      <!-- event date -->
      <xsl:choose>
        <xsl:when test="$start != $end">
          <p class="date">
            <xsl:value-of select="$start_day" />
            <xsl:text> </xsl:text>
            <xsl:value-of select="$start_month" />
            <xsl:text> to </xsl:text>
            <xsl:value-of select="$end_day" />
            <xsl:text> </xsl:text>
            <xsl:value-of select="$end_month" />
            <xsl:if test="$display-year = 'yes'">
              <xsl:text> </xsl:text>
              <xsl:value-of select="$end_year" />
            </xsl:if>
          </p>
        </xsl:when>
        <xsl:otherwise>
          <p class="date">
            <xsl:value-of select="$start_day" />
            <xsl:text> </xsl:text>
            <xsl:value-of select="$start_month" />
            <xsl:if test="$display-year = 'yes'">
              <xsl:text> </xsl:text>
              <xsl:value-of select="$end_year" />
            </xsl:if>
          </p>
        </xsl:otherwise>
      </xsl:choose>
      
      <!-- and possibly details about the event -->
      <xsl:if test="$display-details = 'yes'">
        <div class="details">
          <xsl:apply-templates select="body/node()" />
        </div>
      </xsl:if>
      
    </xsl:element>
    
  </xsl:template>

  <!-- Show a person's avatar -->
  <xsl:template name="avatar">
    <xsl:param name="id" />
    <xsl:variable name="img-path"
                  select="concat( '/about/', $id, '/', $id, '-avatar.jpg' )" />
    <xsl:element name="img">
      <xsl:attribute name="src">
        <!-- we have a default path as the source of the image: /about/*id*/*id*-avatar.jpg -->
        <xsl:value-of select="$img-path" />
      </xsl:attribute>
      <!-- And on error (if previous file does not exist), we load our default image -->
      <xsl:attribute name="onerror">
        <xsl:text>
	  this.src='/graphics/default-avatar.png';
	</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="alt"
                     value="No picture" />
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
