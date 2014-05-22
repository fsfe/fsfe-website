<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dt="http://xsltsl.org/date-time">
  
  <xsl:import href="../tools/xsltsl/tagging.xsl" />
  <xsl:import href="../tools/xsltsl/countries.xsl" />
  <xsl:import href="../tools/xsltsl/translations.xsl" />
  <xsl:import href="../fsfe.xsl" />
  <xsl:output method="html" encoding="utf-8" indent="yes" doctype-system="about:legacy-compat" />

  <!-- To localise this page to a new country, copy this file and change the following:
  
    # <xsl:variable name="country-code">de</xsl:variable> -> change xx to your country code
    
    For more information, take a look at the documentation at
        http://fsfe.org/contribute/web/tagging.html
    
  -->
  
  <xsl:variable name="country-code">education</xsl:variable>
  
  <!--display labels-->

  <!--translated word "news"-->
  <xsl:template match="news-label">
    <xsl:call-template name="gettext">
      <xsl:with-param name="id" select="'news'" />
    </xsl:call-template>
  </xsl:template>

  <!--translated word "events"-->
  <xsl:template match="events-label">
    <xsl:call-template name="gettext">
      <xsl:with-param name="id" select="'events'" />
    </xsl:call-template>
  </xsl:template>

  <!--translated word "microblog"-->
  <xsl:template match="microblog-label">
    <xsl:call-template name="gettext">
      <xsl:with-param name="id" select="'microblog'" />
    </xsl:call-template>
  </xsl:template>

  <!--translated word "contact"-->
  <xsl:template match="contact-label">
    <xsl:call-template name="gettext">
      <xsl:with-param name="id" select="'contact'" />
    </xsl:call-template>
  </xsl:template>

  <!--translated word "team"-->
  <xsl:template match="team-label">
    <xsl:call-template name="gettext">
      <xsl:with-param name="id" select="'team'" />
    </xsl:call-template>
  </xsl:template>
  
  <!--define contact information-->
  
  <xsl:template match="contact-details">
    <xsl:for-each select="/buildinfo/document/set/contact">

    <xsl:if test="@id = 'GB'">
  
  <!-- Email -->
    <xsl:if test="email != ''">
      <xsl:element name="p">
        Team mailing-list: <xsl:value-of select="/buildinfo/textset/text[@id='email']" />
        <xsl:element name="a">
          <xsl:attribute name="href">
            <xsl:text>mailto:</xsl:text>
            <xsl:value-of select="email" />
          </xsl:attribute>
          <xsl:value-of select="email" />
        </xsl:element>
      </xsl:element>
    </xsl:if>
  
  <!-- Address -->
    <xsl:if test="address != ''">
     <xsl:apply-templates select="address"/>
    </xsl:if>
  
  <!-- Phone -->
    <xsl:if test="phone != ''">
      <xsl:element name="p">
        <xsl:value-of select="/buildinfo/textset/text[@id='phone']" />
        <xsl:text> </xsl:text>
        <xsl:value-of select="phone" />
      </xsl:element>
    </xsl:if>

  <!-- Fax -->
    <xsl:if test="fax != ''">
      <xsl:element name="p">
        <xsl:value-of select="/buildinfo/textset/text[@id='fax']" />
        <xsl:text> </xsl:text>
        <xsl:value-of select="fax" />
      </xsl:element>
    </xsl:if>
    </xsl:if>
    </xsl:for-each>
  </xsl:template>
  
  <!--define dynamic list of country news items-->
    <xsl:template match="country-news">
        <xsl:call-template name="fetch-news">
            <xsl:with-param name="tag">
                <xsl:value-of select="$country-code" />
            </xsl:with-param>
            <xsl:with-param name="nb-items" select="3" />
        </xsl:call-template>
    </xsl:template>
    
    <!--define dynamic list of country event items-->
    <xsl:template match="country-events">
        <!-- Current events -->
        <xsl:call-template name="fetch-events">
            <xsl:with-param name="wanted-time" select="'present'" />
            <xsl:with-param name="tag">
                <xsl:value-of select="$country-code" />
            </xsl:with-param>
            <xsl:with-param name="display-details" select="'yes'" />
        </xsl:call-template>
        
        <!-- Future events -->
        <xsl:call-template name="fetch-events">
            <xsl:with-param name="wanted-time" select="'future'" />
            <xsl:with-param name="nb-items" select="3" />
            <xsl:with-param name="tag">
                <xsl:value-of select="$country-code" />
            </xsl:with-param>
            <xsl:with-param name="display-details" select="'yes'" />
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

</xsl:stylesheet>
