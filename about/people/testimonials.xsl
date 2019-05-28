<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../../fsfe.xsl"/>


  <!-- ==================================================================== -->
  <!-- Dynamic list of quotes                                               -->
  <!-- ==================================================================== -->

  <xsl:template match="dynamic-content">
    <!-- First block of quotes, before the first divider -->
    <xsl:call-template name="quote-block"/>

    <!-- Now, for each divider, ... -->
    <xsl:for-each select="/buildinfo/document/set/divider">
      <!-- ... first include the divider itself ... -->
      <xsl:apply-templates select="."/>
      <!-- ... and then then next block of quotes. -->
      <xsl:call-template name="quote-block">
        <xsl:with-param name="number" select="position()"/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>


  <!-- ==================================================================== -->
  <!-- A divider                                                            -->
  <!-- ==================================================================== -->

  <xsl:template match="/buildinfo/document/set/divider">
    <xsl:element name="figure">
      <xsl:element name="img">
        <xsl:attribute name="src">
          <xsl:value-of select="@image"/>
        </xsl:attribute>
        <xsl:attribute name="alt">
          <xsl:value-of select="normalize-space(text)"/>
        </xsl:attribute>
      </xsl:element><!-- img -->

      <xsl:element name="figcaption">
        <xsl:apply-templates select="text/node()"/>
      </xsl:element><!-- figcaption -->
    </xsl:element><!-- figure -->

    <xsl:element name="div">
      <xsl:attribute name="class">text-center</xsl:attribute>

      <xsl:element name="a">
        <xsl:attribute name="class">btn btn-success</xsl:attribute>
        <xsl:attribute name="href">https://my.fsfe.org/support</xsl:attribute>
        <xsl:call-template name="fsfe-gettext">
          <xsl:with-param name="id">support/become</xsl:with-param>
        </xsl:call-template>
      </xsl:element><!-- a -->
    </xsl:element><!-- div -->
  </xsl:template>


  <!-- ==================================================================== -->
  <!-- Number of quotes to fit between two dividers                         -->
  <!-- ==================================================================== -->

  <xsl:variable name="blocksize" select="
      ceiling(
        count(/buildinfo/document/set/quote)
        div
        (count(/buildinfo/document/set/divider) + 1)
      )
    "/>


  <!-- ==================================================================== -->
  <!-- A block of quotes between two dividers                               -->
  <!-- ==================================================================== -->

  <xsl:template name="quote-block">
    <!-- Block number 0 is the block before the first divider, block n is the
         block following the n-th divider -->
    <xsl:param name="number">0</xsl:param>

    <xsl:element name="ul">
      <xsl:attribute name="class">quote-list</xsl:attribute>
      <xsl:apply-templates select="/buildinfo/document/set/quote[
          position() &gt; $number * $blocksize
          and
          position() &lt;= ($number + 1) * $blocksize
        ]"/>
    </xsl:element>
  </xsl:template>


  <!-- ==================================================================== -->
  <!-- A single quote                                                       -->
  <!-- ==================================================================== -->

  <xsl:template match="/buildinfo/document/set/quote">
    <xsl:element name="li">
      <xsl:attribute name="id">
        <xsl:value-of select="@id"/>
      </xsl:attribute>

      <xsl:element name="div">
        <xsl:attribute name="class">with-image-right</xsl:attribute>

        <xsl:element name="img">
          <xsl:attribute name="class">img-circle</xsl:attribute>
          <xsl:attribute name="src">
            <xsl:value-of select="@image"/>
          </xsl:attribute>
          <xsl:attribute name="alt">
            <xsl:value-of select="/buildinfo/document/text[@id='photograph']"/>
          </xsl:attribute>
        </xsl:element><!-- img -->

        <xsl:element name="div">
          <xsl:element name="p">
            <xsl:apply-templates select="text/node()"/>
          </xsl:element>
          <xsl:element name="p">
            <xsl:attribute name="class">source</xsl:attribute>
            <xsl:apply-templates select="name/node()"/>
          </xsl:element>

          <!-- Optional link to interview video -->
          <xsl:if test="watch">
            <xsl:element name="p">
              <xsl:attribute name="class">complementary</xsl:attribute>
              <xsl:element name="a">
                <xsl:attribute name="href"><xsl:value-of select="watch/@link"/></xsl:attribute>
                <xsl:element name="span">
                  <xsl:attribute name="class">fa fa-video-camera fa-lg</xsl:attribute>
                </xsl:element>
                <xsl:text> </xsl:text>
                <xsl:apply-templates select="watch/node()"/>
              </xsl:element><!-- a -->
            </xsl:element><!-- p -->
          </xsl:if>

          <!-- Optional link to interview text -->
          <xsl:if test="read">
            <xsl:element name="p">
              <xsl:attribute name="class">complementary</xsl:attribute>
              <xsl:element name="a">
                <xsl:attribute name="href"><xsl:value-of select="read/@link"/></xsl:attribute>
                <xsl:element name="span">
                  <xsl:attribute name="class">fa fa-microphone fa-lg</xsl:attribute>
                </xsl:element>
                <xsl:text> </xsl:text>
                <xsl:apply-templates select="read/node()"/>
              </xsl:element><!-- a -->
            </xsl:element><!-- p -->
          </xsl:if>
        </xsl:element><!-- div -->
      </xsl:element><!-- div -->
    </xsl:element><!-- li -->
  </xsl:template>
</xsl:stylesheet>
