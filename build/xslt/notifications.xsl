<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" encoding="UTF-8" indent="yes" />

  <xsl:element name="div">
    <xsl:attribute name="id">notifications</xsl:attribute>

    <!-- Service notice (for downtime, upgrades, etc. enable this)
    <div id="service-notice">
      <div class="close">
        <a title="dismiss this notification">×</a>
      </div>

      <div class="text">
        <h1>Site currently under development</h1>

        <p>
          If you want to help out, <a
          href="/contribute/web/web.en.html">consider joining the
          web team</a>.
        </p>
      </div>
    </div>-->

    <!-- Outdated note -->
    <xsl:if test="/buildinfo/@outdated='yes'">
      <xsl:element name="div">
    <xsl:attribute name="class">alert warning red</xsl:attribute>
        <xsl:element name="a">
          <xsl:attribute name="class">close</xsl:attribute>
          <xsl:attribute name="data-dismiss">alert</xsl:attribute>
          <xsl:attribute name="href">#</xsl:attribute>
          <xsl:attribute name="aria-hidden">true</xsl:attribute>
          ×
        </xsl:element>
          <xsl:element name="p">
    <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'outdated-1'" /></xsl:call-template>
          <xsl:element name="a">
            <xsl:attribute name="href">
              <xsl:value-of select="/buildinfo/@filename"/>
              <xsl:text>.en.html</xsl:text>
            </xsl:attribute>
            <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'translator3b'" /></xsl:call-template>
          </xsl:element>.
    <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'outdated-2'" /></xsl:call-template>
      </xsl:element>
      </xsl:element>
    </xsl:if>

    <!-- Missing translation note -->
    <xsl:if test="/buildinfo/@language!=/buildinfo/document/@language">
      <xsl:element name="div">
    <xsl:attribute name="class">alert warning red</xsl:attribute>
        <xsl:element name="a">
          <xsl:attribute name="class">close</xsl:attribute>
          <xsl:attribute name="data-dismiss">alert</xsl:attribute>
          <xsl:attribute name="href">#</xsl:attribute>
          <xsl:attribute name="aria-hidden">true</xsl:attribute>
          ×
        </xsl:element>
          <xsl:element name="p">
    <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'notranslation'" /></xsl:call-template>
      </xsl:element>
      </xsl:element>
    </xsl:if>

    <!-- Info box -->
    <xsl:element name="div">
      <xsl:attribute name="id">infobox</xsl:attribute>
      <!-- Add under construction message -->
      <xsl:if test = "/buildinfo/document/head/meta[@name='under-construction' and @content='true']">
        <xsl:element name="div">
          <xsl:attribute name="class">alert warning yellow</xsl:attribute>
        <xsl:element name="a">
          <xsl:attribute name="class">close</xsl:attribute>
          <xsl:attribute name="data-dismiss">alert</xsl:attribute>
          <xsl:attribute name="href">#</xsl:attribute>
          <xsl:attribute name="aria-hidden">true</xsl:attribute>
          ×
        </xsl:element>
          <xsl:element name="p">
          <xsl:call-template name="fsfe-gettext">
            <xsl:with-param name="id" select="'under-construction'" />
          </xsl:call-template>
        </xsl:element>
      </xsl:element>
      </xsl:if>
      <!-- Add project completed message -->
      <xsl:if test = "/buildinfo/document/head/meta[@name='project-complete' and @content='true']">
        <xsl:element name="div">
          <xsl:attribute name="class">alert warning green</xsl:attribute>
        <xsl:element name="a">
          <xsl:attribute name="class">close</xsl:attribute>
          <xsl:attribute name="data-dismiss">alert</xsl:attribute>
          <xsl:attribute name="href">#</xsl:attribute>
          <xsl:attribute name="aria-hidden">true</xsl:attribute>
          ×
        </xsl:element>
          <xsl:element name="p">
          <xsl:call-template name="fsfe-gettext">
            <xsl:with-param name="id" select="'project-complete'" />
          </xsl:call-template>
        </xsl:element>
      </xsl:element>
      </xsl:if>
    </xsl:element>
                                                                                            
    <!-- Fundraising box
      <xsl:element name="div">
    <xsl:attribute name="id">fundraising</xsl:attribute>
      <xsl:element name="h2">
        <xsl:apply-templates select="/buildinfo/fundraising/call1/node()"/>
      </xsl:element>
      <xsl:element name="div">
        <xsl:attribute name="class">button</xsl:attribute>
        <xsl:apply-templates select="/buildinfo/fundraising/call2/node()"/>
      </xsl:element>
      <xsl:element name="div">
        <xsl:attribute name="class">button</xsl:attribute>
        <xsl:apply-templates select="/buildinfo/fundraising/call3/node()"/>
      </xsl:element>
      <xsl:element name="img">
        <xsl:attribute name="src">/graphics/wreath.png</xsl:attribute>
        <xsl:attribute name="alt">wreath</xsl:attribute>
        <xsl:attribute name="class">right</xsl:attribute>
      </xsl:element>
      <xsl:element name="p">
        <xsl:attribute name="class">call4</xsl:attribute>
        <xsl:apply-templates select="/buildinfo/fundraising/call4/node()"/>
      </xsl:element>
      disabling the progress bar
      <xsl:if test="/buildinfo/fundraising/current">
        <xsl:element name="div">
          <xsl:attribute name="class">percentbox</xsl:attribute>
          <xsl:element name="div">
        <xsl:attribute name="class">percentbar</xsl:attribute>
        <xsl:attribute name="style">width: 45.9%</xsl:attribute>
          </xsl:element>
        </xsl:element>
        <xsl:element name="p">
          <xsl:attribute name="class">current</xsl:attribute>
          <xsl:apply-templates select="/buildinfo/fundraising/current/node()"/>
          <xsl:text>€ 45 860</xsl:text>
        </xsl:element>
        <xsl:element name="p">
          <xsl:attribute name="class">target</xsl:attribute>
          <xsl:text>€ 100 000</xsl:text>
        </xsl:element>
      </xsl:if> c
    </xsl:element>-->
    <!-- End Fundraising box -->
  </xsl:element>

</xsl:stylesheet>
