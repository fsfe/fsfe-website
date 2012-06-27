<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dt="http://xsltsl.org/date-time"
                xmlns:weekdays="."
                xmlns:months="."
                xmlns:str='http://xsltsl.org/string'
                exclude-result-prefixes="dt weekdays months">
  <xsl:import href="string.xsl" />
  
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

  <!-- auto generate ID for headings if doesn't already exist -->
  <xsl:template name="generate-id">
    <xsl:copy>
      <xsl:choose>
        <xsl:when test="not(@id)">
          
          <!-- replace spaces with dashes -->
          <xsl:variable name="punctuation">.,:;!?&#160;&quot;'()[]&lt;&gt;>{}</xsl:variable>
          <xsl:variable name="formattedTitle1" select="translate(normalize-space(translate(.,$punctuation,' ')),' ','-')"/>
          
          <xsl:variable   name="accents">áàâäéèêëíìîïóòôöúùûü</xsl:variable>
          <xsl:variable name="noaccents">aaaaeeeeiiiioooouuuu</xsl:variable>
          
          <xsl:variable name="formattedTitle2">
            <xsl:call-template name="str:to-lower">
              <xsl:with-param name="text" select="translate($formattedTitle1,$accents,$noaccents)" />
            </xsl:call-template>
          </xsl:variable>
          
          <xsl:attribute name="id">
            <xsl:value-of select="concat('id-',$formattedTitle2)" />
          </xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="id">
            <xsl:value-of select="@id" />
          </xsl:attribute>	
        </xsl:otherwise>
      </xsl:choose>
      
      <xsl:if test="@class">
          <xsl:attribute name="class">
            <xsl:value-of select="@class" />
          </xsl:attribute>      
      </xsl:if>
        
      <xsl:apply-templates select="node()"/>
  
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
