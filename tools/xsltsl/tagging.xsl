<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:dt="http://xsltsl.org/date-time">

	<xsl:import href="date-time.xsl" />
	<xsl:import href="feeds.xsl" />
	<xsl:output method="xml" encoding="UTF-8" indent="yes" />

	
	<!--display dynamic list of tagged news items-->
	<xsl:template name="fetch-news">
		<xsl:param name="tag" select="''"/>
		<xsl:param name="today" select="/html/@date" />
		<xsl:param name="nb-items" select="''" />
		
        <xsl:for-each select="/html/set/news[ translate (@date, '-', '') &lt;= translate ($today, '-', '') and (tags/tag = $tag or $tag='') ]">
			<xsl:sort select="@date" order="descending" />
			<xsl:if test="position() &lt;= $nb-items or $nb-items=''">
				<xsl:call-template name="news" />
			</xsl:if>
		</xsl:for-each>
		
	</xsl:template>
	
    <!--display dynamic list of (not yet tagged) newsletters items-->
    <xsl:template name="fetch-newsletters">
        <xsl:param name="today" select="/html/@date" />
        <xsl:param name="nb-items" select="''" />
        
        <xsl:for-each select="/html/set/news [translate(@date, '-', '') &lt;= translate($today, '-', '') and (@type = 'newsletter')]">
            <xsl:sort select="@date" order="descending" />
            <xsl:if test="position()&lt;= $nb-items or $nb-items=''">
                <xsl:call-template name="newsletter" />
            </xsl:if>
        </xsl:for-each>
        
    </xsl:template>
    
	<!--display dynamic list of tagged event items-->
	<xsl:template name="fetch-events">
		<xsl:param name="tag" select="''"/>
		<xsl:param name="today" select="/html/@date" />
		<xsl:param name="wanted-time" select="future" /> <!-- value in {"past", "present", "future"} -->
		<xsl:param name="header" select="''" />
		<xsl:param name="nb-items" select="''" />
		<xsl:param name="display-details" select="'no'" />
		
		<xsl:choose>
	        <xsl:when test="$wanted-time = 'past'">
	            
	            <!-- Past events -->
	            <xsl:for-each select="/html/set/event [translate (@end, '-', '') &lt; translate ($today, '-', '') and (tags/tag = $tag or $tag='') ]">
                    <xsl:sort select="@end" order="descending" />
                    <xsl:if test="position() &lt;= $nb-items or $nb-items=''">
                        <xsl:call-template name="event">
                            <xsl:with-param name="header">
                                <xsl:value-of select="$header" />
                            </xsl:with-param>
                            <xsl:with-param name="display-details" select="$display-details" />
                        </xsl:call-template>
                    </xsl:if>
                </xsl:for-each>
            
            </xsl:when>
	            
	        <xsl:when test="$wanted-time = 'present'">
	            
	            <!-- Current events -->
                <xsl:for-each select="/html/set/event
                                        [translate (@start, '-', '') &lt;= translate ($today, '-', '') and
                                        translate (@end,   '-', '') &gt;= translate ($today, '-', '') and
                                        (tags/tag = $tag or $tag='') ]">
                    <xsl:sort select="@start" order="descending" />
                    <xsl:if test="position() &lt;= $nb-items or $nb-items=''">
                        <xsl:call-template name="event">
                            <xsl:with-param name="header">
                                <xsl:value-of select="$header" />
                            </xsl:with-param>
                            <xsl:with-param name="display-details" select="$display-details" />
                        </xsl:call-template>
                    </xsl:if>
                </xsl:for-each>
	            
	        </xsl:when>
	        
	        <xsl:otherwise> <!-- if we were not told what to do, display future events -->
	            
	            <!-- Future events -->
                <xsl:for-each select="/html/set/event
                                        [translate (@start, '-', '') &gt; translate ($today, '-', '') and (tags/tag = $tag or $tag='') ]">
                    <xsl:sort select="@start" />
                    <xsl:if test="position() &lt;= $nb-items or $nb-items=''">
                        <xsl:call-template name="event">
                            <xsl:with-param name="header">
                                <xsl:value-of select="$header" />
                            </xsl:with-param>
                            <xsl:with-param name="display-details" select="$display-details" />
                        </xsl:call-template>
                    </xsl:if>
                </xsl:for-each>
	            
	        </xsl:otherwise>
	    
	    </xsl:choose>
					
	</xsl:template>
	
	
	<xsl:key name="news-tags-by-value" match="news/tags/tag" use="."/>
	
	<!--display dynamic list of tags used in news-->
	<xsl:template name="all-tags-news">
		
		<xsl:element name="ul">
		    <xsl:for-each select="/html/set/news/tags/tag">
			    <xsl:sort select="." order="ascending" />
			    
			    <xsl:variable name="thistag" select="node()" />
			    
                <xsl:if test="generate-id() = generate-id(key('news-tags-by-value', normalize-space(.)))">
                    <xsl:element name="li">
                      <xsl:value-of select="."/>
                      <xsl:text> (</xsl:text><xsl:value-of select="count( /html/set/news/tags/tag[text() = $thistag]) " /><xsl:text>)</xsl:text>
                    </xsl:element>
                </xsl:if>
			    
		    </xsl:for-each>
		</xsl:element>
		
	</xsl:template>
	
	
	<xsl:key name="events-tags-by-value" match="event/tags/tag" use="."/>
	
	<!--display dynamic list of tags used in events-->
	<xsl:template name="all-tags-events">
		
		<xsl:element name="ul">
		    <xsl:for-each select="/html/set/event/tags/tag">
			    <xsl:sort select="." order="ascending" />
			    
                <xsl:if test="generate-id() = generate-id(key('events-tags-by-value', normalize-space(.)))">
                    <xsl:element name="li">
                      <xsl:value-of select="."/>
                    </xsl:element>
                    <xsl:text>
</xsl:text>
                </xsl:if>
			    
		    </xsl:for-each>
		</xsl:element>
		
	</xsl:template>
	
	
</xsl:stylesheet>
