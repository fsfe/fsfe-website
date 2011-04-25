<?xml version="1.0" encoding="utf-8"?>

<!-- XSL stylesheet for generation RSS feeds.  It's currently using RSS 2.0. -->

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dt="http://xsltsl.org/date-time"
                xmlns:weekdays="."
                xmlns:months="."
                exclude-result-prefixes="dt weekdays months">

  <xsl:output method="xml" encoding="utf-8" indent="yes" />
  
  <xsl:template name="donate-link">
    
    <!--<xsl:element name="a">
      <xsl:attribute name="href" > -->
    
  </xsl:template>
  
  <xsl:template name="subscribe-nl">
    <form id="formnl" name="formnl" method="post" action="http://mail.fsfeurope.org/mailman/subscribe/newsletter-en">
      <p>
        <select id="language" name="language" onchange="var form = document.getElementById('formnl'); var sel=document.getElementById('language'); form.action='http://mail.fsfeurope.org/mailman/subscribe/newsletter-'+sel.options[sel.options.selectedIndex].value">
          <option value="en" selected="selected">English</option>
          <option value="el">Ελληνικά</option>	
          <option value="es">Español</option>
          <option value="de">Deutsch</option>
          <option value="fr">Français</option>
          <option value="it">Italiano</option>
          <option value="nl">Nederlands</option>
          <option value="pt">Português</option>
          <option value="ru">Русский</option>
          <option value="sv">Svenska</option>
        </select>
        
        <input id="email" name="email" type="email" placeholder="email address" />
        
        <xsl:call-template name="subscribe-button" />
        
      </p>
    </form>
  </xsl:template>
  
  <!--generate subscribe button in correct language-->
  <xsl:template name="subscribe-button">
    
    <xsl:variable name="submit">
      <xsl:call-template name="gettext">
        <xsl:with-param name="id" select="'subscribe'" />
      </xsl:call-template>
    </xsl:variable>
    
    <xsl:element name="input">
      <xsl:attribute name="id">submit</xsl:attribute>
      <xsl:attribute name="type">submit</xsl:attribute>
      <xsl:attribute name="value">
        <xsl:choose>
          <xsl:when test="$submit != ''">
            <xsl:value-of select="$submit" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>Submit</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
