<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dt="http://xsltsl.org/date-time">
  
  <xsl:import href="../../fsfe.xsl" />
  <xsl:output method="html" encoding="utf-8" indent="yes" doctype-system="about:legacy-compat" />
  
  <!--define dynamic list of country news items-->
    <xsl:template match="country-news">
        <xsl:call-template name="fetch-news">
            <xsl:with-param name="nb-items" select="3" />
        </xsl:call-template>
    </xsl:template>
    
    <!--define dynamic list of country event items-->
    <xsl:template match="country-events">
        <!-- Current events -->
        <xsl:call-template name="fetch-events">
            <xsl:with-param name="wanted-time" select="'present'" />
            <xsl:with-param name="display-details" select="'yes'" />
        </xsl:call-template>
        
        <!-- Future events -->
        <xsl:call-template name="fetch-events">
            <xsl:with-param name="wanted-time" select="'future'" />
            <xsl:with-param name="nb-items" select="3" />
            <xsl:with-param name="display-details" select="'yes'" />
        </xsl:call-template>
    </xsl:template>

</xsl:stylesheet>
