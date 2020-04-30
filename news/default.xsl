<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../fsfe.xsl"/>


  <!-- ==================================================================== -->
  <!-- Display the author(s) of the news item                               -->
  <!-- ==================================================================== -->

  <xsl:template match="buildinfo/document/set/news/author">
    <xsl:variable name="id" select="@id"/>
    <!-- if author is in fsfe's people.xml, take information from there -->
    <xsl:choose>
      <!-- author is in people.en.xml -->
      <xsl:when test="@id and document('../about/people/people.en.xml')/personset/person[@id=$id]">
        <xsl:choose>
          <!-- person has a link -->
          <xsl:when test="document('../about/people/people.en.xml')/personset/person[@id=$id]/link">
            <a rel="author" href="{document('../about/people/people.en.xml')/personset/person[@id=$id]/link}">
              <xsl:value-of select="document('../about/people/people.en.xml')/personset/person[@id=$id]/name"/>
          </a></xsl:when>
          <!-- person has no link -->
          <xsl:otherwise>
            <span>
              <xsl:value-of select="document('../about/people/people.en.xml')/personset/person[@id=$id]/name"/>
          </span></xsl:otherwise></xsl:choose>
      </xsl:when>
      <!-- author is not in people.en.xml -->
      <xsl:otherwise>
        <xsl:choose>
          <!-- person has a link -->
          <xsl:when test="link">
            <a rel="author" href="{link}"><xsl:value-of select="name"/></a>
          </xsl:when>
          <!-- person has no link -->
          <xsl:otherwise>
            <span class="author p-author"><xsl:value-of select="name"/>
          </span></xsl:otherwise></xsl:choose>
    </xsl:otherwise></xsl:choose>
    <xsl:if test="not(position() = last())">
      <xsl:text>, </xsl:text>
    </xsl:if>
  </xsl:template>


  <!-- ==================================================================== -->
  <!-- Display a single news item                                           -->
  <!-- ==================================================================== -->

  <xsl:template match="news">

    <!-- Wrap the news item into an <article> -->
    <xsl:element name="article">
      <xsl:attribute name="class">news</xsl:attribute>
      <xsl:attribute name="id">
        <xsl:value-of select="@filename"/>
      </xsl:attribute>

      <!-- Title with or without link -->
      <xsl:element name="h3">
        <xsl:call-template name="news-title"/>
      </xsl:element>

      <!-- Date and author -->
      <xsl:element name="p">
        <xsl:attribute name="class">meta</xsl:attribute>
        <xsl:call-template name="news-date"/>
        <xsl:if test="author">
          <xsl:text> – </xsl:text>
          <xsl:apply-templates select="author"/>
        </xsl:if>
      </xsl:element>

      <!-- Text and "read-more" link -->
      <xsl:element name="p">
        <xsl:apply-templates select="body/node()"/>
        <xsl:text>&#160;</xsl:text>
        <xsl:element name="a">
          <xsl:attribute name="class">learn-more</xsl:attribute>
          <xsl:attribute name="href">
            <xsl:value-of select="link"/>
          </xsl:attribute>
        </xsl:element><!-- a/learn-more -->
      </xsl:element><!-- p -->

      <!-- Tags -->
      <xsl:apply-templates select="tags"/>

    </xsl:element>

  </xsl:template>


  <!-- ==================================================================== -->
  <!-- Display a verbose list of events                                     -->
  <!-- ==================================================================== -->

  <xsl:template match="include-news">

    <!-- Loop through all news items except those in the future -->
    <xsl:for-each select="/buildinfo/document/set/news[
        translate(@date, '-', '') &lt;= translate(/buildinfo/@date, '-', '')
      ]">
      <xsl:sort select="@date" order="descending"/>

      <!-- Display the news items -->
      <xsl:apply-templates select="."/>

    </xsl:for-each>

  </xsl:template>

</xsl:stylesheet>
