<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:dt="http://xsltsl.org/date-time">

	<xsl:import href="feeds.xsl" />
	<xsl:import href="events-utils.xsl" />

	<xsl:output method="xml" encoding="UTF-8" indent="yes" />


	<!--display dynamic list of tagged news items-->

	<xsl:template name="fetch-news">
		<xsl:param name="tag" select="''"/>
		<xsl:param name="today" select="/buildinfo/@date" />
		<xsl:param name="nb-items" select="''" />
		<xsl:param name="display-year" select="'yes'" />
		<xsl:param name="show-date" select="'yes'" />
		<xsl:param name="compact-view" select="'no'" />

		<xsl:for-each select="/buildinfo/document/set/news[ translate (@date, '-', '') &lt;= translate ($today, '-', '')
			and (tags/tag = $tag or $tag='')
			and tags/tag != 'newsletter'
			and not( @type = 'newsletter' ) ]">
			<!-- @type != 'newsletter' is for legacy -->
			<xsl:sort select="@date" order="descending" />

			<xsl:if test="position() &lt;= $nb-items or $nb-items=''">
				<xsl:call-template name="news">
					<xsl:with-param name="show-date" select="$show-date" />
					<xsl:with-param name="compact-view" select="$compact-view" />
					<xsl:with-param name="display-year" select="$display-year" />
				</xsl:call-template>
			</xsl:if>
		</xsl:for-each>

	</xsl:template>
  

	<!--display dynamic list of (not yet tagged) newsletters items-->

	<xsl:template name="fetch-newsletters">
		<xsl:param name="today" select="/buildinfo/@date" />
		<xsl:param name="nb-items" select="''" />

		<xsl:for-each select="/buildinfo/document/set/news [translate(@date, '-', '') &lt;= translate($today, '-', '')
			and (tags/tag = 'newsletter'
			or @type = 'newsletter' ) ]">
			<!-- @type = 'newsletter' is for legacy -->
		<xsl:sort select="@date" order="descending" />

			<xsl:if test="position()&lt;= $nb-items or $nb-items=''">
				<xsl:call-template name="newsletter" />
			</xsl:if>
		</xsl:for-each>

	</xsl:template>
    

	<!--display dynamic list of tagged event items-->

	<xsl:template name="fetch-events">
		<xsl:param name="tag" select="''"/>
		<xsl:param name="today" select="/buildinfo/@date" />
		<xsl:param name="wanted-time" select="future" /> <!-- value in {"past", "present", "future"} -->
		<xsl:param name="header" select="''" />
		<xsl:param name="nb-items" select="''" />
		<xsl:param name="display-details" select="'no'" />
		<xsl:param name="display-year" select="'yes'" />

		<xsl:choose>

			<xsl:when test="$wanted-time = 'past'">
				<!-- Past events -->
				<xsl:for-each select="/buildinfo/document/set/event [translate (@end, '-', '') &lt; translate ($today, '-', '') and (tags/tag = $tag or $tag='') ]">
					<xsl:sort select="@end" order="descending" />
					<xsl:if test="position() &lt;= $nb-items or $nb-items=''">
						<xsl:call-template name="event">
							<xsl:with-param name="header" select="$header" />
							<xsl:with-param name="display-details" select="$display-details" />
							<xsl:with-param name="display-year" select="$display-year" />
						</xsl:call-template>
					</xsl:if>
				</xsl:for-each>
			</xsl:when>

			<xsl:when test="$wanted-time = 'present'">
				<!-- Current events -->
				<xsl:for-each select="/buildinfo/document/set/event
					[translate (@start, '-', '') &lt;= translate ($today, '-', '') and
					translate (@end,   '-', '') &gt;= translate ($today, '-', '') and
					(tags/tag = $tag or $tag='') ]">
					<xsl:sort select="@start" order="descending" />
					<xsl:if test="position() &lt;= $nb-items or $nb-items=''">
						<xsl:call-template name="event">
							<xsl:with-param name="header" select="$header" />
							<xsl:with-param name="display-details" select="$display-details" />
							<xsl:with-param name="display-year" select="$display-year" />
						</xsl:call-template>
					</xsl:if>
				</xsl:for-each>
			</xsl:when>

			<xsl:otherwise> <!-- if we were not told what to do, display future events -->
				<!-- Future events -->
				<xsl:for-each select="/buildinfo/document/set/event
					[translate (@start, '-', '') &gt; translate ($today, '-', '') and (tags/tag = $tag or $tag='') ]">
					<xsl:sort select="@start" />
					<xsl:if test="position() &lt;= $nb-items or $nb-items=''">
						<xsl:call-template name="event">
							<xsl:with-param name="header" select="$header" />
							<xsl:with-param name="display-details" select="$display-details" />
							<xsl:with-param name="display-year" select="$display-year" />
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
		  <xsl:attribute name="class">taglist</xsl:attribute>

			<xsl:for-each select="/buildinfo/document/set/news/tags/tag">
				<xsl:sort select="." order="ascending" />
				<xsl:variable name="thistag" select="node()" />

				<xsl:if test="generate-id() = generate-id(key('news-tags-by-value', normalize-space(.)))">
					<xsl:element name="li">
						<xsl:element name="a">
							<xsl:attribute name="href">
								<xsl:text>/tags/tagged.</xsl:text>
								<xsl:value-of select="/buildinfo/@language" />
								<xsl:text>.html#n</xsl:text>
								<xsl:value-of select="translate($thistag,' ','')" />
							</xsl:attribute>
							<xsl:value-of select="."/>
						</xsl:element>
					</xsl:element>
				</xsl:if>

			</xsl:for-each>

		</xsl:element>

		<!--
		<xsl:variable name="nbtags" select="count(
				/buildinfo/document/set/news/tags/tag[
					count( . | key( 'news-tags-by-value', . )[1] ) = 1
		])" />

		<xsl:variable name="average" select="count(/buildinfo/document/set/news/tags/tag) div $nbtags" />

		##<xsl:value-of select="$nbtags" />##<xsl:value-of select="$average" />##
		-->

		<!--
		<xsl:call-template name="append-children-tags" />
		-->

		<!--
		<xsl:for-each select="/buildinfo/document/set/news/tags/tag">
			<xsl:sort select="." order="ascending" />
			<xsl:variable name="thistag" select="node()" />
			<xsl:variable name="nb" select="count( /buildinfo/document/set/news/tags/tag[text() = $thistag]) " />

			<xsl:if test="generate-id() = generate-id(key('news-tags-by-value', normalize-space(.)))">
			  <xsl:element name="li">
				<xsl:element name="a">
				  <xsl:attribute name="href">
					<xsl:text>/tags/tagged.</xsl:text>
					<xsl:value-of select="/buildinfo/@language" />
					<xsl:text>.html#n</xsl:text>
					<xsl:value-of select="translate($thistag,' ','')" />
				  </xsl:attribute>
				  <xsl:value-of select="."/>
				</xsl:element>
			  </xsl:element>
			</xsl:if>

		</xsl:for-each>
		-->

	</xsl:template>
	
	
	<xsl:key name="events-tags-by-value" match="event/tags/tag" use="."/>

	
	<!--display dynamic list of tags used in events-->

	<xsl:template name="all-tags-events">
		
		<xsl:element name="ul">
		  <xsl:attribute name="class">taglist</xsl:attribute>

			<xsl:for-each select="/buildinfo/document/set/event/tags/tag">
				<xsl:sort select="." order="ascending" />
				<xsl:variable name="thistag" select="node()" />

				<xsl:if test="generate-id() = generate-id(key('events-tags-by-value', normalize-space(.)))">
					<xsl:element name="li">
						<xsl:element name="a">
							<xsl:attribute name="href">
								<xsl:text>/tags/tagged.</xsl:text>
								<xsl:value-of select="/buildinfo/@language" />
								<xsl:text>.html#e</xsl:text>
								<xsl:value-of select="translate($thistag,' ','')" />
							</xsl:attribute>
							<xsl:value-of select="."/>
						</xsl:element>
					</xsl:element>
				</xsl:if>

			</xsl:for-each>

		</xsl:element>
		
	</xsl:template>
	
	
	<!-- recursive, nested list of parent-region children tags -->

	<xsl:template name="append-children-tags">

		<xsl:param name="parent-region" select="''" />

		<xsl:element name="ul">

			<xsl:if test="$parent-region=''">
			  <xsl:attribute name="class">taglist</xsl:attribute>
			</xsl:if>

			<xsl:attribute name="parent-region"><xsl:value-of select="$parent-region" /></xsl:attribute>

			<xsl:for-each select="/buildinfo/document/set/tag[ (not(@parent-region) and $parent-region='') or
												 @parent-region = $parent-region ]">

				<xsl:variable name="id" select="@id" />
				<!-- <xsl:variable name="nb" select="count( /buildinfo/document/set/news/tags/tag[text() = $id]) " /> -->

				<xsl:element name="li">
					<xsl:element name="a">
						<xsl:attribute name="href">
							<xsl:text>/tags/tagged.</xsl:text>
							<xsl:value-of select="/buildinfo/@language" />
							<xsl:text>.html#n</xsl:text>
							<xsl:value-of select="translate($id,' ','')" />
						</xsl:attribute>
						<xsl:value-of select="@name"/>
					</xsl:element>

					<!-- if there are children, add them as a sublist -->
					<xsl:for-each select="/buildinfo/document/set/tag[ @parent-region = $id ]">
						<xsl:call-template name="append-children-tags">
							<xsl:with-param name="parent-region" select="$id" />
						</xsl:call-template>
					</xsl:for-each>

				</xsl:element> <!-- </li> -->

			</xsl:for-each>

		</xsl:element> <!-- </ul> -->
	  
	</xsl:template>

	
	
	
	<xsl:template name="fetch-links">

		<xsl:element name="ul">

			<xsl:for-each select="/buildinfo/document/set/link">

				<xsl:element name="li">
					<xsl:element name="a">
						<xsl:attribute name="href">
							<xsl:value-of select="href" />
						</xsl:attribute>
						<xsl:value-of select="title"/>
					</xsl:element>

					<xsl:if test="description">
						<xsl:element name="p">
							<xsl:value-of select="description"/>
						</xsl:element>
					</xsl:if>

				</xsl:element>

			</xsl:for-each>

		</xsl:element>

	</xsl:template>
	
	
	
	<!--display dynamic list of tagged news, sorted by tag -->

	<xsl:template name="tagged-news">

		<!-- loop through all tags (this complex expression loops over each tag once) -->
		<xsl:for-each select="/buildinfo/document/set/news/tags/tag[ count( . | key( 'news-tags-by-value', . )[1] ) = 1 ]">

			<xsl:sort select="." order="ascending" />

			<xsl:variable name="tag" select="." />

			<xsl:element name="div">
				<xsl:attribute name="class">tag-<xsl:value-of select="$tag" /> tag title</xsl:attribute>
				<xsl:attribute name="id">
					<xsl:text>n</xsl:text>
					<xsl:value-of select="translate($tag, ' ', '')" />
				</xsl:attribute>

				<xsl:element name="h3">
					<xsl:call-template name="generate-id-attribute" />
					<xsl:choose>
						<xsl:when test="@content">
							<xsl:value-of select="@content"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$tag" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>

				<xsl:element name="ul">
					<xsl:attribute name="class">tag-<xsl:value-of select="$tag" /> tag list</xsl:attribute>

					<!-- loop through all news having this tag -->
					<xsl:for-each select="/buildinfo/document/set/news[tags/tag = $tag]">
						<xsl:element name="li">
							<xsl:element name="a">
								<xsl:attribute name="href"><xsl:value-of select="link" /></xsl:attribute>
								<xsl:value-of select="title" />
							</xsl:element>
						</xsl:element>
					</xsl:for-each>

				</xsl:element>

			</xsl:element>

		</xsl:for-each>

	</xsl:template>
	
	
	<!--display dynamic list of tagged events, sorted by tag -->

	<xsl:template name="tagged-events">
		<xsl:param name="absolute-fsfe-links" />
		
		<!-- loop through all tags (this complex expression loops over each tag once) -->
		<xsl:for-each select="/buildinfo/document/set/event/tags/tag[ count( . | key( 'events-tags-by-value', . )[1] ) = 1 ]">
			<xsl:sort select="." order="ascending" />
			<xsl:variable name="tag" select="." />

			<xsl:element name="div">
				<xsl:attribute name="class">tag-<xsl:value-of select="$tag" /> tag title</xsl:attribute>
				<xsl:attribute name="id">
					<xsl:text>e</xsl:text>
					<xsl:value-of select="translate($tag, ' ', '')" />
				</xsl:attribute>
				<xsl:element name="h3">
					<xsl:call-template name="generate-id-attribute" />
					<xsl:choose>
						<xsl:when test="@content">
							<xsl:value-of select="@content"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$tag" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>

				<xsl:element name="ul">
					<xsl:attribute name="class">tag-<xsl:value-of select="$tag" /> tag list</xsl:attribute>

					<!-- loop through all events having this tag -->
					<xsl:for-each select="/buildinfo/document/set/event[tags/tag = $tag]">

						<xsl:element name="li">
							<xsl:element name="a">
								<xsl:attribute name="href">
									<xsl:call-template name="event-link">
										<xsl:with-param name="absolute-fsfe-links" select="$absolute-fsfe-links" />
									</xsl:call-template>
								</xsl:attribute>
								<xsl:value-of select="title" />
							</xsl:element><!--a-->
						</xsl:element><!--li-->

					</xsl:for-each>
				</xsl:element>

			</xsl:element>

		</xsl:for-each>
		
	</xsl:template>
	
</xsl:stylesheet>
