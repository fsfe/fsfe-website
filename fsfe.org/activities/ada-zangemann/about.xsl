<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="../../fsfe.xsl"/>
  <!-- ==================================================================== -->
  <!-- Dynamic list of languages for the book                                              -->
  <!-- ==================================================================== -->
  <xsl:template match="book-languages">
    <xsl:for-each select="/buildinfo/document/set/language">
		<xsl:sort select="@value" order="ascending"/>
		<xsl:variable name="language" select="@value"/>
			<p>
              <xsl:value-of select="$language"/>
            </p>
            <ul>
			  <xsl:for-each select="publisher">
				<li>
					<p>
						<xsl:call-template name="gettext">
							<xsl:with-param name="id" select="'publisher'" />
						</xsl:call-template>
					<xsl:text>: </xsl:text>
					<a>
						<xsl:attribute name="href">
							<xsl:value-of select="url"/>
						</xsl:attribute>
						<xsl:value-of select="name"/>
					</a>
					</p>
					<p>
						ISBN: <xsl:value-of select="number"/>
					</p>
					<xsl:if test="affiliate != ''">
						<p><em>
							<xsl:value-of select="affiliate"/>
						</em></p>
					</xsl:if>
				</li>
			  </xsl:for-each>
			</ul>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
