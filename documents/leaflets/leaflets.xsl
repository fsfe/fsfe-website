<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" encoding="ISO-8859-1" indent="yes" />

  <!-- Fill dynamic content -->
  <xsl:template match="dynamic-content">
    <xsl:variable name="type">
      <xsl:value-of select="@type"/>
    </xsl:variable>
    <xsl:element name="ul">

	<!-- Debug -->
	<!-- 
	<xsl:element name="p">
		<xsl:value-of select="@type"/>
	</xsl:element>
	-->

      <xsl:for-each select="/html/set/publication [@type = $type]">
        <xsl:sort select="name" />
        <xsl:element name="li">
          <xsl:element name="p">
	    <xsl:element name="b">
              <xsl:element name="a">
                <xsl:attribute name="href">
                  <xsl:value-of select="xhtmllink" />
                </xsl:attribute>
                <xsl:value-of select="name" />
              </xsl:element>
            </xsl:element>
            <xsl:variable name="pdflink">
              <xsl:value-of select="pdflink"/>
            </xsl:variable>
	    <xsl:if test="$pdflink!=''">
              <xsl:text> (</xsl:text>
                <xsl:element name="a">
                  <xsl:attribute name="href">
                    <xsl:value-of select="pdflink" />
                  </xsl:attribute>
                  <xsl:text>PDF</xsl:text>
                </xsl:element>
              <xsl:text>)</xsl:text>
	    </xsl:if>
            <xsl:element name="br"/>
            <xsl:value-of select="description" />
          </xsl:element>
        </xsl:element>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>
  
  <!-- Do not copy <set> to output at all -->
  <xsl:template match="set" />

  <!-- For all other nodes, copy verbatim -->
  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
