<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:import href="../tools/xsltsl/translations.xsl" />
  <xsl:import href="../tools/xsltsl/static-elements.xsl" />
  
  <xsl:import href="../fsfe.xsl" />
  <xsl:output method="html" encoding="utf-8" indent="yes" doctype-system="about:legacy-compat" />

  <xsl:template match="body">
    <xsl:apply-templates />

    <!-- $today = current date (given as <html date="...">) -->
    <xsl:variable name="today">
      <xsl:value-of select="/buildinfo/@date" />
    </xsl:variable>

    <xsl:for-each select="/buildinfo/document/set/news[translate(@date,'-','') &lt;= translate($today,'-','')]">
      <xsl:sort select="@date" order="descending"/>
      <p>
        <b><xsl:value-of select="@date" /></b><br/>
        <xsl:value-of select="body"/>
        <xsl:variable name="link"><xsl:value-of select="link"/></xsl:variable>
        <xsl:if test="$link!=''">
          &#160;<a href="{link}" class="learn-more"><xsl:value-of select="/buildinfo/document/text[@id='more']"/></a>
        </xsl:if>
      </p>
    </xsl:for-each>
  </xsl:template>
  
  <!--translated sentence "receive-newsletter"-->
  <xsl:template match="receive-newsletter">
    <xsl:call-template name="gettext">
      <xsl:with-param name="id" select="'receive-newsletter'" />
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template match="subscribe-nl">
    <xsl:call-template name="subscribe-nl" />
  </xsl:template>
  
</xsl:stylesheet>

