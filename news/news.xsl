<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dt="http://xsltsl.org/date-time">

  <xsl:import href="../fsfe.xsl" />
  <xsl:import href="../tools/xsltsl/date-time.xsl" />
  <xsl:output method="html"
              encoding="utf-8"
              indent="yes"
              doctype-system="about:legacy-compat" />

  <!-- in /html/body node, append dynamic content -->
  <xsl:template match="/buildinfo/document/body/include-news">
    <!-- first, include what's in the source file -->
    <xsl:apply-templates />
    <!-- $today = current date (given as <html date="...">) -->
    <xsl:variable name="today">
      <xsl:value-of select="/buildinfo/@date" />
    </xsl:variable>

    <!-- show news except those in the future, but no newsletters -->
    <xsl:for-each select="/buildinfo/document/set/news
                          [translate (@date, '-', '') &lt;= translate ($today, '-', '')
                          and not (@type = 'newsletter')]">
      <xsl:sort select="@date" order="descending" />

      <!-- begin: news entry -->
      <section class="archivenews">
        <!-- title (linked) -->
        <h3><xsl:choose><xsl:when test="link != ''">
            <a href="{link}"><xsl:value-of select="title" /></a>
          </xsl:when><xsl:otherwise>
            <xsl:value-of select="title" />
        </xsl:otherwise></xsl:choose></h3>
        <!-- date and author -->
        <ul class="archivemeta">
          <li> <!-- date -->
            <xsl:value-of select="substring(@date,9,2)" />
            <xsl:text> </xsl:text>
            <xsl:call-template name="dt:get-month-name">
              <xsl:with-param name="month" select="substring(@date,6,2)" />
            </xsl:call-template>
            <xsl:text> </xsl:text>
            <xsl:value-of select="substring(@date,1,4)" />
          </li> <!-- author -->
          <xsl:if test="/buildinfo/document/set/news/author">
            <xsl:apply-templates select="author" />
        </xsl:if></ul>
        <!-- text and read-more-link -->
        <p><xsl:apply-templates select="body/node()" />
        <xsl:apply-templates select="link" /></p>
        <!-- tags -->
        <xsl:if test="/buildinfo/document/set/news/tags/tag
                      [not(. = 'front-page' or @key = 'front-page')]">
          <ul class="archivetaglist"><xsl:apply-templates select="tags" /></ul>
        </xsl:if>
      </section>
      <!-- end: news entry -->
    </xsl:for-each>
  </xsl:template>

  <!-- how to display: author -->
  <xsl:template match="buildinfo/document/set/news/author">
    <xsl:variable name="id" select="@id" />
    <xsl:if test="position() = 1">
      <li class="archiveauthor"><xsl:text>&#x2014;</xsl:text></li>
    </xsl:if>
    <li> <!-- if author is in fsfe's people.xml, take information from there -->
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
    </li>
  </xsl:template>

  <!-- how to display: read-more-link -->
  <xsl:template match="/buildinfo/document/set/news/link">
    <xsl:text>&#160;</xsl:text>
    <a class="learn-more" href="{text()}"></a>
  </xsl:template>

  <!-- how to display: tags -->
  <xsl:template match="buildinfo/document/set/news/tags">
    <xsl:for-each select="tag[not(. = 'front-page' or @key = 'front-page')]">
      <xsl:variable name="keyname"
                    select="translate(@key,'ABCDEFGHIJKLMNOPQRSTUVWXYZ-_+ /','abcdefghijklmnopqrstuvwxyz')" />
      <xsl:variable name="tagname"
                    select="translate(.,'ABCDEFGHIJKLMNOPQRSTUVWXYZ-_+ /','abcdefghijklmnopqrstuvwxyz')" />
      <xsl:choose>
        <xsl:when test="@key and .">
          <li><a href="/tags/tagged-{$keyname}.html"><xsl:value-of select="." /></a></li>
        </xsl:when><xsl:when test="@content and not(@content = '')"><!-- Legacy -->
          <li><a href="/tags/tagged-{$tagname}.html"><xsl:value-of select="@content" /></a></li>
        </xsl:when><xsl:when test="@key"><!-- bad style -->
          <li><a href="/tags/tagged-{$keyname}.html"><xsl:value-of select="@key" /></a></li>
        </xsl:when><xsl:otherwise><!-- Legacy and bad style -->
          <li><a href="/tags/tagged-{$tagname}.html"><xsl:value-of select="." /></a></li>
      </xsl:otherwise></xsl:choose>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>