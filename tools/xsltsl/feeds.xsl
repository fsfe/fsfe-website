<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dt="http://xsltsl.org/date-time"
                exclude-result-prefixes="dt">

  <xsl:import href="../../build/xslt/gettext.xsl" />
  <xsl:import href="static-elements.xsl" />
  <xsl:import href="date-time.xsl" />
  <xsl:output method="xml" encoding="utf-8" indent="yes" />
    
  <!-- define content type templates-->
    
  <xsl:template name="news">
    <xsl:param name="display-year" select="'no'" />
    <xsl:param name="show-date" select="'yes'" />
    <xsl:param name="compact-view" select="'no'" />
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
      <xsl:if test="$display-year = 'yes'">
        <xsl:text> </xsl:text>
        <xsl:value-of select="substring(@date,1,4)" />
      </xsl:if>
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
          <xsl:if test="$show-date = 'yes'">
            <xsl:text> (</xsl:text>
            <xsl:copy-of select="$date" />
            <xsl:text>)</xsl:text>
          </xsl:if>
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
          <xsl:if test="$show-date = 'yes'">
            <p class="date"><xsl:copy-of select="$date" /></p>
          </xsl:if>
          
          <!-- news text -->
          <xsl:if test="$compact-view = 'no'">
          <div class="text"><xsl:apply-templates select="body/node()" /></div>
          </xsl:if>
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- Show a single event -->
  <xsl:template name="event">
    <xsl:param name="header" select="''" />
    <xsl:param name="display-details" select="'no'" />
    <xsl:param name="display-year" select="'no'" />
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
      
      <!-- event map -->
      <xsl:if test="./place">
        <xsl:variable name="map-id" select="position()"/>
        <div id="map-{$map-id}" class="map"></div>
        <script type="text/javascript">
          /* &lt;![CDATA[ */
            map_init('map-<xsl:value-of select="$map-id"/>', <xsl:value-of select="./place/lat"/>, <xsl:value-of select="./place/lon"/>)
          /* ]]&gt; */
        </script>
        <noscript><!-- TODO --></noscript>
      </xsl:if>
 
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
      
		<!-- tags -->
      <xsl:if test="$display-tags = 'yes'">
			<ul class="archivetaglist">
				<!-- <xsl:apply-templates select="tags" /> /-->
				<xsl:for-each select="tags/tag[not(. = 'front-page' or @key = 'front-page')]">
					<xsl:variable name="keyname"
						select="translate(@key,'ABCDEFGHIJKLMNOPQRSTUVWXYZ /:','abcdefghijklmnopqrstuvwxyz_')" />
					<xsl:variable name="tagname"
						select="translate(.,'ABCDEFGHIJKLMNOPQRSTUVWXYZ /:','abcdefghijklmnopqrstuvwxyz_')" />
					<xsl:choose>
						<xsl:when test="@key and .">
							<li><a href="/tags/tagged-{$keyname}.html"><xsl:value-of select="." /></a></li>
							</xsl:when><xsl:when test="@content and not(@content = '')"><!-- Legacy -->
							<li><a href="/tags/tagged-{$tagname}.html"><xsl:value-of select="@content" /></a></li>
							</xsl:when><xsl:when test="@key"><!-- bad style -->
							<li><a href="/tags/tagged-{$keyname}.html"><xsl:value-of select="@key" /></a></li>
							</xsl:when>
							<xsl:otherwise><!-- Legacy and bad style-->
								<li><a href="/tags/tagged-{$tagname}.html"><xsl:value-of select="." /></a></li>
							</xsl:otherwise>
						</xsl:choose>
				</xsl:for-each>
			</ul>
		</xsl:if>

    </xsl:element>
    
  </xsl:template>

  <!-- Show a person's avatar -->
  <xsl:template name="avatar">
    <xsl:param name="id" />
    <xsl:param name="haveavatar" select="'no'" />
    <xsl:variable name="fullname">
     <xsl:value-of select="name" />
    </xsl:variable>
    <xsl:variable name="img-path">
        <xsl:choose>
                  <xsl:when test="$haveavatar='yes'"><xsl:value-of select="concat( '/about/', $id, '/', $id, '-avatar.jpg' )" /></xsl:when>
                  <xsl:otherwise>/graphics/default-avatar.png</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="alt-text">
     <xsl:choose>
       <xsl:when test="$haveavatar = 'yes'">
                  <xsl:value-of select="concat( '[ ', $fullname, ' ]' )" />
       </xsl:when>
       <xsl:otherwise>[ <xsl:call-template name="gettext">
          <xsl:with-param name="id" select="'no-avatar'" />
         </xsl:call-template> ]</xsl:otherwise>
     </xsl:choose>
    </xsl:variable>

    <xsl:element name="img">
      <xsl:attribute name="src">
        <xsl:value-of select="$img-path" />
      </xsl:attribute>
      <xsl:attribute name="alt">
        <xsl:value-of select="$alt-text" />
      </xsl:attribute>

    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
