<?xml version="1.0" encoding="ISO-8859-1"?>

<!-- XSL stylesheet for generating RSS feeds. We use RSS 0.91 for now -->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" encoding="UTF-8" indent="yes" />
  
  
  <!-- how an event link should look like -->
  <xsl:template name="event-link">
    
    <xsl:param name="absolute-fsfe-links" select="'yes'" /> <!-- yes: http://fsfe.org/events/events.en.html#…
                                                                 no:  /events/events.en.html#…                 -->
    
    <xsl:variable name="lang" select="/buildinfo/@language" />
    
    <!-- Link -->
    <xsl:choose>
      
      <!-- link is already given → normalise it -->
      <xsl:when test="link != ''">
        
        <xsl:variable name="link">
          <xsl:apply-templates select="link">
            <xsl:with-param name="lang" select="$lang"/>
            <xsl:with-param name="absolute-fsfe-links" select="$absolute-fsfe-links"/>
          </xsl:apply-templates>
        </xsl:variable>
        
        <xsl:value-of select="normalize-space($link)"/>
        
      </xsl:when>
      
      <!-- link is not present, link to events.html#… -->
      <xsl:otherwise>
        
        <xsl:if test="$absolute-fsfe-links = 'yes'">
          <xsl:text>http://fsfe.org</xsl:text>
        </xsl:if>
        
        <xsl:text>/events/events.</xsl:text>
        <xsl:value-of select="$lang" />
        <xsl:text>.html#</xsl:text>
        
        <!-- anchor value -->
        <xsl:value-of select="@filename" />
        
      </xsl:otherwise>
      
    </xsl:choose>
    
  </xsl:template>
  
  
  
  <!-- ============= -->
  <!-- Link handling -->
  <!-- ============= -->

  <xsl:template match="link">
    <xsl:param name="lang" />
    <xsl:param name="absolute-fsfe-links" />
    
    <!-- Original link text -->
    <!-- We remove leading "http://fsfe.org" by default -->
    <xsl:variable name="link">
      <xsl:choose>
        <xsl:when test="starts-with (normalize-space(.), 'http://fsfe.org')">
          <xsl:value-of select="substring-after(normalize-space(.), 'http://fsfe.org')" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="normalize-space(.)" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <!-- Add leading "http://fsfe.org" if necessary -->
    <xsl:variable name="full-link">
      <xsl:choose>
        
        <xsl:when test="starts-with ($link, 'http:')">
          <xsl:value-of select="$link" />
        </xsl:when>
        
        <xsl:when test="starts-with ($link, 'https:')">
          <xsl:value-of select="$link" />
        </xsl:when>
        
        <xsl:when test="$absolute-fsfe-links != 'yes'">
          <xsl:value-of select="$link" />
        </xsl:when>
        
        <xsl:otherwise>
          <xsl:text>http://fsfe.org</xsl:text>
          <xsl:value-of select="$link" />
        </xsl:otherwise>
        
      </xsl:choose>
      
    </xsl:variable>
    
    <!-- Insert language into link -->
    <xsl:choose>
      <xsl:when test="starts-with ($full-link, 'http://fsfe.org/')
                      and substring-before ($full-link, '.html') != ''">
        <xsl:value-of select="concat (substring-before ($full-link, '.html'),
                                      '.', $lang, '.html')" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$full-link" />
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>
  
  
  
</xsl:stylesheet>
