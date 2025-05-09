<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:variable name="mode">
    <!-- here you can set the mode to switch between normal and IloveFS style -->
    <xsl:value-of select="'normal'" /> <!-- can be either 'normal' or 'valentine' -->
  </xsl:variable>

  <!-- Take /head/title and append " - FSFE", use this as $title -->
  <xsl:variable name="title">
    <xsl:choose>
      <!-- On frontpage, use just <title> to allow custom display -->
      <xsl:when test="/buildinfo/document/body/@class = 'frontpage'">
        <xsl:value-of select="/buildinfo/document/head/title/text()" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="/buildinfo/document/head/title/text()" />
        <xsl:text> - </xsl:text>
        <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'fsfe'" /></xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- Replace head/title with the version where " - FSFE" has been appended -->
  <xsl:template match="head/title">
    <xsl:copy>
      <xsl:value-of select="$title"/>
    </xsl:copy>
  </xsl:template>

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
          <xsl:attribute name="href"><xsl:value-of select="$urlprefix"/>/look/fsfe.min.css?20230215</xsl:attribute>
          <xsl:attribute name="type">text/css</xsl:attribute>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:element name="link">
      <xsl:attribute name="rel">stylesheet</xsl:attribute>
      <xsl:attribute name="media">print</xsl:attribute>
      <xsl:attribute name="href"><xsl:value-of select="$urlprefix"/>/look/print.css</xsl:attribute>
      <xsl:attribute name="type">text/css</xsl:attribute>
    </xsl:element>

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
        <xsl:attribute name="href"><xsl:value-of select="/buildinfo/@fileurl"/>.<xsl:value-of select="@id"/>.html</xsl:attribute>
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
            <xsl:when test="@id and document('../../fsfe.org/about/people/people.en.xml')/personset/person[@id=$id]">
              <xsl:value-of select="document('../../fsfe.org/about/people/people.en.xml')/personset/person[@id=$id]/name" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="name" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </xsl:element>
    </xsl:for-each>

    <!-- Meta description -->
    <xsl:element name="meta">
      <xsl:attribute name="name">description</xsl:attribute>
      <xsl:attribute name="content">
        <xsl:value-of select="$extract" />
      </xsl:attribute>
    </xsl:element> <!-- / meta description -->

    <!-- Twitter and Facebook sharing cards -->
    <xsl:variable name="metaimage">
      <xsl:if test="image/@url">
        <xsl:choose>
          <xsl:when test="starts-with(image/@url, 'http')">
            <xsl:value-of select="image/@url" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>https://fsfe.org</xsl:text><xsl:value-of select="image/@url" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
    </xsl:variable>

    <!-- Mastodon link to profile -->
    <xsl:element name="meta">
      <xsl:attribute name="name">fediverse:creator</xsl:attribute>
      <xsl:attribute name="content">@fsfe@mastodon.social</xsl:attribute>
    </xsl:element>

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
    <xsl:if test="image/@alt"> <!-- add alt text if existent -->
      <xsl:element name="meta">
        <xsl:attribute name="name">twitter:image:alt</xsl:attribute>
        <xsl:attribute name="content">
          <xsl:value-of select="image/@alt" />
        </xsl:attribute>
      </xsl:element>
    </xsl:if>
    <xsl:element name="meta">
      <xsl:attribute name="name">twitter:title</xsl:attribute>
      <xsl:attribute name="content">
        <!-- content of <title> -->
        <xsl:value-of select="$title" />
      </xsl:attribute>
    </xsl:element>
    <xsl:element name="meta">
      <xsl:attribute name="name">twitter:description</xsl:attribute>
      <xsl:attribute name="content">
        <xsl:value-of select="$extract" />
      </xsl:attribute>
    </xsl:element>
    <!-- OpenGraph sharing cards -->
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
    <xsl:if test="image/@alt"> <!-- add alt text if existent -->
    <xsl:element name="meta">
      <xsl:attribute name="property">og:image:alt</xsl:attribute>
      <xsl:attribute name="content">
        <xsl:value-of select="image/@alt" />
      </xsl:attribute>
    </xsl:element>
  </xsl:if>
    <xsl:element name="meta">
      <xsl:attribute name="property">og:locale</xsl:attribute>
      <xsl:attribute name="content"><xsl:value-of select="/buildinfo/@language"/></xsl:attribute>
    </xsl:element>
    <xsl:element name="meta">
      <xsl:attribute name="property">og:url</xsl:attribute>
      <xsl:attribute name="content">https://fsfe.org<xsl:value-of select="/buildinfo/@fileurl"/>.html</xsl:attribute>
    </xsl:element>
    <xsl:element name="meta">
      <xsl:attribute name="property">og:title</xsl:attribute>
      <xsl:attribute name="content">
        <!-- content of <title> -->
        <xsl:value-of select="$title" />
      </xsl:attribute>
    </xsl:element>
    <xsl:element name="meta">
      <xsl:attribute name="property">og:description</xsl:attribute>
      <xsl:attribute name="content">
        <xsl:value-of select="$extract" />
      </xsl:attribute>
    </xsl:element> <!-- / Sharing cards -->

    <script src="{$urlprefix}/scripts/jquery-3.5.1.min.js"></script>
    <script src="{$urlprefix}/scripts/modernizr.custom.65251.js"></script>

    <!-- Copy head element from the xhtml source file (and possibly from external xsl rules) -->
    <xsl:apply-templates select="head/node()" />
  </xsl:element></xsl:template>

</xsl:stylesheet>
