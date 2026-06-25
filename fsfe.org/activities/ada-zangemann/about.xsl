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
					<a>
						<xsl:attribute name="href">
							<xsl:value-of select="url"/>
						</xsl:attribute>
						<xsl:value-of select="name"/>
					</a>
					<p>
						<xsl:value-of select="description"/>
					</p>
				</li>
			  </xsl:for-each>
			</ul>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
