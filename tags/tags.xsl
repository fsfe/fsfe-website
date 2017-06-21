<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dt="http://xsltsl.org/date-time">
  
  <xsl:import href="../fsfe.xsl" />
  <xsl:output method="html" encoding="utf-8" indent="yes" doctype-system="about:legacy-compat" />
  
  <!-- The top level element of the input file is "buildinfo" -->
  <xsl:template match="buildinfo">
    <xsl:apply-templates select="node()"/>
  </xsl:template>

  <xsl:key name="news-tags" match="/buildinfo/document/set/news/tags/tag[@key]"
           use="translate(@key,'ABCDEFGHIJKLMNOPQRSTUVWXYZ-_+ /','abcdefghijklmnopqrstuvwxyz')"/>
  <xsl:key name="news-tags" match="/buildinfo/document/set/news/tags/tag[not(@key)]"
           use="translate(.,'ABCDEFGHIJKLMNOPQRSTUVWXYZ-_+ /','abcdefghijklmnopqrstuvwxyz')"/>
  <xsl:key name="event-tags" match="/buildinfo/document/set/event/tags/tag[@key]"
           use="translate(@key,'ABCDEFGHIJKLMNOPQRSTUVWXYZ-_+ /','abcdefghijklmnopqrstuvwxyz')"/>
  <xsl:key name="event-tags" match="/buildinfo/document/set/event/tags/tag[not(@key)]"
           use="translate(.,'ABCDEFGHIJKLMNOPQRSTUVWXYZ-_+ /','abcdefghijklmnopqrstuvwxyz')"/>
  
  <!-- TODO: add tags that correspond to project ids -->
  <xsl:template name="taglink">
    <xsl:param name="type"/>

    <xsl:variable name="keyname"
         select="translate(@key,'ABCDEFGHIJKLMNOPQRSTUVWXYZ-_+ /','abcdefghijklmnopqrstuvwxyz')"/>
    <xsl:variable name="tagname"
         select="translate(.,'ABCDEFGHIJKLMNOPQRSTUVWXYZ-_+ /','abcdefghijklmnopqrstuvwxyz')"/>

    <xsl:choose><xsl:when test="@key">
      <xsl:if test="generate-id() = generate-id(key($type, $keyname))">
        <li><a href="/tags/tagged-{$keyname}.html"><xsl:value-of select="."/></a></li>
      </xsl:if>
    </xsl:when><xsl:when test="@content and not(@content = '')">
      <xsl:if test="generate-id() = generate-id(key($type, $tagname))">
        <li><a href="/tags/tagged-{$tagname}.html"><xsl:value-of select="@content"/></a></li>
      </xsl:if>
    </xsl:when><xsl:otherwise>
      <xsl:if test="generate-id() = generate-id(key($type, $tagname))">
        <li><a href="/tags/tagged-{$tagname}.html"><xsl:value-of select="."/></a></li>
      </xsl:if>
    </xsl:otherwise></xsl:choose>
  </xsl:template>  

  <!--display dynamic list of news items-->
  <xsl:template match="all-tags-news">
    <ul class="taglist">
      <xsl:for-each select="/buildinfo/document/set/news/tags/tag"><xsl:sort select="." order="ascending" />
        <xsl:call-template name="taglink"><xsl:with-param name="type" select="'news-tags'"/></xsl:call-template>
      </xsl:for-each>
    </ul>
  </xsl:template>

  <!--display dynamic list of newsletters items-->
  <xsl:template match="all-tags-events">
    <ul class="taglist">
      <xsl:for-each select="/buildinfo/document/set/event/tags/tag"><xsl:sort select="." order="ascending" />
        <xsl:call-template name="taglink"><xsl:with-param name="type" select="'event-tags'"/></xsl:call-template>
      </xsl:for-each>
    </ul>
  </xsl:template>

</xsl:stylesheet>
