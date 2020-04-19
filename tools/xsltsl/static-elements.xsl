<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dt="http://xsltsl.org/date-time"
                xmlns:weekdays="."
                xmlns:months="."
                xmlns:nl="."
                xmlns:str='http://xsltsl.org/string'
                exclude-result-prefixes="dt weekdays months nl str">
  <xsl:import href="string.xsl" />
  
  <xsl:output method="xml" encoding="utf-8" indent="yes" />
  
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

    <xsl:variable name="lang">
      <xsl:value-of select="/buildinfo/document/@language"/>
    </xsl:variable>
    <xsl:variable name="nl-lang">
      <xsl:choose><xsl:when test="boolean(document('')/xsl:stylesheet/nl:langs/nl:lang[@value = $lang])">
	<xsl:value-of select="$lang" />
      </xsl:when><xsl:otherwise>
	<xsl:text>en</xsl:text>
      </xsl:otherwise></xsl:choose>
    </xsl:variable>
    <xsl:variable name="email">
      <xsl:call-template name="gettext"><xsl:with-param name="id" select="'email'" /></xsl:call-template>
    </xsl:variable>
    <xsl:variable name="submit">
      <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'subscribe'" /></xsl:call-template>
    </xsl:variable>

    <form id="formnl" name="formnl" method="POST" action="//lists.fsfe.org/mailman/listinfo/newsletter-{$nl-lang}">
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

      <!--<input id="email" name="email" type="email" placeholder="{$email}"/>-->
      <input id="submit" type="submit" value="{$submit}"/>
    </form>
  </xsl:template>
  
  <!-- auto generate ID for headings if doesn't already exist -->
  <xsl:template name="generate-id">
    <xsl:copy>
      <xsl:call-template name="generate-id-attribute" />
      
      <xsl:if test="@class">
          <xsl:attribute name="class">
            <xsl:value-of select="@class" />
          </xsl:attribute>      
      </xsl:if>
        
      <xsl:apply-templates select="node()"/>
  
    </xsl:copy>
  </xsl:template>
  
  
  <xsl:template name="generate-id-attribute">
    <xsl:param name="title" select="''" />
    
    <xsl:variable name="title2">
      <xsl:choose>
        <xsl:when test="normalize-space($title)=''">
          <xsl:apply-templates select="node()" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$title" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:choose>
      <xsl:when test="not(@id) or normalize-space($title)!=''">
        <!-- replace spaces with dashes -->
        <xsl:variable name="punctuation">.,:;!?&#160;&quot;'()[]&lt;&gt;>{}</xsl:variable>
        <xsl:variable name="formattedTitle1" select="translate(normalize-space(translate($title2,$punctuation,' ')),' ','-')"/>
        
        <xsl:variable   name="accents">áàâäãéèêëíìîïóòôöõúùûüçğ</xsl:variable>
        <xsl:variable name="noaccents">aaaaaeeeeiiiiooooouuuucg</xsl:variable>
        
        <xsl:variable name="formattedTitle2">
          <xsl:call-template name="str:to-lower">
            <xsl:with-param name="text" select="$formattedTitle1" />
          </xsl:call-template>
        </xsl:variable>
        
        <xsl:attribute name="id">
          <xsl:value-of select="concat('id-',translate($formattedTitle2,$accents,$noaccents))" />
        </xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="id">
          <xsl:value-of select="@id" />
        </xsl:attribute>	
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
