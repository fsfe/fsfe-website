<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:variable name="mode">
    <!-- here you can set the mode to switch between normal and IloveFS style -->
    <xsl:value-of select="'normal'" /> <!-- can be either 'normal' or 'valentine' -->
  </xsl:variable>

  <xsl:template name="page-head"><xsl:element name="head">
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
      <xsl:when test="$build-env = 'development'">
        <xsl:choose>
          <xsl:when test="$mode = 'valentine'">
            <xsl:element name="link">
              <xsl:attribute name="rel">stylesheet/less</xsl:attribute>
              <xsl:attribute name="media">all</xsl:attribute>
              <xsl:attribute name="href"><xsl:value-of select="$urlprefix"/>/look/valentine.less</xsl:attribute>
              <xsl:attribute name="type">text/css</xsl:attribute>
            </xsl:element>
          </xsl:when>
          <xsl:otherwise><!-- not valentine -->
            <xsl:element name="link">
              <xsl:attribute name="rel">stylesheet/less</xsl:attribute>
              <xsl:attribute name="media">all</xsl:attribute>
              <xsl:attribute name="href"><xsl:value-of select="$urlprefix"/>/look/fsfe.less</xsl:attribute>
              <xsl:attribute name="type">text/css</xsl:attribute>
            </xsl:element>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise><!-- not development -->
        <xsl:choose>
          <xsl:when test="$mode = 'valentine'">
            <xsl:element name="link">
              <xsl:attribute name="rel">stylesheet</xsl:attribute>
              <xsl:attribute name="media">all</xsl:attribute>
              <xsl:attribute name="href"><xsl:value-of select="$urlprefix"/>/look/valentine.min.css</xsl:attribute>
              <xsl:attribute name="type">text/css</xsl:attribute>
            </xsl:element>
          </xsl:when>
          <xsl:otherwise><!-- not valentine -->
            <xsl:element name="link">
              <xsl:attribute name="rel">stylesheet</xsl:attribute>
              <xsl:attribute name="media">all</xsl:attribute>
              <xsl:attribute name="href"><xsl:value-of select="$urlprefix"/>/look/fsfe.min.css</xsl:attribute>
              <xsl:attribute name="type">text/css</xsl:attribute>
            </xsl:element>
          </xsl:otherwise>
        </xsl:choose>
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
            <xsl:when test="@id and document('../../about/people/people.en.xml')/personset/person[@id=$id]">
              <xsl:value-of select="document('../../about/people/people.en.xml')/personset/person[@id=$id]/name" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="name" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </xsl:element>
    </xsl:for-each>

    <!-- Twitter and Facebook sharing cards -->
    <xsl:variable name="metaimage">
      <xsl:value-of select="image/@url" />
    </xsl:variable>

    <!-- Twitter cards -->
    <xsl:element name="meta">
      <xsl:attribute name="name">twitter:card</xsl:attribute>
      <xsl:attribute name="content">
        <xsl:choose>
          <!-- if there is a meta "image", use a large summary card -->
          <xsl:when test="$metaimage != ''">summary_large_image</xsl:when>
          <xsl:otherwise>summary</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
    </xsl:element>
    <meta name="twitter:site" content="@fsfe" />
    <xsl:element name="meta">
      <xsl:attribute name="name">twitter:image</xsl:attribute>
      <xsl:attribute name="content">
        <xsl:choose>
          <!-- if there is a meta "image", take that -->
          <xsl:when test="$metaimage != ''"><xsl:value-of select="$metaimage" /></xsl:when>
          <xsl:otherwise>
            <xsl:text>https://fsfe.org/graphics/logo-text_square.png</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
    </xsl:element>
    <xsl:element name="meta">
      <xsl:attribute name="name">twitter:title</xsl:attribute>
      <xsl:attribute name="content">
        <!-- content of <title> -->
        <xsl:value-of select="head/title" />
      </xsl:attribute>
    </xsl:element>
    <xsl:element name="meta">
      <xsl:attribute name="name">twitter:description</xsl:attribute>
      <xsl:attribute name="content">
        <xsl:value-of select="$extract" />
      </xsl:attribute>
    </xsl:element>
    <!-- Facebook sharing cards -->
    <meta property="og:type" content="article" />
    <meta property="og:site_name" content="FSFE - Free Software Foundation Europe" />
    <xsl:element name="meta">
      <xsl:attribute name="property">og:image</xsl:attribute>
      <xsl:attribute name="content">
        <xsl:choose>
          <!-- if there is a meta "image", take that -->
          <xsl:when test="$metaimage != ''"><xsl:value-of select="$metaimage" /></xsl:when>
          <xsl:otherwise>
            <xsl:text>https://fsfe.org/graphics/logo-text_square.png</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
    </xsl:element>
    <xsl:element name="meta">
      <xsl:attribute name="property">og:locale</xsl:attribute>
      <xsl:attribute name="content"><xsl:value-of select="/buildinfo/@language"/></xsl:attribute>
    </xsl:element>
    <xsl:element name="meta">
      <xsl:attribute name="property">og:url</xsl:attribute>
      <xsl:attribute name="content">https:<xsl:value-of select="$linkresources"/><xsl:value-of select="/buildinfo/@filename"/>.html</xsl:attribute>
    </xsl:element>
    <xsl:element name="meta">
      <xsl:attribute name="property">og:title</xsl:attribute>
      <xsl:attribute name="content">
        <!-- content of <title> -->
        <xsl:value-of select="head/title" />
      </xsl:attribute>
    </xsl:element>
    <xsl:element name="meta">
      <xsl:attribute name="property">og:description</xsl:attribute>
      <xsl:attribute name="content">
        <xsl:value-of select="$extract" />
      </xsl:attribute>
    </xsl:element> <!-- / Sharing cards -->

    <script src="/scripts/jquery-3.3.1.min.js"></script>
    <script src="/scripts/modernizr.custom.65251.js"></script>

    <xsl:comment><![CDATA[[if lt IE 9]>
         <script src="/scripts/html5shiv.js"></script>
         <script src="/scripts/respond.min.js"></script>
         <![endif]]]></xsl:comment>
    <xsl:comment><![CDATA[[if (lt IE 9) & (!IEMobile)]>
         <link rel="stylesheet" media="all" href="/look/ie.min.css" type="text/css">
        <![endif]]]></xsl:comment>

    <!-- Copy head element from the xhtml source file (and possibly from external xsl rules) -->
    <xsl:apply-templates select="head/node()" />
  </xsl:element></xsl:template>

</xsl:stylesheet>

