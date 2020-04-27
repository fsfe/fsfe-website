<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dt="http://xsltsl.org/date-time">
  
  <xsl:import href="../fsfe.xsl" />
  <xsl:output method="html" encoding="utf-8" indent="yes" doctype-system="about:legacy-compat" />

  <!--display dynamic list of news items-->
  <xsl:template name="tagged-news" match="tagged-news">
    <xsl:element name="ul">
      <xsl:attribute name="class">tag list</xsl:attribute>

      <xsl:for-each select="/buildinfo/document/set/news[
          translate(@date, '-', '') &lt;= translate(/buildinfo/@date, '-', '')
        ]">
        <xsl:sort select="@date" order="descending" />

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
  
  <!--display dynamic list of event items-->
  <xsl:template name="tagged-events" match="tagged-events">
    <xsl:element name="ul">
      <xsl:attribute name="class">tag list</xsl:attribute>

      <!-- loop through all events having this tag -->
      <xsl:for-each select="/buildinfo/document/set/event">
        <xsl:sort select="@start" order="descending" />
        <xsl:element name="li">
          <span class="newsdate">[<xsl:value-of select="@start" />]</span>
          <xsl:element name="a">
            <xsl:attribute name="href">
              <xsl:choose>
                <xsl:when test="link">
                  <xsl:apply-templates select="link"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>/events/events.</xsl:text>
                  <xsl:value-of select="/buildinfo/@language" />
                  <xsl:text>.html#</xsl:text>
                  <xsl:value-of select="@filename" />
                </xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
            <xsl:value-of select="title" />
          </xsl:element><!--a-->
        </xsl:element><!--li-->

      </xsl:for-each>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
