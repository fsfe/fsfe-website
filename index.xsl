<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="fsfe.xsl"/>
  <xsl:variable name="today" select="/buildinfo/@date"/>


  <!-- ==================================================================== -->
  <!-- Dynamic list of news items                                           -->
  <!-- ==================================================================== -->

  <xsl:template match="dynamic-content-news">
    <xsl:for-each select="/buildinfo/document/set/news[
      translate(@date, '-', '') &lt;= translate($today, '-', '')
      and (tags/tag = 'front-page')
      ]">
      <xsl:sort select="@date" order="descending"/>

      <xsl:if test="position() &lt;= 3">
        <xsl:element name="div">
          <xsl:attribute name="class">column</xsl:attribute>

          <xsl:element name="div">
            <xsl:attribute name="class">row</xsl:attribute>

            <!-- Image (with or without link) -->
            <xsl:element name="div">
              <xsl:attribute name="class">image</xsl:attribute>
              <xsl:choose>
                <xsl:when test="link != ''">
                  <xsl:element name="a">
                    <xsl:attribute name="href">
                      <xsl:value-of select="link"/>
                    </xsl:attribute>
                    <xsl:element name="img">
                      <xsl:attribute name="src">
                        <xsl:value-of select="image"/>
                      </xsl:attribute>
                    </xsl:element>
                  </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:element name="img">
                    <xsl:attribute name="src">
                      <xsl:value-of select="image"/>
                    </xsl:attribute>
                  </xsl:element>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:element>

            <xsl:element name="div">
              <xsl:attribute name="class">text</xsl:attribute>

              <!-- Title (with or without link) -->
              <xsl:element name="h3">
                <xsl:choose>
                  <xsl:when test="link != ''">
                    <xsl:element name="a">
                      <xsl:attribute name="href">
                        <xsl:value-of select="link"/>
                      </xsl:attribute>
                      <xsl:value-of select="title"/>
                    </xsl:element>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="title"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:element>
          
              <!-- Date -->
              <xsl:element name="p">
                <xsl:attribute name="class">date</xsl:attribute>
                <xsl:value-of select="@date"/>
              </xsl:element>
          
              <!-- Teaser -->
              <xsl:element name="div">
                <xsl:attribute name="class">teaser</xsl:attribute>
                <xsl:apply-templates select="body/node()"/>
                <xsl:if test="link != ''">
                  <xsl:text> </xsl:text>
                  <xsl:element name="a">
                    <xsl:attribute name="class">learn-more</xsl:attribute>
                    <xsl:attribute name="href">
                      <xsl:value-of select="link"/>
                    </xsl:attribute>
                  </xsl:element>
                </xsl:if>
              </xsl:element>

            </xsl:element><!-- div/text -->
          </xsl:element><!-- div/row -->
        </xsl:element><!-- div/column -->
      </xsl:if>
    </xsl:for-each>
  </xsl:template>


  <!-- ==================================================================== -->
  <!-- Dynamic list of testimonial quotes                                   -->
  <!-- ==================================================================== -->

  <xsl:template match="dynamic-content-testimonials">
    <xsl:for-each select="/buildinfo/document/set/quote[@frontpage]">
      <xsl:element name="div">
        <xsl:attribute name="class">column</xsl:attribute>

        <xsl:element name="div">
          <xsl:attribute name="class">row</xsl:attribute>

          <xsl:element name="div">
            <xsl:attribute name="class">image</xsl:attribute>

            <xsl:element name="a">
              <xsl:attribute name="href">
                <xsl:text>/about/people/testimonials.html#</xsl:text>
                <xsl:value-of select="@id"/>
              </xsl:attribute>

              <xsl:element name="img">
                <xsl:attribute name="class">img-circle</xsl:attribute>
                <xsl:attribute name="src">
                  <xsl:value-of select="@image"/>
                </xsl:attribute>
                <xsl:attribute name="alt">
                  <xsl:value-of select="/buildinfo/document/text[@id='photograph']"/>
                </xsl:attribute>
              </xsl:element><!-- img -->
            </xsl:element><!-- a -->
          </xsl:element><!-- div -->

          <xsl:element name="div">
            <xsl:attribute name="class">text</xsl:attribute>
            <xsl:element name="p">
              <xsl:apply-templates select="text/node()"/>
            </xsl:element>
            <xsl:element name="p">
              <xsl:attribute name="class">source</xsl:attribute>
              <xsl:element name="a">
                <xsl:attribute name="href">
                  <xsl:text>/about/people/testimonials.html#</xsl:text>
                  <xsl:value-of select="@id"/>
                </xsl:attribute>
                <xsl:apply-templates select="name/node()"/>
              </xsl:element>
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
      <xsl:element name="a">
        <xsl:attribute name="href">/events/index.html</xsl:attribute>
        <!--translated word "events"-->
        <xsl:call-template name="gettext">
          <xsl:with-param name="id" select="'events'"/>
        </xsl:call-template>
      </xsl:element>
    </xsl:element>

    <xsl:for-each select="/buildinfo/document/set/event
      [translate (@end, '-', '') &gt;= translate ($today, '-', '')
       and (tags/tag = 'front-page')
      ]">
      <xsl:sort select="@start"/>

      <xsl:if test="position() &lt;= 3">
        <xsl:element name="p">
          <xsl:attribute name="class">date</xsl:attribute>
          <xsl:value-of select="@start"/>
          <xsl:if test="@start != @end">
            <xsl:text> – </xsl:text>
            <xsl:value-of select="@end"/>
          </xsl:if>
        </xsl:element>

        <xsl:element name="p">
          <xsl:value-of select="title"/>
        </xsl:element>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>


  <!-- ==================================================================== -->
  <!-- Newsletter subscription block                                        -->
  <!-- ==================================================================== -->

  <xsl:template match="subscribe-nl">
    <xsl:element name="p">
      <xsl:call-template name="gettext">
        <xsl:with-param name="id" select="'subscribe-newsletter'"/>
      </xsl:call-template>
    </xsl:element>
    <xsl:call-template name="subscribe-nl"/>
  </xsl:template>
</xsl:stylesheet>
