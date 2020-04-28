<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dt="http://xsltsl.org/date-time">

  <xsl:import href="../fsfe.xsl" />
  <xsl:import href="../tools/xsltsl/date-time.xsl" />

  <!-- in /html/body node, append dynamic content -->
  <xsl:template match="/buildinfo/document/body/include-news">
    <!-- first, include what's in the source file -->
    <xsl:apply-templates />

    <!-- show news except those in the future -->
    <xsl:for-each select="/buildinfo/document/set/news[
        translate(@date, '-', '') &lt;= translate(/buildinfo/@date, '-', '')
      ]">
      <xsl:sort select="@date" order="descending" />

      <!-- begin: news entry -->
      <section class="archivenews">
        <!-- title (linked) -->
        <xsl:element name="h3">
          <xsl:call-template name="news-title"/>
        </xsl:element>
        <!-- date and author -->
        <xsl:element name="p">
          <xsl:attribute name="class">archivemeta</xsl:attribute>
          <xsl:call-template name="news-date"/>
          <xsl:if test="author">
            <xsl:text> – </xsl:text>
            <xsl:apply-templates select="author"/>
          </xsl:if>
        </xsl:element>
        <!-- text and read-more-link -->
        <p><xsl:apply-templates select="body/node()" />
        <xsl:text>&#160;</xsl:text>
        <a class="learn-more" href="{link}"></a></p>
        <!-- tags -->
        <xsl:if test="/buildinfo/document/set/news/tags/tag
                      [not(@key='front-page')]">
          <ul class="archivetaglist"><xsl:apply-templates select="tags" /></ul>
        </xsl:if>
      </section>
      <!-- end: news entry -->
    </xsl:for-each>
  </xsl:template>

  <!-- how to display: author -->
  <xsl:template match="buildinfo/document/set/news/author">
    <xsl:variable name="id" select="@id" />
    <!-- if author is in fsfe's people.xml, take information from there -->
    <xsl:choose>
      <!-- author is in people.en.xml -->
      <xsl:when test="@id and document('../about/people/people.en.xml')/personset/person[@id=$id]">
        <xsl:choose>
          <!-- person has a link -->
          <xsl:when test="document('../about/people/people.en.xml')/personset/person[@id=$id]/link">
            <a rel="author" href="{document('../about/people/people.en.xml')/personset/person[@id=$id]/link}">
              <xsl:value-of select="document('../about/people/people.en.xml')/personset/person[@id=$id]/name" />
          </a></xsl:when>
          <!-- person has no link -->
          <xsl:otherwise>
            <span>
              <xsl:value-of select="document('../about/people/people.en.xml')/personset/person[@id=$id]/name" />
          </span></xsl:otherwise></xsl:choose>
      </xsl:when>
      <!-- author is not in people.en.xml -->
      <xsl:otherwise>
        <xsl:choose>
          <!-- person has a link -->
          <xsl:when test="link">
            <a rel="author" href="{link}"><xsl:value-of select="name" /></a>
          </xsl:when>
          <!-- person has no link -->
          <xsl:otherwise>
            <span class="author p-author"><xsl:value-of select="name" />
          </span></xsl:otherwise></xsl:choose>
    </xsl:otherwise></xsl:choose>
    <xsl:if test="not(position() = last())">
      <xsl:text>, </xsl:text>
    </xsl:if>
  </xsl:template>


  <!-- how to display: tags -->
  <xsl:template match="buildinfo/document/set/news/tags">
    <xsl:for-each select="tag[not(@key='front-page')]">
      <li><a href="/tags/tagged-{@key}.{/buildinfo/@language}.html"><xsl:value-of select="." /></a></li>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
