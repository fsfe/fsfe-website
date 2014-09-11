<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template name="fsfe_followupsection">
    <xsl:element name="section">
      <xsl:attribute name="id">followup</xsl:attribute>
         <!--
         TODO Okay, so the idea here is to be able to display different "followup" boxes. I would suggest doing it like this:
          - the xml page shold be able to say that it wants to show a
              specific boxe and would contain e.g.
              <followup>subscribe-newsletter</followup> so the page would show
              the following box. 
          - if the xml page does not contain any <followup> variable, then we should be able to set a default followup box on our own.
  
            This has the advantage that depending on priorities, we can show
            a box in all our pages at the bottom. For instance, when we are
            in the middle of our yearly fundraising, we could set the default
            to a "fundraising" box.
  
         For now, this is just a placeholder, so all pages show the
         "Subscribe to newsletter" box. Below that, some examples of boxes we
         should make.
         -->
      <xsl:choose>
        <xsl:when test="/buildinfo/document/followup = 'subscribe-nl'">
          <xsl:attribute name="class">subscribe-nl</xsl:attribute>
          <xsl:element name="h2"><xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'subscribe-newsletter'" /></xsl:call-template></xsl:element>
          <xsl:call-template name="subscribe-nl" />
        </xsl:when>
        <xsl:when test="/buildinfo/document/followup = 'support'">
          <xsl:attribute name="class">support</xsl:attribute>
          <xsl:element name="h2"><xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'show-support'" /></xsl:call-template></xsl:element>
          <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'show-support-paragraph'" /></xsl:call-template>
          <xsl:element name="a">
            <xsl:attribute name="href">/support/?followupbox</xsl:attribute>
            <xsl:attribute name="class">btn</xsl:attribute>
            <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'support-fsfe'" /></xsl:call-template>
          </xsl:element>
        </xsl:when>
        <xsl:when test="/buildinfo/document/followup = 'donate'">
          <xsl:attribute name="class">donate</xsl:attribute>
          <xsl:element name="h2">
            <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'donate'" /></xsl:call-template>
          </xsl:element>
          <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'donate-paragraph'" /></xsl:call-template>
          <xsl:element name="a">
            <xsl:attribute name="href">/donate/donate.html#ref-followupbox</xsl:attribute>
            <xsl:attribute name="class">btn</xsl:attribute>
            <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'donate'" /></xsl:call-template>
          </xsl:element>
        </xsl:when>
        <xsl:when test="/buildinfo/document/followup = 'join'">
          <xsl:attribute name="class">join</xsl:attribute>
          <xsl:element name="h2">
            <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'join-fellowship'" /></xsl:call-template>
          </xsl:element>
          <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'join-paragraph'" /></xsl:call-template>
          <xsl:element name="a">
            <xsl:attribute name="href">/fellowship/join.html#ref-followupbox</xsl:attribute>
            <xsl:attribute name="class">btn</xsl:attribute>
            <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'join'" /></xsl:call-template>
          </xsl:element>
        </xsl:when>
        <xsl:when test="/buildinfo/document/followup = 'no'">
          <xsl:attribute name="class">hide</xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="class">subscribe-nl</xsl:attribute>
          <xsl:element name="h2"><xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'subscribe-newsletter'" /></xsl:call-template></xsl:element>
          <xsl:call-template name="subscribe-nl" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
    <!--/section#followup-->
  </xsl:template>
</xsl:stylesheet>
