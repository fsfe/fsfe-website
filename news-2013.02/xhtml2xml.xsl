<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

  <xsl:param name="link"/>

  <xsl:template match="/html">

    <xsl:element name="newsset">
      
      <xsl:element name="news">
	<xsl:attribute name="date">
	  <xsl:value-of select="/html/@newsdate"/>
	</xsl:attribute>

	<xsl:if test="/html/@type">
	  <xsl:attribute name ="type">
	    <xsl:value-of select="/html/@type"/>
	  </xsl:attribute>
	</xsl:if>
	
	<!-- TODO: to be removed -->
	<xsl:if test="/html/@tags">
	  <xsl:attribute name ="tags">
	    <xsl:value-of select="/html/@tags"/>
	  </xsl:attribute>
	</xsl:if>

	<xsl:element name="title">
	  <xsl:value-of select="/html/head/title"/>
	</xsl:element>

	<xsl:element name="body">
	  <xsl:value-of select="/html/body/p[@newsteaser]"/>
	</xsl:element>
	
	<xsl:element name="body-complete">
	  <xsl:copy-of select="/html/body/node()"/>
	</xsl:element>
	
	<xsl:element name="link">
	  <xsl:variable name="the_link">
	    <xsl:value-of select="/html/@link"/>
	  </xsl:variable>
	  <xsl:choose>
	    <xsl:when test="not(string($the_link))">
	      <xsl:value-of select="$link"/>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:value-of select="$the_link"/>
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:element>
	
	<xsl:copy-of select="/html/tags" />

      </xsl:element>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
