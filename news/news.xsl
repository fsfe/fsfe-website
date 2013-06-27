<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../fsfe.xsl" />
  <xsl:output method="html" encoding="utf-8" indent="yes" doctype-system="about:legacy-compat" />

  <!-- In /html/body node, append dynamic content -->
  <xsl:template match="body">
      <!-- First, include what's in the source file -->
      <xsl:apply-templates />

      <!-- $today = current date (given as <html date="...">) -->
      <xsl:variable name="today">
        <xsl:value-of select="/buildinfo/@date" />
      </xsl:variable>

      <!-- Show news except those in the future, but no newsletters -->
      <xsl:for-each select="/buildinfo/document/set/news
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
	  
	  <!-- Flattr Link -->
	  <xsl:element name="a">
	    <xsl:attribute name="href">
	      https://flattr.com/submit/auto?user_id=fsfe\
		&amp;url=<xsl:value-of select="text()" />\
		&amp;title=<xsl:value-of select="title" />\
		&amp;description=<xsl:apply-templates select="body/node()" />\
		&amp;language=en\
		&amp;tags=news\
		&amp;category=text
	    </xsl:attribute>
	    <xsl:text>Flattr<xsl:text>
	  </xsl:element>
          <xsl:element name="br" />

          <!-- Text -->
          <xsl:apply-templates select="body/node()" />

          <!-- Link -->
          <xsl:apply-templates select="link" />

        </xsl:element>
        <!-- End news entry -->

      </xsl:for-each>
  </xsl:template>

  <!-- How to show a link -->
  <xsl:template match="/buildinfo/document/set/news/link">
    <xsl:element name="a">
      <xsl:attribute name="href">
        <xsl:value-of select="text()" />
      </xsl:attribute>
      <xsl:text>[</xsl:text>
        <xsl:value-of select="/buildinfo/document/text[@id='more']" />
      <xsl:text>]</xsl:text>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
