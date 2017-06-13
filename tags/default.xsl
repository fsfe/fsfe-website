<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dt="http://xsltsl.org/date-time">
  
  <xsl:import href="../tools/xsltsl/events-utils.xsl" />
  <xsl:import href="../fsfe.xsl" />
  <xsl:output method="html" encoding="utf-8" indent="yes" doctype-system="about:legacy-compat" />
  
  <!-- 
    For documentation on tagging (e.g. fetching news and events), take a
    look at the documentation under
      /tools/xsltsl/tagging-documentation.txt
  -->
  
  <!-- The top level element of the input file is "buildinfo" -->
  <xsl:template match="buildinfo">
    <xsl:apply-templates select="node()"/>
  </xsl:template>
  
  <!--display dynamic list of news items-->
  <xsl:template match="tagged-news">
    <xsl:element name="ul">
      <xsl:attribute name="class">tag list</xsl:attribute>

      <xsl:for-each select="/buildinfo/document/set/news">
        <xsl:element name="li">
          <span class="newsdate">[<xsl:value-of select="@date" />]</span>
          <xsl:element name="a">
            <xsl:attribute name="href"><xsl:value-of select="link" /></xsl:attribute>
            <xsl:value-of select="title" />
          </xsl:element>
        </xsl:element>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>
  
  <!--display dynamic list of newsletters items-->
  <xsl:template match="tagged-events">
    <xsl:element name="ul">
      <xsl:attribute name="class">tag list</xsl:attribute>

      <!-- loop through all events having this tag -->
      <xsl:for-each select="/buildinfo/document/set/event">

        <xsl:element name="li">
          <span class="newsdate">[<xsl:value-of select="@start" />]</span>
          <xsl:element name="a">
            <xsl:attribute name="href">
              <xsl:call-template name="event-link">
                <xsl:with-param name="absolute-fsfe-links" select="no" />
              </xsl:call-template>
            </xsl:attribute>
            <xsl:value-of select="title" />
          </xsl:element><!--a-->
        </xsl:element><!--li-->

      </xsl:for-each>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
