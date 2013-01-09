<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" encoding="ISO-8859-1" indent="yes" />

  <!-- In /html/body node, append dynamic content -->
  <xsl:template match="/html/body">
    <xsl:copy>
      <!-- First, include what's in the source file -->
      <xsl:apply-templates />

      <!-- $today = current date (given as <html date="...">) -->
      <xsl:variable name="today">
        <xsl:value-of select="/html/@date" />
      </xsl:variable>

      <!-- Show news except those in the future, but no newsletters -->
      <xsl:for-each select="/html/set/news
        [translate (@date, '-', '') &lt;= translate ($today, '-', '') and
         not (@type = 'newsletter')]">
        <xsl:sort select="@date" order="descending" />

        <!-- This is a news entry -->
        <xsl:element name="p">

          <!-- Date and title -->
          <xsl:element name="b">
            <xsl:text>(</xsl:text>
            <xsl:value-of select="@date" />
            <xsl:text>) </xsl:text>
            <xsl:value-of select="title" />
          </xsl:element>
          <xsl:element name="br" />

          <!-- Text -->
          <xsl:apply-templates select="body/node()" />

          <!-- Link -->
          <xsl:apply-templates select="link" />

        </xsl:element>
        <!-- End news entry -->

      </xsl:for-each>
    </xsl:copy>
  </xsl:template>

  <!-- Do not copy <set> and <text> to output at all -->
  <xsl:template match="/html/set" />
  <xsl:template match="/html/text" />

  <!-- How to show a link -->
  <xsl:template match="/html/set/news/link">
    <xsl:element name="a">
      <xsl:attribute name="href">
        <xsl:value-of select="text()" />
      </xsl:attribute>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="/html/text[@id='more']" />
      <xsl:text>]</xsl:text>
    </xsl:element>
  </xsl:template>

  <!-- For all other nodes, copy verbatim -->
  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
