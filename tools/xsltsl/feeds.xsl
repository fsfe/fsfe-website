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
        <xsl:variable name="link">
            <xsl:value-of select="link" />
        </xsl:variable>
        <div class="entry">
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
            <div class="text">
                <xsl:apply-templates select="body/node()" />
            </div>
        </div>
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
        <xsl:param name="header"
                   select="''" />
        <xsl:param name="display-details"
                   select="'no'" />
        
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
        <div class="entry">
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
                    </p>
                </xsl:when>
                <xsl:otherwise>
                    <p class="date">
                        <xsl:value-of select="$start_day" />
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="$start_month" />
                    </p>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="$display-details = 'yes'">
                <div class="details">
                    <xsl:apply-templates select="body/node()" />
                    <!--<div class="cleared">&#160;</div>-->
                </div>
            </xsl:if>
            <!--
              <xsl:if test="$link != ''">
                <p class="read_more">
                  <a href="{link}"><xsl:value-of select="/html/text [@id = 'more']" /></a>
                </p>
              </xsl:if>

              <xsl:if test="$page != ''">
                <p class="read_more">
                  <a href="{page}"><xsl:value-of select="/html/text [@id = 'page']" /></a>
                </p>
              </xsl:if>
            -->
        </div>
    </xsl:template>
    
    <!-- Show a person's avatar -->
    <xsl:template name="avatar">
        <xsl:param name="id" />
        <xsl:variable name="img-path"
                      select="concat( '/about/', $id, '/', $id, '-avatar.jpg' )" />
        <xsl:element name="img">
            <xsl:attribute name="src">
                <xsl:value-of select="$img-path" />
            </xsl:attribute>
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
