<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dt="http://xsltsl.org/date-time"
  exclude-result-prefixes="dt"
  xmlns:str="http://exslt.org/strings"
  extension-element-prefixes="str">

  <!-- HTML head -->
  <xsl:template match="head">
    <head>
      <xsl:call-template name="fsfe-head" />
    </head>
  </xsl:template>
  
  
  <xsl:template name="fsfe-head">
    
    <!-- Don't let search engine robots index untranslated pages -->
    <xsl:element name="meta">
      <xsl:attribute name="name">robots</xsl:attribute>
      <xsl:attribute name="content">
        <xsl:choose>
          <xsl:when test="/buildinfo/@language=/buildinfo/document/@language">index, follow</xsl:when>
          <xsl:otherwise>noindex</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
    </xsl:element>

    <!-- For pages used on external web servers, load the CSS from absolute URL -->
    <xsl:variable name="urlprefix">
      <xsl:if test="/buildinfo/document/@external">https://fsfe.org</xsl:if>
    </xsl:variable>

    <!-- For a mobile/tablet/etc. friendly website -->
    <xsl:element name="meta">
      <xsl:attribute name="name">viewport</xsl:attribute>
      <xsl:attribute name="content">width=device-width, initial-scale=1.0"</xsl:attribute>
    </xsl:element>

    <!--For old versions of IE-->
    <xsl:element name="meta">
      <xsl:attribute name="http-equiv">X-UA-Compatible</xsl:attribute>
      <xsl:attribute name="content">IE=edge</xsl:attribute>
    </xsl:element>
    
    <xsl:choose>
      <xsl:when test="/buildinfo/document/body[  contains( @class, 'fellowship' )  ]">
        <xsl:element name="link">
          <xsl:attribute name="rel">stylesheet</xsl:attribute>
          <xsl:attribute name="media">all</xsl:attribute>
          <xsl:attribute name="href"><xsl:value-of select="$urlprefix"/>/look/fellowship.min.css</xsl:attribute>
          <xsl:attribute name="type">text/css</xsl:attribute>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="link">
          <xsl:attribute name="rel">stylesheet</xsl:attribute>
          <xsl:attribute name="media">all</xsl:attribute>
          <xsl:attribute name="href"><xsl:value-of select="$urlprefix"/>/look/fsfe.min.css</xsl:attribute>
          <xsl:attribute name="type">text/css</xsl:attribute>
        </xsl:element>
        <xsl:if test="$mode = 'valentine'">
          <xsl:element name="link">
            <xsl:attribute name="rel">stylesheet</xsl:attribute>
            <xsl:attribute name="media">all</xsl:attribute>
            <xsl:attribute name="href"><xsl:value-of select="$urlprefix"/>/look/valentine.min.css</xsl:attribute>
            <xsl:attribute name="type">text/css</xsl:attribute>
          </xsl:element>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
    
    <xsl:element name="link">
      <xsl:attribute name="rel">stylesheet</xsl:attribute>
      <xsl:attribute name="media">print</xsl:attribute>
      <xsl:attribute name="href"><xsl:value-of select="$urlprefix"/>/look/print.css</xsl:attribute>
      <xsl:attribute name="type">text/css</xsl:attribute>
    </xsl:element>
    
    <xsl:if test="/buildinfo/@language='ar'">
      <xsl:element name="link">
        <xsl:attribute name="rel">stylesheet</xsl:attribute>
        <xsl:attribute name="media">all</xsl:attribute>
        <xsl:attribute name="href"><xsl:value-of select="$urlprefix"/>/look/rtl.css</xsl:attribute>
        <xsl:attribute name="type">text/css</xsl:attribute>
      </xsl:element>
    </xsl:if>
    
    <xsl:element name="link">
      <xsl:attribute name="rel">icon</xsl:attribute>
      <xsl:attribute name="href">
        <xsl:value-of select="$urlprefix"/>
        <xsl:choose>
          <xsl:when test="$mode = 'valentine'">/graphics/fsfev.png</xsl:when>
          <xsl:otherwise>/graphics/fsfe.ico</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:attribute name="type">image/x-icon</xsl:attribute>
    </xsl:element>
    
    <link rel="apple-touch-icon" href="{$urlprefix}/graphics/touch-icon.png" type="image/png" />
    <link rel="apple-touch-icon-precomposed" href="{$urlprefix}/graphics/touch-icon.png" type="image/png" />
    
    <xsl:element name="link">
      <xsl:attribute name="rel">alternate</xsl:attribute>
      <xsl:attribute name="title">FSFE <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'menu1/news'" /></xsl:call-template></xsl:attribute>
      <xsl:attribute name="href"><xsl:value-of select="$urlprefix"/>/news/news.<xsl:value-of select="/buildinfo/@language"/>.rss</xsl:attribute>
      <xsl:attribute name="type">application/rss+xml</xsl:attribute>
    </xsl:element>
    
    <xsl:element name="link">
      <xsl:attribute name="rel">alternate</xsl:attribute>
      <xsl:attribute name="title">FSFE <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'menu1/events'" /></xsl:call-template></xsl:attribute>
      <xsl:attribute name="href"><xsl:value-of select="$urlprefix"/>/events/events.<xsl:value-of select="/buildinfo/@language"/>.rss</xsl:attribute>
      <xsl:attribute name="type">application/rss+xml</xsl:attribute>
    </xsl:element>

    <xsl:for-each select="/buildinfo/trlist/tr">
      <xsl:sort select="@id"/>
      <xsl:element name="link">
        <xsl:attribute name="type">text/html</xsl:attribute>
        <xsl:attribute name="rel">alternate</xsl:attribute>
        <xsl:attribute name="hreflang"><xsl:value-of select="@id" /></xsl:attribute>
        <xsl:attribute name="lang"><xsl:value-of select="@id" /></xsl:attribute>
        <xsl:attribute name="href"><xsl:value-of select="/buildinfo/@filename"/>.<xsl:value-of select="@id"/>.html</xsl:attribute>
        <xsl:attribute name="title"><xsl:value-of select="."  disable-output-escaping="yes" /></xsl:attribute>
      </xsl:element>
    </xsl:for-each>
    
    <xsl:for-each select="/buildinfo/document/author">
      <xsl:variable name="id">
        <xsl:value-of select="@id" />
      </xsl:variable>
      <xsl:element name="meta">
        <xsl:attribute name="name">author</xsl:attribute>
        <xsl:attribute name="content">
          <xsl:choose>
            <xsl:when test="@id and document('about/people/people.en.xml')/personset/person[@id=$id]">
              <xsl:value-of select="document('about/people/people.en.xml')/personset/person[@id=$id]/name" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="name" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </xsl:element>
    </xsl:for-each>

    <script src="/scripts/jquery-1.10.2.min.js"></script>
    <script src="/scripts/modernizr.custom.65251.js"></script>

    <script>
      hljs.tabReplace = "  ";
//        hljs.initHighligtingOnLoad();
// above line throws error: Uncaught TypeError: Object [object Object] has no method 'initHighligtingOnLoad'
    </script>
    
    <xsl:comment><![CDATA[[if lt IE 9]>
         <script src="/scripts/html5shiv.js"></script>
         <script src="/scripts/respond.min.js"></script>
         <![endif]]]></xsl:comment>
    <xsl:comment><![CDATA[[if (lt IE 9) & (!IEMobile)]>
         <link rel="stylesheet" media="all" href="/look/ie.min.css" type="text/css">
        <![endif]]]></xsl:comment>
    
    <xsl:apply-templates select="@*|node()"/>
  </xsl:template>

</xsl:stylesheet>

