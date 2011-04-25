<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dt="http://xsltsl.org/date-time">
  
  <xsl:import href="../tools/xsltsl/tagging.xsl" />
  <xsl:import href="../tools/xsltsl/countries.xsl" />
  <xsl:import href="../tools/xsltsl/translations.xsl" />
  <xsl:output method="xml" encoding="UTF-8" indent="yes" />

  <!-- To localise this page to a new country, copy this file and change the following:
  
    # <xsl:variable name="country-code">de</xsl:variable> -> change xx to your country code
    
    For more information, take a look at the documentation under
        /tools/xsltsl/tagging-documentation.txt
    
  -->
  
  <xsl:variable name="country-code">de</xsl:variable>
  
  <!--define dynamic list of country news items-->
  <xsl:template match="country-news">
      <xsl:call-template name="fetch-news">
          <xsl:with-param name="tag">
              <xsl:value-of select="$country-code" />
          </xsl:with-param>
      </xsl:call-template>
  </xsl:template>
  
  <!--define dynamic list of country event items-->
  <xsl:template match="country-events">
      <!-- Current events -->
      <xsl:call-template name="fetch-events">
          <xsl:with-param name="wanted-time" select="'present'" />
          <xsl:with-param name="display-details" select="'yes'" />
          <xsl:with-param name="tag">
              <xsl:value-of select="$country-code" />
          </xsl:with-param>
      </xsl:call-template>
      
      <!-- Future events -->
      <xsl:call-template name="fetch-events">
          <xsl:with-param name="wanted-time" select="'future'" />
          <xsl:with-param name="display-details" select="'yes'" />
          <xsl:with-param name="nb-events" select="3" />
          <xsl:with-param name="tag">
              <xsl:value-of select="$country-code" />
          </xsl:with-param>
      </xsl:call-template>
  </xsl:template>
  
  <!--define dynamic list of country team members-->
  <xsl:template match="country-team-list">
      <xsl:call-template name="country-people-list">
          <xsl:with-param name="team">
              <xsl:value-of select="$country-code" />
          </xsl:with-param>
      </xsl:call-template>
  </xsl:template>
    
  <!--translated word "microblog"-->
  <xsl:template match="microblog-label">
    <xsl:call-template name="gettext">
      <xsl:with-param name="id" select="'microblog'" />
    </xsl:call-template>
  </xsl:template>
  
  <!-- Do not copy <set> or <text> to output at all -->
  <xsl:template match="set | tags"/>

  <!-- For all other nodes, copy verbatim -->
  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
