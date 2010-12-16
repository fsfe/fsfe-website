<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:dt="http://xsltsl.org/date-time">

	<xsl:import href="../../tools/xsltsl/date-time.xsl" />
	<xsl:output method="xml" encoding="UTF-8" indent="yes" />

	
	<!--define dynamic list of country news items-->
	<xsl:template name="news-with-tag">
		<xsl:param name="tag" />
		<xsl:param name="today" select="/html/@date" />
		
		<xsl:variable name="tagcomma"><xsl:value-of select="$tag" />,</xsl:variable>
		<xsl:variable name="commatag">, <xsl:value-of select="$tag" /></xsl:variable>
		
		<xsl:for-each select="/html/set/news [translate (@date, '-', '') &lt;= translate ($today, '-', '') and
				(contains(@tags, $commatag) or
				 contains(@tags, $tagcomma) or
				 @tags=$tag) ]">
			<xsl:sort select="@date" order="descending" />
			<xsl:if test="position() &lt; 6">
				<xsl:call-template name="news" />
			</xsl:if>
		</xsl:for-each>
		
	</xsl:template>
	
	
	<!--define dynamic list of country event items-->
	<xsl:template name="events-with-tag">
		<xsl:param name="tag" />
		<xsl:param name="today" select="/html/@date" />
		
		<xsl:variable name="tagcomma"><xsl:value-of select="$tag" />,</xsl:variable>
		<xsl:variable name="commatag">, <xsl:value-of select="$tag" /></xsl:variable>
		
		<xsl:for-each select="/html/set/event [translate (@end, '-', '') &gt;= translate ($today, '-', '') and
				(contains(@tags, $commatag) or
				 contains(@tags, $tagcomma) or
				 @tags=$tag) ]">
			<xsl:sort select="@start" />
			<xsl:if test="position() &lt; 5">
				<xsl:call-template name="event" />
			</xsl:if>
		</xsl:for-each>
					
	</xsl:template>
	
	
</xsl:stylesheet>
