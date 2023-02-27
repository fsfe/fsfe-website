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
          <xsl:value-of select="@alt" />
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
          <xsl:with-param name="id" select="'support/become'" />
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

        <xsl:element name="blockquote">
          <xsl:attribute name="id">
            <xsl:value-of select="@id"/>
          </xsl:attribute>
          <xsl:element name="p">
            <xsl:apply-templates select="text/node()"/>
          </xsl:element>
          <xsl:element name="p">
            <xsl:element name="cite">
              <xsl:apply-templates select="name/node()"/>
            </xsl:element>
          </xsl:element>
        </xsl:element>

  </xsl:template>
</xsl:stylesheet>
