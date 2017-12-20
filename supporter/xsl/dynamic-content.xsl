<?xml version="1.0" encoding="UTF-8"?>
<!-- Copyright (C) 2012 by Tobias Bengfort <tobias.bengfort@gmx.net> -->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" encoding="UTF-8" indent="yes" />

	<xsl:template match="partner">
		<div class="logo-list partner">

			<div class="img">
				<xsl:element name='img'>
					<xsl:attribute name='src'>
						<xsl:value-of select="./img"/>
					</xsl:attribute>
				</xsl:element>
			</div>

			<div class="cont">
				<xsl:element name='a'>
					<xsl:attribute name='href'>
						<xsl:value-of select="link"/>
					</xsl:attribute>
					<xsl:value-of select="name"/>
				</xsl:element>
			</div>

		</div>
	</xsl:template>
	
	<xsl:template match="quote">
		<div class="logo-list quote">

			<div class="img">
				<xsl:element name='img'>
					<xsl:attribute name='src'>
						<xsl:value-of select="photo"/>
					</xsl:attribute>
				</xsl:element>
			</div>

			<div class="cont">
				<p class="txt"><xsl:value-of select="txt" /></p>
				<p><span class="author"><xsl:value-of select="author" /></span>
					<span class="license"><xsl:value-of select="license"/></span>
				</p>
			</div>

		</div>
	</xsl:template>
	
	<xsl:template match="partners">
		<xsl:call-template name="dynamic-content">
			<xsl:with-param name="xpath" select="/html/set/partner" />
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="testimonials">
		<xsl:call-template name="dynamic-content">
			<xsl:with-param name="xpath" select="/html/set/quote" />
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="quotes">
		<xsl:call-template name="dynamic-content">
			<xsl:with-param name="xpath" select="/html/set/quote" />
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="dynamic-content">
		<xsl:param name="xpath" />
		<xsl:param name="tag" select="string(@tag)" />

		<div>
		<xsl:for-each select="$xpath[tags/tag=$tag or $tag='']">
			<!-- sort items without @pos to the end -->
			<xsl:sort select="number(boolean(@pos))" data-type="number" order="descending"/>
			<xsl:sort select="@pos" data-type="number" />
			<xsl:sort select="@filename" />

			<div id="{@filename}" class="dynamic-content">
				<xsl:apply-templates select="."/>
			</div>
		</xsl:for-each>
		</div>
	</xsl:template>

	<!-- Do not copy <set> and <text> to output at all -->
	<xsl:template match="/html/text" />
	<xsl:template match="set" />

	<!-- For all other nodes, copy verbatim -->
	<xsl:template match="@*|node()" priority="-1">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>

</xsl:stylesheet>
