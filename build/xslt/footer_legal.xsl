<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" encoding="UTF-8" indent="yes" />

  <xsl:element name="section">
    <xsl:attribute name="id">legal-info</xsl:attribute>

    <p>Copyright © 2001-2014 <a href="/"><xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'fsfeurope'" /></xsl:call-template></a>.</p>
    <ul>
      <li><a href="/contact/contact.html"> <xsl:call-template
            name="fsfe-gettext"><xsl:with-param name="id"
              select="'contact-us'" /></xsl:call-template></a></li>
      <li><a href="/about/legal/imprint.html"> <xsl:call-template
            name="fsfe-gettext"><xsl:with-param name="id"
              select="'imprint'" /></xsl:call-template> </a> /
        <a href="/about/legal/imprint.html#id-privacy-policy" class="privacy-policy"> <xsl:call-template
            name="fsfe-gettext"><xsl:with-param name="id"
              select="'privacy-policy'" /></xsl:call-template> </a> </li>
    </ul>
    <p><xsl:call-template name="fsfe-gettext"><xsl:with-param name="id"
          select="'permission'" /></xsl:call-template></p>
  </xsl:element>
</xsl:stylesheet>
