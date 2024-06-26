<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="fsfe.xsl"/>


  <!-- ==================================================================== -->
  <!-- Dynamic list of news items                                           -->
  <!-- ==================================================================== -->

  <xsl:template match="dynamic-content-highlights">
    <xsl:for-each select="/buildinfo/document/set/news[
        translate(@date, '-', '') &lt;= translate(/buildinfo/@date, '-', '') and
        tags/tag/@key = 'highlights'
      ]">
      <xsl:sort select="@date" order="descending"/>
      <xsl:if test="position() &lt;= 3">
        <xsl:element name="div">
          <xsl:attribute name="class">column</xsl:attribute>
          <xsl:element name="div">
            <xsl:attribute name="class">row</xsl:attribute>

            <!-- Image (with or without link) -->
            <xsl:element name="div">
              <xsl:attribute name="class">image <xsl:value-of select="tags/tag[1]/@key"/></xsl:attribute>
              <xsl:call-template name="news-image"/>
            </xsl:element><!-- div/image -->

            <xsl:element name="div">
              <xsl:attribute name="class">text</xsl:attribute>

              <!-- Title (with or without link) -->
              <xsl:element name="h3">
                <xsl:call-template name="news-title"/>
              </xsl:element><!-- h3 -->
              <!-- Date -->
              <xsl:element name="p">
                <xsl:attribute name="class">tag</xsl:attribute>
                <xsl:value-of select="tags/tag[1]"/>
              </xsl:element><!-- p/tag -->

              <!-- Teaser -->
              <xsl:call-template name="news-teaser"/>

            </xsl:element><!-- div/text -->

          </xsl:element><!-- div/row -->
        </xsl:element><!-- div/column -->
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="dynamic-content-news">
    <xsl:for-each select="/buildinfo/document/set/news[
        translate(@date, '-', '') &lt;= translate(/buildinfo/@date, '-', '')
      ]">
      <xsl:sort select="@date" order="descending"/>
      <xsl:if test="position() &lt;= 3">
        <xsl:element name="div">
          <xsl:element name="p">
            <xsl:attribute name="class">text</xsl:attribute>
            <xsl:element name="a">
              <xsl:attribute name="href"><xsl:value-of select="link"/></xsl:attribute>
              <xsl:value-of select="title"/>

              <xsl:value-of select="news-teaser"/>
            </xsl:element>
            <xsl:element name="br"/>
            <xsl:element name="span">
              <xsl:attribute name="class">date</xsl:attribute>
              <xsl:value-of select="@date"/>
            </xsl:element>
          </xsl:element>
        </xsl:element>
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

          <!-- Image with link -->
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
          </xsl:element><!-- div/image -->

          <!-- Text and source -->
          <xsl:element name="div">
            <xsl:attribute name="class">text</xsl:attribute>
            <xsl:element name="p">
              <xsl:apply-templates select="text/node()"/>
            </xsl:element><!-- p -->
            <xsl:element name="p">
              <xsl:attribute name="class">source</xsl:attribute>
              <xsl:element name="a">
                <xsl:attribute name="href">
                  <xsl:text>/about/people/testimonials.html#</xsl:text>
                  <xsl:value-of select="@id"/>
                </xsl:attribute>
                <xsl:apply-templates select="name/node()"/>
              </xsl:element><!-- a -->
            </xsl:element><!-- p/source -->
          </xsl:element><!-- div/text -->

        </xsl:element><!-- div/row -->
      </xsl:element><!-- div/column -->
    </xsl:for-each>
  </xsl:template>


  <!-- ==================================================================== -->
  <!-- Dynamic list of events                                               -->
  <!-- ==================================================================== -->

  <xsl:template match="dynamic-content-events">
    <xsl:for-each select="/buildinfo/document/set/event[
        translate (@end, '-', '') &gt;= translate (/buildinfo/@date, '-', '')
      ]">
      <xsl:sort select="@start"/>
      <xsl:if test="position() &lt;= 3">
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
              </xsl:element><!-- p/date -->

            </xsl:element><!-- p -->

          </xsl:element><!-- div/text -->

      </xsl:if>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
