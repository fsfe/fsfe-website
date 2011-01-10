<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dt="http://xsltsl.org/date-time">
  
  <xsl:import href="../../tools/xsltsl/tagging.xsl" />
  <xsl:import href="../../tools/xsltsl/countries.xsl" />
  <xsl:output method="xml" encoding="UTF-8" indent="yes" />

  <!-- To localise this page to a new country, copy this file and change the following:
  
    # <xsl:variable name="country-code">de</xsl:variable> -> change xx to your country code
    
  -->
  
  <xsl:variable name="country-code">gb</xsl:variable>
  
  <!--define contact information-->
  
  <xsl:template match="contact-details">
    <xsl:for-each select="/html/set/contact">

    <xsl:if test="@id = 'GB'">
  
  <!-- Email -->
    <xsl:if test="email != ''">
      <xsl:element name="p">
	<xsl:value-of select="/buildinfo/textset/text[@id='email']" />
	<xsl:text> </xsl:text>
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
  
  <!-- Do not copy <set> to output at all -->
  <xsl:template match="set"/>

  <!-- For all other nodes, copy verbatim -->
  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
