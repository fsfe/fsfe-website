<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dt="http://xsltsl.org/date-time"
                exclude-result-prefixes="dt">

  <xsl:import href="gettext.xsl" />
  <xsl:import href="../../tools/xsltsl/date-time.xsl" />
    
  <!-- define content type templates-->
    
  <xsl:template name="news">
    <xsl:param name="sidebar" select="'no'" />
    
    <xsl:variable name="title">
      <xsl:choose><xsl:when test="link != ''">
        <a href="{link}"><xsl:value-of select="title" /></a>
      </xsl:when><xsl:otherwise>
        <xsl:value-of select="title" />
      </xsl:otherwise></xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="date">
      <xsl:value-of select="substring(@date,9,2)" />
      <xsl:text> </xsl:text>
      <xsl:call-template name="dt:get-month-name">
        <xsl:with-param name="month" select="substring(@date,6,2)" />
      </xsl:call-template>
      <xsl:text> </xsl:text>
      <xsl:value-of select="substring(@date,1,4)" />
    </xsl:variable>
    
    <xsl:choose>
      <xsl:when test="$sidebar = 'yes'">
        <li>
          <!-- title -->
          <xsl:call-template name="generate-id-attribute">
            <xsl:with-param name="title" select="title" />
          </xsl:call-template>
          <xsl:copy-of select="$title" />
          
          <!-- news date -->
          <xsl:text> (</xsl:text>
          <xsl:copy-of select="$date" />
          <xsl:text>)</xsl:text>
        </li>
      </xsl:when>
      <xsl:otherwise>
        <!--<div class="entry">-->
        <div class="entry">
          <!-- title -->
          <h3>
            <xsl:call-template name="generate-id-attribute">
              <xsl:with-param name="title" select="title" />
            </xsl:call-template>
            <xsl:copy-of select="$title" />
          </h3>
          
          <!-- news date -->
          <p class="date"><xsl:copy-of select="$date" /></p>
          
          <!-- news text -->
          <div class="text"><xsl:apply-templates select="body/node()" /></div>
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- Show a single event -->
  <xsl:template name="event">
    <xsl:param name="header" select="''" />
    <xsl:param name="display-tags" select="'no'" />
    
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
      <xsl:variable name="headertext">
        <xsl:value-of select="/buildinfo/document/text[@id = $header]" />
      </xsl:variable>
      <xsl:if test="$headertext != ''">
        <xsl:element name="h2">
          <xsl:call-template name="generate-id-attribute">
            <xsl:with-param name="title" select="$headertext" />
          </xsl:call-template>
          <xsl:value-of select="$headertext" />
        </xsl:element>
      </xsl:if>
    </xsl:if>
    
    
    <!-- Now, the event block -->
    <xsl:element name="div">
      <xsl:attribute name="class">entry</xsl:attribute>
      <xsl:attribute name="id">
        <xsl:value-of select="@filename" />
      </xsl:attribute>
      
      <!-- event title with or without link -->
      <h3>
       <xsl:call-template name="generate-id-attribute">
          <xsl:with-param name="title" select="title" />
       </xsl:call-template>
       <xsl:choose>
         <xsl:when test="$link != ''">
           <a href="{link}">
             <xsl:value-of select="title" />
           </a>
         </xsl:when>
         <xsl:when test="$page != ''">
           <a href="{page}">
             <xsl:value-of select="title" />
           </a>
         </xsl:when>
         <xsl:otherwise>
           <xsl:value-of select="title" />
         </xsl:otherwise>
       </xsl:choose>
      </h3>
     
      <!-- event date -->
      <xsl:choose>
        <xsl:when test="$start != $end">
          <p class="date">
            <xsl:value-of select="$start_day" />
            <xsl:text> </xsl:text>
            <xsl:if test="$start_month != $end_month">
              <xsl:value-of select="$start_month" />
            </xsl:if>
            <xsl:text> to </xsl:text> 
            <xsl:value-of select="$end_day" />
            <xsl:text> </xsl:text>
            <xsl:value-of select="$end_month" />
            <xsl:text> </xsl:text>
            <xsl:value-of select="$end_year" />
          </p>
        </xsl:when>
        <xsl:otherwise>
          <p class="date">
            <xsl:value-of select="$start_day" />
            <xsl:text> </xsl:text>
            <xsl:value-of select="$start_month" />
            <xsl:text> </xsl:text>
            <xsl:value-of select="$end_year" />
          </p>
        </xsl:otherwise>
      </xsl:choose>
      
      <!-- details about the event -->
      <div class="details">
        <xsl:apply-templates select="body/node()" />
      </div>
      
      <!-- tags -->
      <xsl:if test="$display-tags = 'yes'">
        <ul class="archivetaglist">
          <xsl:for-each select="tags/tag[not(@key='front-page')]">
            <li><a href="/tags/tagged-{@key}.{/buildinfo/@language}.html"><xsl:value-of select="." /></a></li>
          </xsl:for-each>
        </ul>
      </xsl:if>

    </xsl:element>
    
  </xsl:template>

</xsl:stylesheet>
