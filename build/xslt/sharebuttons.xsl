<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template name="sharebuttons">
    <!-- normalized article title -->
    <xsl:variable name="share-title">
      <xsl:value-of select="normalize-space(head/title)" />
    </xsl:variable>
    <!-- article URL -->
    <xsl:variable name="share-url">
      <xsl:text>https:</xsl:text>
      <xsl:value-of select="$linkresources"/><xsl:value-of select="/buildinfo/@filename"/>
      <xsl:text>.html</xsl:text>
    </xsl:variable>

    <xsl:element name="form"> <!-- div containing all buttons -->
      <xsl:attribute name="action">/share</xsl:attribute>
      <xsl:attribute name="method">GET</xsl:attribute>
      <xsl:attribute name="class">share-buttons bottom</xsl:attribute>
      <xsl:attribute name="target">_blank</xsl:attribute>
      <h3>
        <xsl:call-template name="fsfe-gettext">
          <xsl:with-param name="id" select="'share-head'" />
        </xsl:call-template>
      </h3>

      <xsl:element name="input">
        <xsl:attribute name="type">radio</xsl:attribute>
        <xsl:attribute name="name">popup</xsl:attribute>
        <xsl:attribute name="id">no-share-popup</xsl:attribute>
      </xsl:element>
      <xsl:element name="input" >
        <xsl:attribute name="type">hidden</xsl:attribute>
        <xsl:attribute name="name">ref</xsl:attribute>
        <xsl:attribute name="value">bottom</xsl:attribute>
      </xsl:element>
      <xsl:element name="input" >
        <xsl:attribute name="type">hidden</xsl:attribute>
        <xsl:attribute name="name">url</xsl:attribute>
        <xsl:attribute name="value"><xsl:value-of select="$share-url"/></xsl:attribute>
      </xsl:element>
      <xsl:element name="input" >
        <xsl:attribute name="type">hidden</xsl:attribute>
        <xsl:attribute name="name">title</xsl:attribute>
        <xsl:attribute name="value"><xsl:value-of select="$share-title"/></xsl:attribute>
      </xsl:element>
      <xsl:element name="input" >
        <xsl:attribute name="class">n</xsl:attribute>
        <xsl:attribute name="name">website</xsl:attribute>
        <xsl:attribute name="placeholder">Please do not put anything here</xsl:attribute>
      </xsl:element>

      <!-- Diaspora -->
      <xsl:element name="label">
        <xsl:attribute name="class">button share-diaspora</xsl:attribute>
        <xsl:attribute name="title">
          <xsl:call-template name="fsfe-gettext">
            <xsl:with-param name="id" select="'share-page'" />
          </xsl:call-template>
          <xsl:text> Diaspora</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="for">diaspora-share-bottom</xsl:attribute>
        <xsl:text>Diaspora</xsl:text>
      </xsl:element>
      <xsl:element name="input">
        <xsl:attribute name="type">radio</xsl:attribute>
        <xsl:attribute name="name">popup</xsl:attribute>
        <xsl:attribute name="id">diaspora-share-bottom</xsl:attribute>
      </xsl:element>
      <xsl:element name="span">
        <xsl:attribute name="class">popup diaspora</xsl:attribute>
        <xsl:element name="label"><xsl:attribute name="for">no-share-popup</xsl:attribute></xsl:element>
        <xsl:element name="input">
          <xsl:attribute name="type">text</xsl:attribute>
          <xsl:attribute name="name">diasporapod</xsl:attribute>
          <xsl:attribute name="value"></xsl:attribute>
          <xsl:attribute name="placeholder">Diaspora URL (diasp.tld)</xsl:attribute>
        </xsl:element>
        <xsl:element name="button">
          <xsl:attribute name="type">submit</xsl:attribute>
          <xsl:attribute name="name">service</xsl:attribute>
          <xsl:attribute name="value">diaspora</xsl:attribute>
          <xsl:text>OK</xsl:text>
        </xsl:element>
      </xsl:element>
      <xsl:element name="wbr"/>

      <!-- GNU Social -->
      <xsl:element name="label">
        <xsl:attribute name="class">button share-gnusocial</xsl:attribute>
        <xsl:attribute name="title">
          <xsl:call-template name="fsfe-gettext">
            <xsl:with-param name="id" select="'share-page'" />
          </xsl:call-template>
          <xsl:text> GNU Social</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="for">gnusocial-share-bottom</xsl:attribute>
        <xsl:text>GNU Social</xsl:text>
      </xsl:element>
      <xsl:element name="input">
        <xsl:attribute name="type">radio</xsl:attribute>
        <xsl:attribute name="name">popup</xsl:attribute>
        <xsl:attribute name="id">gnusocial-share-bottom</xsl:attribute>
      </xsl:element>
      <xsl:element name="span">
        <xsl:attribute name="class">popup gnusocial</xsl:attribute>
        <xsl:element name="label"><xsl:attribute name="for">no-share-popup</xsl:attribute></xsl:element>
        <xsl:element name="input">
          <xsl:attribute name="type">text</xsl:attribute>
          <xsl:attribute name="name">gnusocialpod</xsl:attribute>
          <xsl:attribute name="value"></xsl:attribute>
          <xsl:attribute name="placeholder">GNU Social URL (gnusocial.tld)</xsl:attribute>
        </xsl:element>
        <xsl:element name="button">
          <xsl:attribute name="type">submit</xsl:attribute>
          <xsl:attribute name="name">service</xsl:attribute>
          <xsl:attribute name="value">gnusocial</xsl:attribute>
          <xsl:text>OK</xsl:text>
        </xsl:element>
      </xsl:element>
      <xsl:element name="wbr"/>

      <!-- Reddit -->
      <xsl:element name="button">
        <xsl:attribute name="type">submit</xsl:attribute>
        <xsl:attribute name="name">service</xsl:attribute>
        <xsl:attribute name="value">reddit</xsl:attribute>
        <xsl:attribute name="class">button share-reddit</xsl:attribute>
        <xsl:attribute name="title">
          <xsl:call-template name="fsfe-gettext">
            <xsl:with-param name="id" select="'share-page'" />
          </xsl:call-template>
          <xsl:text> Reddit</xsl:text>
        </xsl:attribute>
        <xsl:text>Reddit</xsl:text>
      </xsl:element>
      <xsl:element name="wbr"/>
      
      <!-- Flattr -->
      <xsl:element name="button">
        <xsl:attribute name="type">submit</xsl:attribute>
        <xsl:attribute name="name">service</xsl:attribute>
        <xsl:attribute name="value">flattr</xsl:attribute>
        <xsl:attribute name="class">button share-flattr</xsl:attribute>
        <xsl:attribute name="title">
          <xsl:call-template name="fsfe-gettext">
            <xsl:with-param name="id" select="'share-microdonation'" />
          </xsl:call-template>
          <xsl:text> Flattr</xsl:text>
        </xsl:attribute>
        <xsl:text>Flattr</xsl:text>
      </xsl:element>
      <xsl:element name="wbr"/>

      <!-- Hacker News -->
      <xsl:element name="button">
        <xsl:attribute name="type">submit</xsl:attribute>
        <xsl:attribute name="name">service</xsl:attribute>
        <xsl:attribute name="value">hnews</xsl:attribute>
        <xsl:attribute name="class">button share-hnews</xsl:attribute>
        <xsl:attribute name="title">
          <xsl:call-template name="fsfe-gettext">
            <xsl:with-param name="id" select="'share-page'" />
          </xsl:call-template>
          <xsl:text> Hacker News</xsl:text>
        </xsl:attribute>
        <xsl:text>Hacker News</xsl:text>
      </xsl:element>
      <xsl:element name="wbr"/>

      <!-- Twitter -->
      <xsl:element name="button">
        <xsl:attribute name="type">submit</xsl:attribute>
        <xsl:attribute name="name">service</xsl:attribute>
        <xsl:attribute name="value">twitter</xsl:attribute>
        <xsl:attribute name="class">button share-twitter</xsl:attribute>
        <xsl:attribute name="title">
          <xsl:call-template name="fsfe-gettext">
            <xsl:with-param name="id" select="'share-page'" />
          </xsl:call-template>
          <xsl:text> Twitter</xsl:text>
        </xsl:attribute>
        <xsl:text>Twitter</xsl:text>
      </xsl:element>
      <xsl:element name="wbr"/>

      <!-- Facebook -->
      <xsl:element name="button">
        <xsl:attribute name="type">submit</xsl:attribute>
        <xsl:attribute name="name">service</xsl:attribute>
        <xsl:attribute name="value">facebook</xsl:attribute>
        <xsl:attribute name="class">button share-facebook</xsl:attribute>
        <xsl:attribute name="title">
          <xsl:call-template name="fsfe-gettext">
            <xsl:with-param name="id" select="'share-page'" />
          </xsl:call-template>
          <xsl:text> Facebook</xsl:text>
        </xsl:attribute>
        <xsl:text>Facebook</xsl:text>
      </xsl:element>
      <xsl:element name="wbr"/>

      <!-- Google+ -->
      <xsl:element name="button">
        <xsl:attribute name="type">submit</xsl:attribute>
        <xsl:attribute name="name">service</xsl:attribute>
        <xsl:attribute name="value">gplus</xsl:attribute>
        <xsl:attribute name="class">button share-gplus</xsl:attribute>
        <xsl:attribute name="title">
          <xsl:call-template name="fsfe-gettext">
            <xsl:with-param name="id" select="'share-page'" />
          </xsl:call-template>
          <xsl:text> Google+</xsl:text>
        </xsl:attribute>
        <xsl:text>Google+</xsl:text>
      </xsl:element>
      <xsl:element name="wbr"/>

      <!-- Support -->
      <xsl:element name="button">
        <xsl:attribute name="type">submit</xsl:attribute>
        <xsl:attribute name="name">service</xsl:attribute>
        <xsl:attribute name="value">support</xsl:attribute>
        <xsl:attribute name="class">button share-support</xsl:attribute>
        <xsl:attribute name="title">
          <xsl:call-template name="fsfe-gettext">
            <xsl:with-param name="id" select="'support'" />
          </xsl:call-template>
        </xsl:attribute>
        <xsl:text>Support!</xsl:text>
      </xsl:element>
      <xsl:element name="wbr"/>

      <p><em>
        <xsl:call-template name="fsfe-gettext">
          <xsl:with-param name="id" select="'share-warning'" />
        </xsl:call-template>
        <xsl:text> </xsl:text>
        <a href="https://wiki.fsfe.org/Advocacy/ProprietaryWebServices">
        <xsl:call-template name="fsfe-gettext">
          <xsl:with-param name="id" select="'learn-more'" />
        </xsl:call-template>
      </a>.</em></p>
    </xsl:element> <!-- /form Social network share buttons -->
  </xsl:template>

</xsl:stylesheet>
