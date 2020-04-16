<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="fsfe.xsl"/>
  <xsl:variable name="today" select="/buildinfo/@date"/>


  <!-- ==================================================================== -->
  <!-- Dynamic list of news items                                           -->
  <!-- ==================================================================== -->

  <xsl:template match="dynamic-content-news">
    <xsl:call-template name="fetch-news">
      <xsl:with-param name="tag">front-page</xsl:with-param>
      <xsl:with-param name="nb-items">3</xsl:with-param>
      <xsl:with-param name="show-date">yes</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <!-- ==================================================================== -->
  <!-- Dynamic list of testimonial quotes                                   -->
  <!-- ==================================================================== -->

  <xsl:template match="dynamic-content-testimonials">
    <xsl:for-each select="/buildinfo/document/set/quote[@frontpage]">
      <xsl:element name="a">
        <xsl:attribute name="class">column</xsl:attribute>
        <xsl:attribute name="href">/about/people/testimonials.html</xsl:attribute>

        <xsl:element name="div">
          <xsl:attribute name="class">row</xsl:attribute>

          <xsl:element name="div">
            <xsl:attribute name="class">testimonial-image</xsl:attribute>
            <xsl:element name="img">
              <xsl:attribute name="class">img-circle</xsl:attribute>
              <xsl:attribute name="src">
                <xsl:value-of select="@image"/>
              </xsl:attribute>
              <xsl:attribute name="alt">
                <xsl:value-of select="/buildinfo/document/text[@id='photograph']"/>
              </xsl:attribute>
            </xsl:element><!-- img -->
          </xsl:element><!-- div -->

          <xsl:element name="div">
            <xsl:attribute name="class">testimonial-text</xsl:attribute>
            <xsl:element name="p">
              <xsl:apply-templates select="text/node()"/>
            </xsl:element>
            <xsl:element name="p">
              <xsl:attribute name="class">source</xsl:attribute>
              <xsl:apply-templates select="name/node()"/>
            </xsl:element>
          </xsl:element><!-- div -->
        </xsl:element><!-- div -->
      </xsl:element><!-- a -->
    </xsl:for-each>
  </xsl:template>


  <!-- ==================================================================== -->
  <!-- Dynamic list of events                                               -->
  <!-- ==================================================================== -->

  <xsl:template match="dynamic-content-events">
    <xsl:element name="h3">
      <!--translated word "events"-->
      <xsl:call-template name="gettext">
        <xsl:with-param name="id" select="'events'"/>
      </xsl:call-template>
    </xsl:element>

    <xsl:element name="ul">
      <xsl:attribute name="class">list-unstyled</xsl:attribute>
      <xsl:for-each select="/buildinfo/document/set/event
        [translate (@end, '-', '') &gt;= translate ($today, '-', '')
         and (tags/tag = 'front-page')
        ]">
        <xsl:sort select="@start"/>
        <xsl:if test="position() &lt;= 3">
          <xsl:element name="li">
            <xsl:value-of select="@start"/>
            <xsl:if test="@start != @end">
              <xsl:text> – </xsl:text>
              <xsl:value-of select="@end"/>
            </xsl:if>
            <xsl:text>: </xsl:text>
            <xsl:value-of select="title"/>
          </xsl:element>
        </xsl:if>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>


  <!-- ==================================================================== -->
  <!-- Newsletter subscription block                                        -->
  <!-- ==================================================================== -->

  <xsl:template match="subscribe-nl">
    <xsl:element name="p">
      <xsl:call-template name="gettext">
        <xsl:with-param name="id" select="'subscribe-newsletter'" />
      </xsl:call-template>
    </xsl:element>
    <xsl:call-template name="subscribe-nl"/>
  </xsl:template>
</xsl:stylesheet>
