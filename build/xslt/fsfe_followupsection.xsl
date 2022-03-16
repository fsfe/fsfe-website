<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:nl=".">

  <!-- ==================================================================== -->
  <!-- Logic for selecting which follow-up box to show                      -->
  <!-- ==================================================================== -->

  <xsl:template name="fsfe_followupsection">
    <xsl:element name="aside">
      <xsl:attribute name="id">followup</xsl:attribute>
         <!--
         This section allows to display different "followup" boxes.
          - In the XML/XHTML file you can say that it shall show a specific box and would
            contain e.g. <followup>subscribe-nl</followup> so the page would show
            the following box.
          - if the XML page does not contain any <followup> element, there there is a default

            This has the advantage that depending on priorities, we can show
            a box in all our pages at the bottom. For instance, when we are
            in the middle of our yearly fundraising, we could set the default
            to a "fundraising" box.
         -->
      <xsl:choose>
        <!-- subscribe-nl: a box and form to sign up for newsletter -->
        <xsl:when test="/buildinfo/document/followup = 'subscribe-nl'">
          <xsl:attribute name="class">subscribe-nl</xsl:attribute>
          <xsl:element name="h2">
            <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'subscribe-newsletter'" /></xsl:call-template>
          </xsl:element>
          <xsl:call-template name="subscribe-nl" />
        </xsl:when>
        <!-- donate: link to /donate -->
        <xsl:when test="/buildinfo/document/followup = 'donate'">
          <xsl:attribute name="class">donate</xsl:attribute>
          <xsl:element name="h2">
            <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'donate'" /></xsl:call-template>
          </xsl:element>
          <xsl:element name="p">
            <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'donate-paragraph'" /></xsl:call-template>
            <br />
            <xsl:element name="a">
              <xsl:attribute name="href">https://my.fsfe.org/donate</xsl:attribute>
              <xsl:attribute name="class">btn</xsl:attribute>
              <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'donate'" /></xsl:call-template>
            </xsl:element>
          </xsl:element>
        </xsl:when>
        <!-- join: link to supporter signup -->
        <xsl:when test="/buildinfo/document/followup = 'join'">
          <xsl:attribute name="class">join</xsl:attribute>
          <xsl:element name="h2">
            <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'support/become'" /></xsl:call-template>
          </xsl:element>
          <xsl:element name="p">
            <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'support-paragraph'" /></xsl:call-template>
            <br />
            <xsl:element name="a">
              <xsl:attribute name="href">https://my.fsfe.org/support</xsl:attribute>
              <xsl:attribute name="class">btn</xsl:attribute>
              <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'support'" /></xsl:call-template>
            </xsl:element>
          </xsl:element>
        </xsl:when>
        <!-- no: hide box altogether -->
        <xsl:when test="/buildinfo/document/followup = 'no'">
          <xsl:attribute name="class">hide</xsl:attribute>
        </xsl:when>
        <!-- Default follow-up box -->
        <xsl:otherwise>
          <xsl:attribute name="class">subscribe-nl</xsl:attribute>
          <xsl:element name="h2"><xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'subscribe-newsletter'" /></xsl:call-template></xsl:element>
          <xsl:call-template name="subscribe-nl" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
    <!--/aside#followup-->
  </xsl:template>


  <!-- ==================================================================== -->
  <!-- Boxes/templates that are referenced above                            -->
  <!-- ==================================================================== -->

  <!-- subscribe-nl form and logic -->

  <!-- languages we offer as newsletter -->
  <nl:langs>
    <nl:lang value="en">English</nl:lang>
    <nl:lang value="el">Ελληνικά</nl:lang>
    <nl:lang value="es">Español</nl:lang>
    <nl:lang value="de">Deutsch</nl:lang>
    <nl:lang value="fr">Français</nl:lang>
    <nl:lang value="it">Italiano</nl:lang>
    <nl:lang value="nl">Nederlands</nl:lang>
    <nl:lang value="pt">Português</nl:lang>
    <nl:lang value="ro">Română</nl:lang>
    <nl:lang value="ru">Русский</nl:lang>
    <nl:lang value="sv">Svenska</nl:lang>
    <nl:lang value="sq">Shqip</nl:lang>
  </nl:langs>

  <xsl:template name="subscribe-nl">
    <!-- the language the visitor is on -->
    <xsl:variable name="lang">
      <xsl:value-of select="/buildinfo/document/@language"/>
    </xsl:variable>
    <!-- if the chosen language is not available as dedicated newsletter, switch to EN as default -->
    <xsl:variable name="nl-lang">
      <xsl:choose>
        <xsl:when test="boolean(document('')/xsl:stylesheet/nl:langs/nl:lang[@value = $lang])">
          <xsl:value-of select="$lang" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>en</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!-- translation for "email" -->
    <xsl:variable name="email">
      <xsl:call-template name="gettext"><xsl:with-param name="id" select="'email'" /></xsl:call-template>
    </xsl:variable>
    <!-- translation for "subscribe" -->
    <xsl:variable name="submit">
      <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'subscribe'" /></xsl:call-template>
    </xsl:variable>

    <form id="formnl" name="formnl" method="POST" action="//lists.fsfe.org/mailman/listinfo/newsletter-{$nl-lang}">
      <!-- drop-down menu for available newsletter languages -->
      <select id="language" name="language"
              class="form-control form-control-lg input-lg"
              onchange="var form = document.getElementById('formnl'); var sel=document.getElementById('language'); form.action='//lists.fsfe.org/mailman/listinfo/newsletter-'+sel.options[sel.options.selectedIndex].value">
        <xsl:for-each select="document('')/xsl:stylesheet/nl:langs/nl:lang">
          <xsl:element name="option">
            <xsl:attribute name="value">
              <xsl:value-of select="@value"/>
            </xsl:attribute>
            <xsl:if test="$nl-lang = @value">
              <xsl:attribute name="selected"/>
            </xsl:if>
            <xsl:value-of select="."/>
          </xsl:element>
        </xsl:for-each>
      </select>

      <input id="submit" type="submit" value="{$submit}"/>
    </form>
  </xsl:template>
</xsl:stylesheet>
