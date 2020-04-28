<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../fsfe.xsl" />
  <xsl:import href="../build/xslt/people.xsl" />

  <xsl:variable name="country-code">de</xsl:variable>

  <!--display labels-->

  <!--translated word "news"-->
  <xsl:template match="news-label">
    <xsl:call-template name="gettext">
      <xsl:with-param name="id" select="'news'" />
    </xsl:call-template>
  </xsl:template>

  <!--translated word "events"-->
  <xsl:template match="events-label">
    <xsl:call-template name="gettext">
      <xsl:with-param name="id" select="'events'" />
    </xsl:call-template>
  </xsl:template>

  <!--translated word "microblog"-->
  <xsl:template match="microblog-label">
    <xsl:call-template name="gettext">
      <xsl:with-param name="id" select="'microblog'" />
    </xsl:call-template>
  </xsl:template>

  <!--translated word "contact"-->
  <xsl:template match="contact-label">
    <xsl:call-template name="gettext">
      <xsl:with-param name="id" select="'contact'" />
    </xsl:call-template>
  </xsl:template>

  <!--translated word "team"-->
  <xsl:template match="team-label">
    <xsl:call-template name="gettext">
      <xsl:with-param name="id" select="'team'" />
    </xsl:call-template>
  </xsl:template>

  <!--define contact information-->

  <xsl:template match="contact-details">
    <xsl:for-each select="/buildinfo/document/set/contact">

    <xsl:if test="@id = 'DE'">

  <!-- Email -->
    <xsl:if test="email != ''">
      <xsl:element name="p">
        <xsl:value-of select="/buildinfo/textset/text[@id='email']" />
        <xsl:text> </xsl:text>
        <xsl:element name="a">
          <xsl:attribute name="href">
            <xsl:text>mailto:</xsl:text>
            <xsl:value-of select="email" />
          </xsl:attribute>
          <xsl:value-of select="email" />
        </xsl:element>
      </xsl:element>
    </xsl:if>

  <!-- Address -->
    <xsl:if test="address != ''">
     <xsl:apply-templates select="address"/>
    </xsl:if>

  <!-- Phone -->
    <xsl:if test="phone != ''">
      <xsl:element name="p">
        <xsl:value-of select="/buildinfo/textset/text[@id='phone']" />
        <xsl:text> </xsl:text>
        <xsl:value-of select="phone" />
      </xsl:element>
    </xsl:if>

  <!-- Fax -->
    <xsl:if test="fax != ''">
      <xsl:element name="p">
        <xsl:value-of select="/buildinfo/textset/text[@id='fax']" />
        <xsl:text> </xsl:text>
        <xsl:value-of select="fax" />
      </xsl:element>
    </xsl:if>
    </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!--define dynamic list of country news items-->
    <xsl:template match="country-news">
        <xsl:call-template name="fetch-news">
            <xsl:with-param name="nb-items" select="3" />
        </xsl:call-template>
    </xsl:template>

  <!--display dynamic list of event items-->
  <xsl:template match="country-events">
    <xsl:call-template name="fetch-events">
      <xsl:with-param name="nb-items" select="3" />
    </xsl:call-template>
  </xsl:template>

    <!--define dynamic list of country team members-->
    <xsl:template match="country-team-list">
        <xsl:call-template name="country-people-list">
            <xsl:with-param name="team">
                <xsl:value-of select="$country-code" />
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

</xsl:stylesheet>
