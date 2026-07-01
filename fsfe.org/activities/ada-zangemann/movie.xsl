<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="../../fsfe.xsl"/>
  <!-- ==================================================================== -->
  <!-- Dynamic list of languages                                               -->
  <!-- ==================================================================== -->
  <xsl:template match="movie-languages">
    <xsl:for-each select="/buildinfo/document/set/language">
		<xsl:sort select="@value" order="ascending"/>
		<xsl:variable name="language" select="@value"/>
		<ul>
			<li>
			<p>
				<xsl:value-of select="$language"/>
					<xsl:text>: </xsl:text>
				<xsl:for-each select="platform">
				<a>
					<xsl:attribute name="href">
						<xsl:value-of select="url"/>
					</xsl:attribute>
					<xsl:value-of select="name"/>
				</a>
				<xsl:if test="position() != last()">
					<xsl:text>, </xsl:text>
				</xsl:if>
				</xsl:for-each>
            </p>			
			</li>
		</ul>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
