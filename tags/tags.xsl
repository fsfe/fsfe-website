<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dt="http://xsltsl.org/date-time">
  
  <xsl:import href="../fsfe.xsl" />
  <xsl:output method="html" encoding="utf-8" indent="yes" doctype-system="about:legacy-compat" />
  
  <!-- The top level element of the input file is "buildinfo" -->
  <xsl:template match="buildinfo">
    <xsl:apply-templates select="node()"/>
  </xsl:template>
  
  <!-- TODO: add tags that correspond to project ids -->

  <!--display dynamic list of news items-->
  <xsl:template match="all-tags-news">

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

  </xsl:template>

  
  <!--display dynamic list of newsletters items-->
  <xsl:template match="all-tags-events">
    
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


</xsl:stylesheet>
