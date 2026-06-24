<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="../../fsfe.xsl"/>
  <!-- ==================================================================== -->
  <!-- Dynamic upcoming list of events                                               -->
  <!-- ==================================================================== -->
	<xsl:template match="dynamic-content-events">
	  <xsl:choose>
		<xsl:when test="/buildinfo/document/set/event[         translate (substring(@end,1,10), '-', '') &gt;= translate (/buildinfo/@date, '-', '')       ]">
		  <xsl:for-each select="/buildinfo/document/set/event[         translate (substring(@end,1,10), '-', '') &gt;= translate (/buildinfo/@date, '-', '')       ]">
			<xsl:sort select="@start"/>
			<xsl:element name="div">
			  <!-- Description -->
			  <xsl:element name="p">
				<xsl:attribute name="class">text</xsl:attribute>
				<xsl:element name="a">
				  <xsl:attribute name="href">
					<xsl:text>/events/index.html#</xsl:text>
					<xsl:value-of select="@filename"/>
				  </xsl:attribute>
				  <xsl:value-of select="title"/>
				</xsl:element>
				<xsl:element name="br"/>
				<!-- Date -->
				<xsl:element name="span">
				  <xsl:attribute name="class">date</xsl:attribute>
				  <xsl:call-template name="event-date"/>
				</xsl:element>
				<!-- p/date -->
			  </xsl:element>
			  <!-- p -->
			</xsl:element>
			<!-- div/text -->
		  </xsl:for-each>
		</xsl:when>
		<xsl:otherwise>
		  <xsl:element name="p">
			<xsl:call-template name="gettext">
			  <xsl:with-param name="id" select="'no-upcoming-events'"/>
			</xsl:call-template>
		  </xsl:element>
		</xsl:otherwise>
	  </xsl:choose>
	</xsl:template>
  <!-- ==================================================================== -->
  <!-- Dynamic past list of events                                               -->
  <!-- ==================================================================== -->
  <xsl:template match="dynamic-content-events-archive">
    <xsl:for-each select="/buildinfo/document/set/event[         translate (substring(@end,1,10), '-', '') &lt;= translate (/buildinfo/@date, '-', '')       ]">
      <xsl:sort select="@start" order="descending"/>
        <xsl:element name="div">
          <!-- Description -->
          <xsl:element name="p">
            <xsl:attribute name="class">text</xsl:attribute>
            <xsl:element name="a">
              <xsl:attribute name="href">
                <xsl:text>/events/index.html#</xsl:text>
                <xsl:value-of select="@filename"/>
              </xsl:attribute>
              <xsl:value-of select="title"/>
            </xsl:element>
            <xsl:element name="br"/>
            <!-- Date -->
            <xsl:element name="span">
              <xsl:attribute name="class">date</xsl:attribute>
              <xsl:call-template name="event-date"/>
            </xsl:element>
            <!-- p/date -->
          </xsl:element>
          <!-- p -->
        </xsl:element>
        <!-- div/text -->
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
