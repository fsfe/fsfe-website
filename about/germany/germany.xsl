<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dt="http://xsltsl.org/date-time">
  
  <xsl:import href="../../tools/xsltsl/date-time.xsl" />
  <xsl:import href="../../tools/xsltsl/tagging.xsl" />
  <xsl:output method="xml" encoding="UTF-8" indent="yes" />

  <!-- To localise this page to a new country change the following:
  
    # /html/set/person[@chapter_xx - change xx to your country code
    # <xsl:variable name="country-code">de - change xx to your country code
    
  -->
  
  <xsl:variable name="country-code">de</xsl:variable>

  <!-- set today variable-->
  <xsl:variable name="today">
    <xsl:value-of select="/html/@date" />
  </xsl:variable>

  <!-- define content type templates-->

  <!-- Show a single news item -->
  <xsl:template name="news">
    <xsl:variable name="link"><xsl:value-of select="link" /></xsl:variable>
    <div class="entry">
      <xsl:choose>
        <xsl:when test="$link != ''">
          <h3><a href="{link}"><xsl:value-of select="title" /></a></h3>
        </xsl:when>
        <xsl:otherwise>
          <h3><xsl:value-of select="title" /></h3>
        </xsl:otherwise>
      </xsl:choose>
      
      <div class="text">
        <xsl:apply-templates select="body/node()" />
      </div>
      
    </div>
  </xsl:template>

  <!-- Show a single event -->
  <xsl:template name="event">

    <!-- Create variables -->
    <xsl:variable name="start">
      <xsl:value-of select="@start" />
    </xsl:variable>
    
    <xsl:variable name="start_day">
      <xsl:value-of select="substring($start,9,2)" />
    </xsl:variable>
    
    <xsl:variable name="start_month">
      <xsl:call-template name="dt:get-month-name">
        <xsl:with-param name="month" select="substring($start,6,2)" />
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
        <xsl:with-param name="month" select="substring($end,6,2)" />
      </xsl:call-template>
    </xsl:variable>
    
    <xsl:variable name="link">
      <xsl:value-of select="link" />
    </xsl:variable>
 
    <div class="entry">
      <xsl:choose>
        <xsl:when test="$link != ''">
          <h3><a href="{link}"><xsl:value-of select="title" /></a></h3>
        </xsl:when>
        <xsl:otherwise>
          <h3><xsl:value-of select="title" /></h3>
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
    </div>
  </xsl:template>
  
  <!--define dynamic list of country news items-->
  <xsl:template match="country-news">
  	
    <xsl:call-template name="news-with-tag">
    	<xsl:with-param name="tag">de</xsl:with-param>
    </xsl:call-template>
    
  </xsl:template>
  
  <!--define dynamic list of country event items-->
  <xsl:template match="country-events">
  	
    <xsl:call-template name="events-with-tag">
    	<xsl:with-param name="tag">de</xsl:with-param>
    </xsl:call-template>
    
  </xsl:template>

  <!--define dynamic list of country team members-->
  <xsl:template match="country-team-list">
    <xsl:element name="ul">
      <xsl:attribute name="class">people</xsl:attribute>
      
      <xsl:for-each select="/html/set/person[@chapter_de='yes']">
	<xsl:sort select="@id"/>
	<xsl:element name="li">
	  <xsl:element name="p">
	  
	    <!-- Picture -->
	      <xsl:choose>
		<xsl:when test="link != ''">
		  <xsl:element name="a">
		    <xsl:attribute name="href">
		      <xsl:value-of select="link"/>
		    </xsl:attribute>
		    
		    <xsl:element name="img">
		    
		      <xsl:attribute name="alt">
			<xsl:value-of select="name"/>
		      </xsl:attribute>
		      
		      <xsl:attribute name="src">
		      
		      <xsl:choose>
		      
			<xsl:when test="not(avatar)">/graphics/default-avatar.png</xsl:when>
			
			<xsl:otherwise><xsl:value-of select="avatar"/></xsl:otherwise>
			
		      </xsl:choose>
		      
		      </xsl:attribute>
		      
		    </xsl:element>
		    
		  </xsl:element>
		</xsl:when>
		<xsl:otherwise>
		  <xsl:element name="img">
		    <xsl:attribute name="alt">
		      <xsl:value-of select="name"/>
		    </xsl:attribute>
		    <xsl:attribute name="src">
		      <xsl:value-of select="avatar"/>
		    </xsl:attribute>
		  </xsl:element>
		</xsl:otherwise>
	      </xsl:choose>

	    <!-- Name; if link is given show as link -->
	    <xsl:element name="span">
	      <xsl:attribute name="class">name</xsl:attribute>
	      <xsl:choose>
		<xsl:when test="link != ''">
		  <xsl:element name="a">
		    <xsl:attribute name="href">
		      <xsl:value-of select="link"/>
		    </xsl:attribute>
		    <xsl:value-of select="name"/>
		  </xsl:element>
		</xsl:when>
		<xsl:otherwise>
		  <xsl:value-of select="name"/>
		</xsl:otherwise>
	      </xsl:choose>
	    </xsl:element>

	    <!-- E-mail -->
	    <xsl:element name="span">
	      <xsl:attribute name="class">email</xsl:attribute>
	      <xsl:if test="email != ''">
		<xsl:value-of select="email"/>
	      </xsl:if>
	    </xsl:element>

	    <!-- Functions -->
	    <xsl:for-each select="function">
	      <xsl:if test="position()!=1">
		<xsl:text>, </xsl:text>
	      </xsl:if>
	      <xsl:variable name="function"><xsl:value-of select="."/></xsl:variable>
	      <xsl:apply-templates select="/html/set/function[@id=$function]/node()"/>
	      <xsl:if test="@country != ''">
		<xsl:text> </xsl:text>
		<xsl:variable name="country"><xsl:value-of select="@country"/></xsl:variable>
		<xsl:value-of select="/html/set/country[@id=$country]"/>
	      </xsl:if>
	      <xsl:if test="@project != ''">
		<xsl:text> </xsl:text>
		<xsl:variable name="project"><xsl:value-of select="@project"/></xsl:variable>
		<xsl:element name="a">
		  <xsl:attribute name="href">
		    <xsl:value-of select="/html/set/project[@id=$project]/link"/>
		  </xsl:attribute>
		  <xsl:value-of select="/html/set/project[@id=$project]/title"/>
		</xsl:element>
	      </xsl:if>
	      <xsl:if test="@volunteers != ''">
		<xsl:text> </xsl:text>
		<xsl:variable name="volunteers"><xsl:value-of select="@volunteers"/></xsl:variable>
		<xsl:apply-templates select="/html/set/volunteers[@id=$volunteers]/node()"/>
	      </xsl:if>
	    </xsl:for-each>

	  </xsl:element>
	</xsl:element>
      </xsl:for-each>
    </xsl:element>
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
