<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template name="notifications">
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
            href="/contribute/web/web.html">consider joining the
            web team</a>.
          </p>
        </div>
      </div> -->

      <!-- Outdated note -->
      <xsl:if test="/buildinfo/@outdated='yes'">
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
            <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'outdated-1'" /></xsl:call-template>
            <xsl:element name="a">
              <xsl:attribute name="href">
                <xsl:value-of select="$urlprefix"/>
                <xsl:value-of select="/buildinfo/@filename"/>
                <xsl:text>.en.html</xsl:text>
              </xsl:attribute>
              <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'translator3b'" /></xsl:call-template>
            </xsl:element>.
            <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'outdated-2'" /></xsl:call-template>
          </xsl:element>
        </xsl:element>
      </xsl:if> <!-- End Outdated note -->

      <!-- Missing translation note -->
      <xsl:if test="/buildinfo/@language!=/buildinfo/document/@language">
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
            <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'notranslation'" /></xsl:call-template>
          </xsl:element>
        </xsl:element>
      </xsl:if> <!-- End Missing translation note -->

      <!-- Info box -->
      <xsl:element name="div">
        <xsl:attribute name="id">infobox</xsl:attribute>
        <xsl:if test = "/buildinfo/document/head/meta[@name='under-construction' and @content='true']">
          <!-- Add under construction message -->
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
      </xsl:element><!-- End Info Box -->

    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
