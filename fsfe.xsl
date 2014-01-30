<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dt="http://xsltsl.org/date-time"
  exclude-result-prefixes="dt"
  xmlns:str="http://exslt.org/strings"
  extension-element-prefixes="str">

  <xsl:import href="tools/xsltsl/translations.xsl" />
  <xsl:import href="tools/xsltsl/static-elements.xsl" />
  <xsl:import href="tools/xsltsl/tagging.xsl" />

  <!-- HTML 5 compatibility doctype, since our XSLT parser doesn't support disabling output escaping -->
  <xsl:output method="html" encoding="utf-8" indent="yes" doctype-system="about:legacy-compat" />
  
  <xsl:variable name="mode">
    <xsl:value-of select="'normal'" /> <!-- can be either 'normal' or 'valentine' -->
  </xsl:variable>
  
  <!-- The top level element of the input file is "buildinfo" -->
  <xsl:template match="/">
    <xsl:apply-templates select="buildinfo/document"/>
  </xsl:template>

  <!-- The actual HTML tree is in "buildinfo/document" -->
  <xsl:template match="buildinfo/document">
    <xsl:element name="html">
      <xsl:attribute name="lang">
        <xsl:value-of select="/buildinfo/@language"/>
      </xsl:attribute>

      <xsl:attribute name="class"><xsl:value-of select="/buildinfo/@language" /> no-js</xsl:attribute>

      <xsl:if test="/buildinfo/@language='ar'">
        <xsl:attribute name="dir">rtl</xsl:attribute>
      </xsl:if>

      <!--<xsl:apply-templates select="node()"/>-->
      <xsl:apply-templates select="head" />
      <xsl:call-template name="fsfe-body" />
    </xsl:element>
  </xsl:template>
  
  
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
      </xsl:otherwise>
    </xsl:choose>
    
    <xsl:if test="$mode = 'valentine'">
      <xsl:element name="link">
        <xsl:attribute name="rel">stylesheet</xsl:attribute>
        <xsl:attribute name="media">all</xsl:attribute>
        <xsl:attribute name="href"><xsl:value-of select="$urlprefix"/>/look/valentine.min.css</xsl:attribute>
        <xsl:attribute name="type">text/css</xsl:attribute>
      </xsl:element>
    </xsl:if>
    
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
  
  <!-- Modify H1 -->
  <xsl:template match="h1">
    
    <!-- Apply news page PRE-rules -->
    <xsl:if test="string(/buildinfo/document/@newsdate) and
                    (not(string(/buildinfo/document/@type)) or
                    /buildinfo/document/@type != 'newsletter')">
      
      <!-- add link to press/press.xx.html -->
      <xsl:element name="p">
        <xsl:attribute name="id">category</xsl:attribute>
        <xsl:element name="a">
          <xsl:attribute name="href">/press/press.<xsl:value-of select="/buildinfo/@language"/>.html</xsl:attribute>
          <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'press'" /></xsl:call-template>
        </xsl:element>
      </xsl:element>
    </xsl:if>
    
    <!-- Apply newsletter page PRE-rules -->
    <xsl:if test="string(/buildinfo/document/@newsdate) and /buildinfo/document/@type = 'newsletter'">
      <xsl:element name="p">
        <xsl:attribute name="id">category</xsl:attribute>
        <xsl:element name="a">
          <xsl:attribute name="href">/news/newsletter.<xsl:value-of select="/buildinfo/@language"/>.html</xsl:attribute>
          <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'newsletter'" /></xsl:call-template>
        </xsl:element>
      </xsl:element>
    </xsl:if>
    
    <!-- auto generate ID for headings if it doesn't already exist -->
    <xsl:call-template name="generate-id" />
    
    <!-- Apply news page rules -->
    <xsl:if test="string(/buildinfo/document/@newsdate) and
                    (not(string(/buildinfo/document/@type)) or
                    /buildinfo/document/@type != 'newsletter')">

      <!-- Social Links -->
      <xsl:variable name="original_file"
       select="concat(substring(string(/buildinfo/@filename), 2), '.' ,string(/buildinfo/@original), '.xhtml')"
       as="xs:string" />
      <xsl:variable name="originalDocument" select="document($original_file)/html" />
      <xsl:element name="a">
        <xsl:attribute name="class">social-link</xsl:attribute>
        <xsl:attribute name="href">https://flattr.com/submit/auto?user_id=fsfe&amp;url=http://fsfe.org/<xsl:value-of select="/buildinfo/@filename" />.html&amp;title=<xsl:value-of select="$originalDocument/head/title" />&amp;description=<xsl:value-of select="$originalDocument/body/p[@newsteaser]" />&amp;tags=<xsl:for-each select="$originalDocument/tags/tag"><xsl:value-of select="node()" />,</xsl:for-each>&amp;category=text</xsl:attribute>
        <xsl:element name="img">
          <xsl:attribute name="src">/graphics/flattr-badge-large.png</xsl:attribute>
          <xsl:attribute name="alt">Flattr this</xsl:attribute>
        </xsl:element>
      </xsl:element>
      <xsl:element name="a">
        <xsl:attribute name="class">social-link</xsl:attribute>
        <xsl:attribute name="href">/support?pr</xsl:attribute>
        <xsl:element name="img">
          <xsl:attribute name="src">/graphics/supporter/FSFE_plus1_48x22_b.png</xsl:attribute>
          <xsl:attribute name="alt">Support FSFE</xsl:attribute>
        </xsl:element>
      </xsl:element>
      <!-- End Social Links -->

      <!-- add publishing information (author, date) -->
      <xsl:element name="div">
        <xsl:attribute name="id">article-metadata</xsl:attribute>
        <span class="published-on"> <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'published'" /></xsl:call-template>: </span>
        <xsl:element name="time">
          <xsl:attribute name="class">dt-published</xsl:attribute>
          <xsl:value-of select="/buildinfo/document/@newsdate" />
        </xsl:element>
      </xsl:element>
      
    </xsl:if>
    <!-- End apply news page rules -->

    <!-- Apply newsletter page -->
    <xsl:if test="string(/buildinfo/document/@newsdate) and /buildinfo/document/@type = 'newsletter'">
        <!--TODO: this moved to the sidebar, but it would be nice to show it for newsletters which do not have sidebars:
              <xsl:call-template name="subscribe-nl" /-->

      <!-- Social Links -->
      <xsl:variable name="original_file"
       select="concat(substring(string(/buildinfo/@filename), 2), '.' ,string(/buildinfo/@original), '.xhtml')"
       as="xs:string" />
      <xsl:variable name="originalDocument" select="document($original_file)/html" />
      <xsl:element name="a">
        <xsl:attribute name="class">social-link</xsl:attribute>
        <xsl:attribute name="href">https://flattr.com/submit/auto?user_id=fsfe&amp;url=http://fsfe.org/<xsl:value-of select="/buildinfo/@filename" />.html&amp;title=<xsl:value-of select="$originalDocument/head/title" />&amp;description=<xsl:value-of select="$originalDocument/body/p[@newsteaser]" />&amp;tags=<xsl:for-each select="$originalDocument/tags/tag"><xsl:value-of select="node()" />,</xsl:for-each>&amp;category=text</xsl:attribute>
        <xsl:element name="img">
          <xsl:attribute name="src">/graphics/flattr-badge-large.png</xsl:attribute>
          <xsl:attribute name="alt">Flattr this</xsl:attribute>
        </xsl:element>
      </xsl:element>
      <xsl:element name="a">
        <xsl:attribute name="class">social-link</xsl:attribute>
        <xsl:attribute name="href">/support?pr</xsl:attribute>
        <xsl:element name="img">
          <xsl:attribute name="src">/graphics/supporter/FSFE_plus1_48x22_b.png</xsl:attribute>
          <xsl:attribute name="alt">Support FSFE</xsl:attribute>
        </xsl:element>
      </xsl:element>
      <!-- End Social Links -->

    </xsl:if>
    <!-- End apply newsletter page rules -->

    <!-- Depreciated- see next block: Apply article rules -->
    <xsl:if test = "string(/buildinfo/document/head/meta[@name='author-name-1']/@content)">
      <xsl:element name="div">
        <xsl:attribute name="id">article-metadata</xsl:attribute>
        
        <xsl:if test = "string(/buildinfo/document/head/meta[@name='author-name-1']/@content)">
          <span class="written-by"><xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'author'" /></xsl:call-template>: </span>
          <xsl:choose>
            <xsl:when test="/buildinfo/document/head/meta[@name='author-link-1']">
              <xsl:variable name="author-link-1" select="/buildinfo/document/head/meta[@name='author-link-1']/@content" />
              <a  class="p-author" rel='author' href='{$author-link-1}'>
              <xsl:value-of select="/buildinfo/document/head/meta[@name='author-name-1']/@content" /> </a> 
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="/buildinfo/document/head/meta[@name='author-name-1']/@content" /> 
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
    
        <xsl:if test = "string(/buildinfo/document/head/meta[@name='author-name-2']/@content)">
          <xsl:choose>
            <xsl:when test="/buildinfo/document/head/meta[@name='author-link-2']">
              <xsl:variable name="author-link-2" select="/buildinfo/document/head/meta[@name='author-link-2']/@content" />
              , <a  class="p-author" rel='author' href='{$author-link-2}'>
              <xsl:value-of select="/buildinfo/document/head/meta[@name='author-name-2']/@content" /> </a> 
            </xsl:when>
            <xsl:otherwise>
              , <xsl:value-of select="/buildinfo/document/head/meta[@name='author-name-2']/@content" /> 
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
        
        <xsl:if test = "string(/buildinfo/document/head/meta[@name='author-name-3']/@content)">
          <xsl:choose>
            <xsl:when test="/buildinfo/document/head/meta[@name='author-link-3']">
              <xsl:variable name="author-link-3" select="/buildinfo/document/head/meta[@name='author-link-3']/@content" />
              , <a class="p-author" rel='author' href='{$author-link-3}'>
              <xsl:value-of select="/buildinfo/document/head/meta[@name='author-name-3']/@content" /> </a> 
            </xsl:when>
            <xsl:otherwise>
              , <xsl:value-of select="/buildinfo/document/head/meta[@name='author-name-3']/@content" /> 
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
    
        <span class="published-on">&#160;<xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'published'" /></xsl:call-template>: </span>
        <xsl:element name="time">
          <xsl:attribute name="class">dt-published</xsl:attribute>
          <xsl:value-of select="/buildinfo/document/head/meta[@name='publication-date']/@content" />
        </xsl:element>
        
        <xsl:if test = "string(/buildinfo/document/head/meta[@name='pdf-link']/@content)">
          <span class="pdf-download">&#160;PDF: </span>
          <xsl:variable name="pdf-link" select="/buildinfo/document/head/meta[@name='pdf-link']/@content" />
          <a href='{$pdf-link}'>download</a>
        </xsl:if>
        
      </xsl:element> <!-- </div> -->
    </xsl:if>
    <!-- End Apply article rules -->

    <!--Article authors, date -->
    <xsl:if test="/buildinfo/document/author or /buildinfo/document/date or /buildinfo/document/download">
      <xsl:element name="div">
        <xsl:attribute name="id">article-metadata</xsl:attribute>

        <xsl:if test="/buildinfo/document/author">
            <span class="written-by"><xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'writtenby'" /></xsl:call-template>&#160;</span>
            
          <xsl:for-each select="/buildinfo/document/author">
              <xsl:variable name="id">
                <xsl:value-of select="@id" />
              </xsl:variable>

              <xsl:choose>    
                  <xsl:when test="@id and document('about/people/people.en.xml')/personset/person[@id=$id]">
                  <!-- if the author is in fsfe's people.xml then we take information from there --> 
                    <xsl:choose>
                      <xsl:when test="document('about/people/people.en.xml')/personset/person[@id=$id]/link">
                          <xsl:element name="a">
                                  <xsl:attribute name="class">author p-author h-card</xsl:attribute>
                                  <xsl:attribute name="rel">author</xsl:attribute>
                                  <xsl:attribute name="href"><xsl:value-of select="document('about/people/people.en.xml')/personset/person[@id=$id]/link" /></xsl:attribute>
                                  <xsl:if test="document('about/people/people.en.xml')/personset/person[@id=$id]/avatar">
                                          <xsl:element name="img">
                                                  <xsl:attribute name="alt"></xsl:attribute>
                                                  <xsl:attribute name="src"><xsl:value-of select="document('about/people/people.en.xml')/personset/person[@id=$id]/avatar" /></xsl:attribute>
                                          </xsl:element>
                                  </xsl:if>
                                  <xsl:value-of select="document('about/people/people.en.xml')/personset/person[@id=$id]/name" />
                          </xsl:element>&#160;
                      </xsl:when>
                      <xsl:otherwise>
                          <xsl:if test="document('about/people/people.en.xml')/personset/person[@id=$id]/avatar">
                                  <xsl:element name="img">
                                          <xsl:attribute name="alt"></xsl:attribute>
                                          <xsl:attribute name="src"><xsl:value-of select="document('about/people/people.en.xml')/personset/person[@id=$id]/avatar" /></xsl:attribute>
                                  </xsl:element>
                          </xsl:if>
                          <span class="author p-author">
                            <xsl:value-of select="document('about/people/people.en.xml')/personset/person[@id=$id]/name" />&#160;
                          </span>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:choose>
                      <xsl:when test="link">
                        <xsl:element name="a">
                                  <xsl:attribute name="class">author p-author h-card</xsl:attribute>
                                  <xsl:attribute name="rel">author</xsl:attribute>
                                  <xsl:attribute name="href"><xsl:value-of select="link" /></xsl:attribute>
                                  <xsl:if test="avatar">
                                          <xsl:element name="img">
                                                  <xsl:attribute name="alt"></xsl:attribute>
                                                  <xsl:attribute name="src"><xsl:value-of select="avatar" /></xsl:attribute>
                                          </xsl:element>
                                  </xsl:if>
                                  <xsl:value-of select="name" />
                          </xsl:element>&#160;
                      </xsl:when>
                      <xsl:otherwise>
                          <xsl:if test="avatar">
                                  <xsl:element name="img">
                                          <xsl:attribute name="alt"></xsl:attribute>
                                          <xsl:attribute name="src"><xsl:value-of select="avatar" /></xsl:attribute>
                                  </xsl:element>
                          </xsl:if>
                          <span class="author p-author">
                            <xsl:value-of select="name" />&#160;
                          </span>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:otherwise>
              </xsl:choose>
          </xsl:for-each>
    </xsl:if>

    <xsl:if test="/buildinfo/document/date">
        <span class="published-on"><xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'published'" /></xsl:call-template>&#160;</span> 
        <xsl:element name="time">
          <xsl:attribute name="class">dt-published</xsl:attribute>
          <xsl:value-of select="/buildinfo/document/date/original/@content" />
        </xsl:element>&#160;
        <xsl:if test="/buildinfo/document/date/revision">
                (<span class="revision-on"><xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'revision'" /></xsl:call-template></span>
          <xsl:for-each select="/buildinfo/document/date/revision">                
            &#160;<xsl:element name="time">
              <xsl:attribute name="class">dt-updated</xsl:attribute>
              <xsl:value-of select="@content" />
            </xsl:element>
          </xsl:for-each>)&#160;
        </xsl:if>
    </xsl:if>
    
    <xsl:if test="/buildinfo/document/download">
        <span class="download"><xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'download'" /></xsl:call-template>&#160;</span>
        <xsl:element name="a">
                <xsl:attribute name="href"><xsl:value-of select="/buildinfo/document/download/@content" /></xsl:attribute>
                <xsl:value-of select="/buildinfo/document/download/@type" />
        </xsl:element>
    </xsl:if>
    
      </xsl:element>
    </xsl:if>
    <!--End Article authors, date-->
         
  </xsl:template>
  <!-- End modifications to H1 --> 
  
  <!-- Modify H2 -->
  <xsl:template match="h2">
    <!-- auto generate ID for headings if it doesn't already exist -->
    <xsl:call-template name="generate-id" />
  </xsl:template>
  
  <!-- Modify H3 -->
  <xsl:template match="h3">
    <!-- auto generate ID for headings if it doesn't already exist -->
    <xsl:call-template name="generate-id" />
  </xsl:template>
  
  <!-- Modify H4 -->
  <xsl:template match="h4">
    <!-- auto generate ID for headings if it doesn't already exist -->
    <xsl:call-template name="generate-id" />
  </xsl:template>
  
  <!-- Modify H4 -->
  <xsl:template match="h4">
    <!-- auto generate ID for headings if it doesn't already exist -->
    <xsl:call-template name="generate-id" />
  </xsl:template>
  
  <!-- Modify H5 -->
  <xsl:template match="h5">
    <!-- auto generate ID for headings if it doesn't already exist -->
    <xsl:call-template name="generate-id" />
  </xsl:template>
  
  <!-- Modify H6 -->
  <xsl:template match="h6">
    <!-- auto generate ID for headings if it doesn't already exist -->
    <xsl:call-template name="generate-id" />
  </xsl:template>

  <!-- Apply support page -->
  <xsl:template match="support-portal-javascript">
    <xsl:call-template name="support-portal-javascript" />
  </xsl:template>
  <xsl:template match="support-form-javascript">
    <xsl:call-template name="support-form-javascript" />
  </xsl:template>
  <xsl:template match="country-list-europe">
    <xsl:call-template name="country-list-europe" />
  </xsl:template>
  <xsl:template match="country-list-other-continents">
    <xsl:call-template name="country-list-other-continents" />
  </xsl:template>
  <!-- End apply support page rules -->
    
  <!-- HTML body -->
  <!--<xsl:template match="body">-->
  <xsl:template name="fsfe-body">
    <body>

      <!--Apply appopriate styles for the whole page -->
      <xsl:if test="/buildinfo/document/body/@class">
        <xsl:attribute name="class">
          <xsl:value-of select="/buildinfo/document/body/@class" /> 
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="/buildinfo/document/body/@id">
        <xsl:attribute name="id"><xsl:value-of select="/buildinfo/document/body/@id" /></xsl:attribute>
      </xsl:if>

      <!-- For pages used on external web servers, use absolute URLs -->
      <xsl:variable name="urlprefix"><xsl:if test="/buildinfo/document/@external">https://fsfe.org</xsl:if></xsl:variable>

      <!-- First of all, a comment to make clear this is generated -->
      <xsl:comment>This file was generated by an XSLT script. Please do not edit.</xsl:comment>
      
      <xsl:element name="div">
        <xsl:attribute name="id">translations</xsl:attribute>
        <xsl:attribute name="class">alert</xsl:attribute>

        <xsl:element name="a">
          <xsl:attribute name="class">close</xsl:attribute>
          <xsl:attribute name="data-toggle">collapse</xsl:attribute>
          <xsl:attribute name="data-target">#translations</xsl:attribute>
          <xsl:attribute name="href">#</xsl:attribute>
          ×
        </xsl:element>

        <xsl:element name="a">
          <xsl:attribute name="class">contribute-translation</xsl:attribute>
          <xsl:attribute name="href">/contribute/translators/</xsl:attribute>
          <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'translate'" /></xsl:call-template>
        </xsl:element>

        <xsl:element name="ul">
          <xsl:for-each select="/buildinfo/trlist/tr">
            <xsl:sort select="@id" />
            <xsl:choose>
              <xsl:when test="@id=/buildinfo/@language">
                <xsl:element name="li">
                  <xsl:value-of select="." disable-output-escaping="yes"/>
                </xsl:element>
              </xsl:when>
              <xsl:otherwise>
                <xsl:element name="li">
                  <xsl:element name="a">
                    <xsl:attribute name="href"><xsl:value-of select="/buildinfo/@filename"/>.<xsl:value-of select="@id"/>.html</xsl:attribute>
                    <xsl:value-of select="." disable-output-escaping="yes"/>
                  </xsl:element>
                </xsl:element>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </xsl:element>
        <!--/ul-->
        
      </xsl:element>
      <!--/div#translations-->


      <xsl:element name="header">
        <xsl:attribute name="id">top</xsl:attribute>

        <xsl:element name="nav">
          <xsl:attribute name="id">menu</xsl:attribute>
          <xsl:attribute name="role">navigation</xsl:attribute>
          
          <xsl:element name="div">
            <xsl:attribute name="id">direct-links</xsl:attribute>

            <xsl:element name="span">
              <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'go-to'" /></xsl:call-template>
            </xsl:element>

            <xsl:element name="a">
              <xsl:attribute name="href">#menu-list</xsl:attribute>
              <xsl:attribute name="id">direct-to-menu-list</xsl:attribute>
              <xsl:attribute name="data-toggle">collapse</xsl:attribute>
              <xsl:attribute name="data-target">#menu-list</xsl:attribute>
              <xsl:element name="i">
                <xsl:attribute name="class">fa fa-bars fa-lg</xsl:attribute>
              </xsl:element>
              <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'menu'" /></xsl:call-template>
            </xsl:element>

            <xsl:element name="a">
              <xsl:attribute name="href">#content</xsl:attribute>
              <xsl:attribute name="id">direct-to-content</xsl:attribute>
              <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'content'" /></xsl:call-template>
            </xsl:element>
            
            <xsl:element name="a">
              <xsl:attribute name="href">#full-menu</xsl:attribute>
              <xsl:attribute name="id">direct-to-full-menu</xsl:attribute>
              <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'sitemap'" /></xsl:call-template>
            </xsl:element>

            <xsl:element name="a">
              <xsl:attribute name="href">#source</xsl:attribute>
              <xsl:attribute name="id">direct-to-source</xsl:attribute>
              <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'page-info'" /></xsl:call-template>
            </xsl:element>

            <xsl:element name="a">
              <xsl:attribute name="href">#translations</xsl:attribute>
              <xsl:attribute name="id">direct-to-translations</xsl:attribute>
              <xsl:attribute name="data-toggle">collapse</xsl:attribute>
              <xsl:attribute name="data-target">#translations</xsl:attribute>
              <xsl:element name="i">
                <xsl:attribute name="class">fa fa-globe fa-lg</xsl:attribute>
              </xsl:element>
              <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'change-lang'" /></xsl:call-template>
            </xsl:element>

            <xsl:element name="a">
              <xsl:attribute name="href">/</xsl:attribute>
              <xsl:attribute name="id">direct-to-home</xsl:attribute>
              <xsl:element name="i">
                <xsl:attribute name="class">fa fa-home fa-lg</xsl:attribute>
              </xsl:element>
              <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'fsfeurope'" /></xsl:call-template>
            </xsl:element>

          </xsl:element>
          <!--/div#direct-links-->

          <xsl:element name="ul">
            <xsl:attribute name="id">menu-list</xsl:attribute>
            <xsl:element name="li">
              <xsl:element name="a">
                <xsl:attribute name="href">/about/about.html</xsl:attribute>
                <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'fsfe/about'" /></xsl:call-template>
              </xsl:element>
            </xsl:element>
            <xsl:element name="li">
              <xsl:element name="a">
                <xsl:attribute name="href">/projects/work.html</xsl:attribute>
                <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'fsfe/projects'" /></xsl:call-template>
              </xsl:element>
            </xsl:element>
            <xsl:element name="li">
              <xsl:element name="a">
                <xsl:attribute name="href">/campaigns/campaigns.html</xsl:attribute>
                <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'fsfe/campaigns'" /></xsl:call-template>
              </xsl:element>
            </xsl:element>
            <xsl:element name="li">
              <xsl:element name="a">
                <xsl:attribute name="href">/contribute/contribute.html</xsl:attribute>
                <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'fsfe/help'" /></xsl:call-template>
              </xsl:element>
            </xsl:element>
            <xsl:element name="li">
              <xsl:element name="a">
                <xsl:attribute name="href">/press/press.html</xsl:attribute>
                <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'fsfe/press'" /></xsl:call-template>
              </xsl:element>
            </xsl:element>
          </xsl:element>
          <!--/ul#menu-list-->

          <xsl:element name="div">
            <xsl:attribute name="id">search</xsl:attribute>

              <xsl:element name="form">
                <xsl:attribute name="method">get</xsl:attribute>
                <xsl:attribute name="action">http://fsfe.yacy.net/yacysearch.html</xsl:attribute>

                <xsl:element name="input">
                  <xsl:attribute name="type">hidden</xsl:attribute>
                  <xsl:attribute name="name">verify</xsl:attribute>
                  <xsl:attribute name="value">true</xsl:attribute>
                </xsl:element>

                <xsl:element name="input">
                  <xsl:attribute name="type">hidden</xsl:attribute>
                  <xsl:attribute name="name">maximumRecords</xsl:attribute>
                  <xsl:attribute name="value">10</xsl:attribute>
                </xsl:element>

                <xsl:element name="input">
                  <xsl:attribute name="type">hidden</xsl:attribute>
                  <xsl:attribute name="name">meanCount</xsl:attribute>
                  <xsl:attribute name="value">5</xsl:attribute>
                </xsl:element>

                <xsl:element name="input">
                  <xsl:attribute name="type">hidden</xsl:attribute>
                  <xsl:attribute name="name">resource</xsl:attribute>
                  <xsl:attribute name="value">local</xsl:attribute>
                </xsl:element>

                <xsl:element name="input">
                  <xsl:attribute name="type">hidden</xsl:attribute>
                  <xsl:attribute name="name">prefermaskfilter</xsl:attribute>
                  <xsl:attribute name="value">.*.<xsl:value-of select="/buildinfo/@language"/>.html</xsl:attribute>
                </xsl:element>

                <xsl:element name="input">
                  <xsl:attribute name="type">hidden</xsl:attribute>
                  <xsl:attribute name="name">prefermaskfilter</xsl:attribute>
                  <xsl:attribute name="value">.*</xsl:attribute>
                </xsl:element>

                <xsl:element name="input">
                  <xsl:attribute name="type">hidden</xsl:attribute>
                  <xsl:attribute name="name">display</xsl:attribute>
                  <xsl:attribute name="value">2</xsl:attribute>
                </xsl:element>

                <xsl:element name="input">
                  <xsl:attribute name="type">hidden</xsl:attribute>
                  <xsl:attribute name="name">nav</xsl:attribute>
                  <xsl:attribute name="value">hosts</xsl:attribute>
                </xsl:element>

                <xsl:element name="p">
                  <xsl:element name="input">
                    <xsl:attribute name="type">image</xsl:attribute>
                    <xsl:attribute name="src">/graphics/icons/search-button.png</xsl:attribute>
                    <xsl:attribute name="alt">
                      <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'search'" /></xsl:call-template>
                    </xsl:attribute>
                  </xsl:element>

                  <xsl:element name="input">
                    <xsl:attribute name="type">text</xsl:attribute>
                    <xsl:attribute name="name">query</xsl:attribute>
                    <xsl:attribute name="placeholder">
                      <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'search'" /></xsl:call-template>
                    </xsl:attribute>
                  </xsl:element>

                  <!--
                  <xsl:element name="input">
                    <xsl:attribute name="type">submit</xsl:attribute>
                    <xsl:attribute name="name">search</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'submit'" /></xsl:call-template>
                    </xsl:attribute>
                  </xsl:element>
                  -->
                </xsl:element>

              </xsl:element>
              <!--/form-->
          </xsl:element>
          <!--/div#search-->
          

        </xsl:element>
        <!--/nav#menu-->


        <xsl:element name="div">
          <xsl:attribute name="id">masthead</xsl:attribute>

          <xsl:element name="div">
            <xsl:attribute name="id">link-home</xsl:attribute>
            <xsl:element name="a">
              <xsl:attribute name="href">
                  <xsl:value-of select="$urlprefix"/>
              </xsl:attribute>
              <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'rootpage'" /></xsl:call-template>
            </xsl:element>
          </xsl:element>
          <!--/div#link-home-->

          <xsl:element name="div">
            <xsl:attribute name="id">logo</xsl:attribute>
            <xsl:element name="span">
                  <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'fsfeurope'" /></xsl:call-template>
              </xsl:element>
          </xsl:element>
          <!--/div#logo-->

          <xsl:element name="div">
            <xsl:attribute name="id">motto</xsl:attribute>
            <xsl:element name="span"><xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'motto-fsfs'" /></xsl:call-template></xsl:element>
            <!-- TODO different motto content depending on planet (use 'motto-planet'), wiki (use 'motto-wiki'), or fsfe dot org, page, so we may have to change this to another way-->
          </xsl:element>
          <!--/div#motto-->

        </xsl:element>
        <!--/div#masthead-->

      </xsl:element>
      <!--/header#top-->




      <xsl:element name="div">
        <xsl:attribute name="id">notifications</xsl:attribute>

        <!-- Service notice (for downtime, upgrades, etc. enable this)
        <div id="service-notice">
          <div class="close">
            <a title="dismiss this notification">×</a>
          </div>

          <div class="text">
            <h1>Site currently under development</h1>

            <p>
              If you want to help out, <a
              href="/contribute/web/web.en.html">consider joining the
              web team</a>.
            </p>
          </div>
        </div>-->

        <!-- Outdated note -->
        <xsl:if test="/buildinfo/@outdated='yes'">
          <xsl:element name="div">
        <xsl:attribute name="class">alert warning red</xsl:attribute>
            <xsl:element name="a">
              <xsl:attribute name="class">close</xsl:attribute>
              <xsl:attribute name="data-dismiss">alert</xsl:attribute>
              <xsl:attribute name="href">#</xsl:attribute>
              <xsl:attribute name="aria-hidden">true</xsl:attribute>
              ×
            </xsl:element>
              <xsl:element name="p">
        <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'outdated-1'" /></xsl:call-template>
              <xsl:element name="a">
                <xsl:attribute name="href">
                  <xsl:value-of select="/buildinfo/@filename"/>
                  <xsl:text>.en.html</xsl:text>
                </xsl:attribute>
                <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'translator3b'" /></xsl:call-template>
              </xsl:element>.
        <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'outdated-2'" /></xsl:call-template>
          </xsl:element>
          </xsl:element>
        </xsl:if>
  
        <!-- Missing translation note -->
        <xsl:if test="/buildinfo/@language!=/buildinfo/document/@language">
          <xsl:element name="div">
        <xsl:attribute name="class">alert warning red</xsl:attribute>
            <xsl:element name="a">
              <xsl:attribute name="class">close</xsl:attribute>
              <xsl:attribute name="data-dismiss">alert</xsl:attribute>
              <xsl:attribute name="href">#</xsl:attribute>
              <xsl:attribute name="aria-hidden">true</xsl:attribute>
              ×
            </xsl:element>
              <xsl:element name="p">
        <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'notranslation'" /></xsl:call-template>
          </xsl:element>
          </xsl:element>
        </xsl:if>
  
        <!-- Info box -->
        <xsl:element name="div"> 
          <xsl:attribute name="id">infobox</xsl:attribute>
          <!-- Add under construction message -->
          <xsl:if test = "/buildinfo/document/head/meta[@name='under-construction' and @content='true']">
            <xsl:element name="div">
              <xsl:attribute name="class">alert warning yellow</xsl:attribute>
            <xsl:element name="a">
              <xsl:attribute name="class">close</xsl:attribute>
              <xsl:attribute name="data-dismiss">alert</xsl:attribute>
              <xsl:attribute name="href">#</xsl:attribute>
              <xsl:attribute name="aria-hidden">true</xsl:attribute>
              ×
            </xsl:element>
              <xsl:element name="p">
              <xsl:call-template name="fsfe-gettext">
                <xsl:with-param name="id" select="'under-construction'" />
              </xsl:call-template>
            </xsl:element>
          </xsl:element>
          </xsl:if>
          <!-- Add project completed message -->
          <xsl:if test = "/buildinfo/document/head/meta[@name='project-complete' and @content='true']">
            <xsl:element name="div">
              <xsl:attribute name="class">alert warning green</xsl:attribute>
            <xsl:element name="a">
              <xsl:attribute name="class">close</xsl:attribute>
              <xsl:attribute name="data-dismiss">alert</xsl:attribute>
              <xsl:attribute name="href">#</xsl:attribute>
              <xsl:attribute name="aria-hidden">true</xsl:attribute>
              ×
            </xsl:element>
              <xsl:element name="p">
              <xsl:call-template name="fsfe-gettext">
                <xsl:with-param name="id" select="'project-complete'" />
              </xsl:call-template>
            </xsl:element>
          </xsl:element>
          </xsl:if>
        </xsl:element>
        
        <!-- Fundraising box
          <xsl:element name="div">
        <xsl:attribute name="id">fundraising</xsl:attribute>
          <xsl:element name="h2">
            <xsl:apply-templates select="/buildinfo/fundraising/call1/node()"/>
          </xsl:element>
          <xsl:element name="div">
            <xsl:attribute name="class">button</xsl:attribute>
            <xsl:apply-templates select="/buildinfo/fundraising/call2/node()"/>
          </xsl:element>
          <xsl:element name="div">
            <xsl:attribute name="class">button</xsl:attribute>
            <xsl:apply-templates select="/buildinfo/fundraising/call3/node()"/>
          </xsl:element>
          <xsl:element name="img">
            <xsl:attribute name="src">/graphics/wreath.png</xsl:attribute>
            <xsl:attribute name="alt">wreath</xsl:attribute>
            <xsl:attribute name="class">right</xsl:attribute>
          </xsl:element>
          <xsl:element name="p">
            <xsl:attribute name="class">call4</xsl:attribute>
            <xsl:apply-templates select="/buildinfo/fundraising/call4/node()"/>
          </xsl:element>
          disabling the progress bar
          <xsl:if test="/buildinfo/fundraising/current">
            <xsl:element name="div">
              <xsl:attribute name="class">percentbox</xsl:attribute>
              <xsl:element name="div">
            <xsl:attribute name="class">percentbar</xsl:attribute>
            <xsl:attribute name="style">width: 45.9%</xsl:attribute>
              </xsl:element>
            </xsl:element>
            <xsl:element name="p">
              <xsl:attribute name="class">current</xsl:attribute>
              <xsl:apply-templates select="/buildinfo/fundraising/current/node()"/>
              <xsl:text>€ 45 860</xsl:text>
            </xsl:element>
            <xsl:element name="p">
              <xsl:attribute name="class">target</xsl:attribute>
              <xsl:text>€ 100 000</xsl:text>
            </xsl:element>
          </xsl:if> c
        </xsl:element>-->
        <!-- End Fundraising box -->

      </xsl:element>
      <!--/div#notifications-->

      <xsl:element name="section">
        <xsl:attribute name="id">main</xsl:attribute>
        <xsl:attribute name="role">main</xsl:attribute>

        <xsl:element name="article">
          <xsl:attribute name="id">content</xsl:attribute>
          <xsl:if test="/buildinfo/document/body/@microformats">
            <xsl:attribute name="class"><xsl:value-of select="/buildinfo/document/body/@microformats" /></xsl:attribute>
          </xsl:if>




          <!-- Here goes the actual content of the <body> node of the input file -->
          <xsl:apply-templates select="body | /buildinfo/document/event/body | /buildinfo/document/news/body" />

    
        </xsl:element>
        <!--/article#content-->

        <xsl:if test = "/buildinfo/document/sidebar">
          <xsl:element name="aside">
            <xsl:attribute name="id">sidebar</xsl:attribute>

            <xsl:if test="string(/buildinfo/document/@newsdate) and /buildinfo/document/@type = 'newsletter'">
              <xsl:element name="h3">
                <xsl:call-template name="fsfe-gettext">
                  <xsl:with-param name="id" select="'receive-newsletter'" />
                </xsl:call-template>
              </xsl:element>
              <xsl:call-template name="subscribe-nl" />
            </xsl:if>
            
            <xsl:apply-templates select="/buildinfo/document/sidebar/node()" />
            
            <!--xsl:if test = "/buildinfo/document/sidebar/@news">
              <xsl:element name="h4">
                <xsl:call-template name="fsfe-gettext">
                  <xsl:with-param name="id" select="'related-news'" />
                </xsl:call-template>
              </xsl:element>
              <fetch-news />
              -->
              <!--FIXME-->
              <!--ul class="placeholder"><li>
                  <span class="dt-published">11 June 2013</span><a href="/news/2013/news-20130611-01.en.html">Filing taxes without non-free software: Slovak company appeals fines</a>
              </li></ul-->
            <!--/xsl:if-->

            <xsl:choose>
              <xsl:when test = "/buildinfo/document/sidebar/@promo = 'our-work'">
                <xsl:element name="h3">
                  <xsl:attribute name="class">promo</xsl:attribute>
                  <xsl:call-template name="fsfe-gettext">
                    <xsl:with-param name="id" select="'our-work'" />
                  </xsl:call-template>
                </xsl:element>
                <xsl:call-template name="fsfe-gettext">
                  <xsl:with-param name="id" select="'our-work-intro'" />
                </xsl:call-template>
                <xsl:element name="a"> 
                  <xsl:attribute name="href">/about/about.html</xsl:attribute>
                  <xsl:attribute name="class">learn-more</xsl:attribute>
                  <xsl:call-template name="fsfe-gettext">
                    <xsl:with-param name="id" select="'learn-more'" />
                  </xsl:call-template>
                </xsl:element>
              </xsl:when>
              <xsl:when test = "/buildinfo/document/sidebar/@promo = 'about-fsfe'">
                <xsl:element name="h3">
                  <xsl:attribute name="class">promo</xsl:attribute>
                  <xsl:call-template name="fsfe-gettext">
                    <xsl:with-param name="id" select="'about-fsfe'" />
                  </xsl:call-template>
                </xsl:element>
                <xsl:call-template name="fsfe-gettext">
                  <xsl:with-param name="id" select="'about-fsfe-intro'" />
                </xsl:call-template>
                <xsl:element name="a"> 
                  <xsl:attribute name="href">/about/about.html</xsl:attribute>
                  <xsl:attribute name="class">learn-more</xsl:attribute>
                  <xsl:call-template name="fsfe-gettext">
                    <xsl:with-param name="id" select="'learn-more'" />
                  </xsl:call-template>
                </xsl:element>
              </xsl:when>
              <xsl:when test = "/buildinfo/document/sidebar/@promo = 'donate'">
                <xsl:element name="h3">
                  <xsl:attribute name="class">promo</xsl:attribute>
                  <xsl:call-template name="fsfe-gettext">
                    <xsl:with-param name="id" select="'donate'" />
                  </xsl:call-template>
                </xsl:element>
                <xsl:call-template name="fsfe-gettext">
                  <xsl:with-param name="id" select="'donate-paragraph'" />
                </xsl:call-template>
                <xsl:element name="a"> 
                  <xsl:attribute name="href">/donate/donate.html#ref-sidebar</xsl:attribute>
                  <xsl:attribute name="class">learn-more big-donate</xsl:attribute>
                  <xsl:call-template name="fsfe-gettext">
                    <xsl:with-param name="id" select="'donate'" />
                  </xsl:call-template>
                </xsl:element>
              </xsl:when>
              <xsl:when test = "/buildinfo/document/sidebar/@promo = 'no'">
              </xsl:when>
              <xsl:otherwise test = "/buildinfo/document/sidebar/@promo = 'about-fsfe'">
                <xsl:element name="h3">
                  <xsl:attribute name="class">promo</xsl:attribute>
                  <xsl:call-template name="fsfe-gettext">
                    <xsl:with-param name="id" select="'about-fsfe'" />
                  </xsl:call-template>
                </xsl:element>
                <xsl:call-template name="fsfe-gettext">
                  <xsl:with-param name="id" select="'about-fsfe-intro'" />
                </xsl:call-template>
                <xsl:element name="a"> 
                  <xsl:attribute name="href">/about/about.html</xsl:attribute>
                  <xsl:attribute name="class">learn-more</xsl:attribute>
                  <xsl:call-template name="fsfe-gettext">
                    <xsl:with-param name="id" select="'learn-more'" />
                  </xsl:call-template>
                </xsl:element>
              </xsl:otherwise>
            </xsl:choose>

          </xsl:element>
          <!--/aside#sidebar-->
        </xsl:if>

        <xsl:if test = "/buildinfo/document/legal">
          <xsl:element name="footer">
    
            <xsl:attribute name="class">copyright notice creativecommons</xsl:attribute>
            <xsl:choose> 
              <xsl:when test = "/buildinfo/document/legal/license">      
                <xsl:element name="a">
                  <xsl:attribute name="href">
                    <xsl:value-of select="/buildinfo/document/legal/license"/>
                  </xsl:attribute>
                  <xsl:attribute name="rel">license</xsl:attribute>
                    <xsl:if test ="/buildinfo/document/legal/@type='cc-license'">
                    </xsl:if>
                    <xsl:value-of select="/buildinfo/document/legal/notice"/>
                </xsl:element>
              </xsl:when>
              
              <xsl:otherwise>
                <xsl:element name="span">
                  <xsl:value-of select="/buildinfo/document/legal/notice"/>
                </xsl:element>
              </xsl:otherwise>
            </xsl:choose>
            
          </xsl:element>
          <!--/footer-->
        </xsl:if>

        <!--Depreciated: it's here only for "backward compatibility"  cc license way-->
        <xsl:if test = "string(/buildinfo/document/head/meta[@name='cc-license']/@content)">
          <xsl:element name="footer">

            <xsl:element name="div">    
              <xsl:attribute name="id">cc-licenses</xsl:attribute>
              
              <xsl:element name="p">
                <xsl:element name="img">
                <xsl:attribute name="src">/graphics/cc-logo.png</xsl:attribute>
                <xsl:attribute name="alt">Creative Commons logo</xsl:attribute>
                </xsl:element> <!-- </img> -->
                <xsl:for-each select="/buildinfo/document/head/meta[@name='cc-license']">
                  <xsl:value-of select="@content"/> • 
                </xsl:for-each>
                <!--<xsl:value-of select="/buildinfo/document/head/meta[@name='cc-license-1']/@content" /> • -->
              </xsl:element> <!-- </p> -->
              
            </xsl:element> <!-- </div> -->
            <!-- End cc licenses -->

          </xsl:element>
          <!--/footer-->
        </xsl:if>

      </xsl:element>
      <!--/section#main-->

      <!--TODO nice to have a breadcrumb navigation: xsl:element name="nav">
        <xsl:attribute name="id">breadcrumbs</xsl:attribute>
        <a href="#"><i class="fa fa-home"></i> FSFE</a>
        <a href="#">Work</a>
        <a href="#">Open Standards</a>
        <a href="#">Minimalgebot für…i <i class="fa fa-anchor"></i></a>
      </xsl:element-->
      <!--/nav#breadcrumbs-->

      <xsl:element name="section">
        <xsl:attribute name="id">followup</xsl:attribute>
           <!--
           TODO Okay, so the idea here is to be able to display different "followup" boxes. I would suggest doing it like this:
            - the xml page shold be able to say that it wants to show a
                specific boxe and would contain e.g.
                <followup>subscribe-newsletter</followup> so the page would show
                the following box. 
            - if the xml page does not contain any <followup> variable, then we should be able to set a default followup box on our own.

              This has the advantage that depending on priorities, we can show
              a box in all our pages at the bottom. For instance, when we are
              in the middle of our yearly fundraising, we could set the default
              to a "fundraising" box.

           For now, this is just a placeholder, so all pages show the
           "Subscribe to newsletter" box. Below that, some examples of boxes we
           should make.
           -->
        <xsl:choose>
          <xsl:when test="/buildinfo/document/followup = 'subscribe-nl'">
            <xsl:attribute name="class">subscribe-nl</xsl:attribute>
            <xsl:element name="h2"><xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'subscribe-newsletter'" /></xsl:call-template></xsl:element>
            <xsl:call-template name="subscribe-nl" />
          </xsl:when>
          <xsl:when test="/buildinfo/document/followup = 'support'">
            <xsl:attribute name="class">support</xsl:attribute>
            <xsl:element name="h2"><xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'show-support'" /></xsl:call-template></xsl:element>
            <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'show-support-paragraph'" /></xsl:call-template>
            <xsl:element name="a">
              <xsl:attribute name="href">/support/?followupbox</xsl:attribute>
              <xsl:attribute name="class">btn</xsl:attribute>
              <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'support-fsfe'" /></xsl:call-template>
            </xsl:element>
          </xsl:when>
          <xsl:when test="/buildinfo/document/followup = 'donate'">
            <xsl:attribute name="class">donate</xsl:attribute>
            <xsl:element name="h2">
              <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'donate'" /></xsl:call-template>
            </xsl:element>
            <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'donate-paragraph'" /></xsl:call-template>
            <xsl:element name="a">
              <xsl:attribute name="href">/donate/donate.html#ref-followupbox</xsl:attribute>
              <xsl:attribute name="class">btn</xsl:attribute>
              <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'donate'" /></xsl:call-template>
            </xsl:element>
          </xsl:when>
          <xsl:when test="/buildinfo/document/followup = 'join'">
            <xsl:attribute name="class">join</xsl:attribute>
            <xsl:element name="h2">
              <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'join-fellowship'" /></xsl:call-template>
            </xsl:element>
            <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'join-paragraph'" /></xsl:call-template>
            <xsl:element name="a">
              <xsl:attribute name="href">/fellowship/join.html#ref-followupbox</xsl:attribute>
              <xsl:attribute name="class">btn</xsl:attribute>
              <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'join'" /></xsl:call-template>
            </xsl:element>
          </xsl:when>
          <xsl:when test="/buildinfo/document/followup = 'no'">
            <xsl:attribute name="class">hide</xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">subscribe-nl</xsl:attribute>
            <xsl:element name="h2"><xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'subscribe-newsletter'" /></xsl:call-template></xsl:element>
            <xsl:call-template name="subscribe-nl" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:element>
      <!--/section#followup-->

      <xsl:element name="footer">
        <xsl:attribute name="id">bottom</xsl:attribute>

        <xsl:element name="nav">
          <xsl:attribute name="id">full-menu</xsl:attribute>

          <xsl:element name="a">
            <xsl:attribute name="href">#top</xsl:attribute>
            <xsl:attribute name="id">direct-to-top</xsl:attribute>
            <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'go-top'" /></xsl:call-template>
            <!--FIXME translate that-->
          </xsl:element>

          <xsl:element name="ul">
            <xsl:attribute name="id">full-menu-list</xsl:attribute>
            <!-- FSFE portal menu -->
            <xsl:element name="li">
              <xsl:attribute name="class">fsfe</xsl:attribute>
              <xsl:element name="a">
                <xsl:attribute name="href">/</xsl:attribute>
                  <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'fsfeurope'" /></xsl:call-template>
              </xsl:element>

              <xsl:element name="ul">
                <xsl:variable name="menu"><xsl:value-of select="@id" /></xsl:variable>
                        <xsl:for-each select="/buildinfo/menuset/menu[@parent='fsfe']">
                          <!--<xsl:sort select="@id"/>-->
                          <xsl:sort select="@priority" />
                          <xsl:variable name="id"><xsl:value-of select="@id" /></xsl:variable>
                          <xsl:element name="li">
                            <xsl:choose>
                              <xsl:when test="not(string(.))">
                                <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="$id" /></xsl:call-template>
                              </xsl:when>
                              <xsl:when test=". = concat(/buildinfo/@filename ,'.html')">
                                <xsl:element name="span">
                                <xsl:attribute name="id">selected</xsl:attribute>
                                  <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="$id" /></xsl:call-template>
                                </xsl:element>
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:element name="a">
                                  <xsl:attribute name="href"><xsl:value-of select="." /></xsl:attribute>
                                  <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="$id" /></xsl:call-template>
                                </xsl:element>
                              </xsl:otherwise>
                            </xsl:choose>
                          </xsl:element> <!-- /li -->
                        </xsl:for-each>
              </xsl:element>
              <!--/ul-->
            </xsl:element>
            <!--/li-->
                
            <!-- Support portal menu item -->
            <xsl:element name="li">
              <xsl:attribute name="class">support</xsl:attribute>
              <xsl:element name="a">
                <xsl:attribute name="href">/donate/donate.html#ref-fullmenu</xsl:attribute>
                <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'support/donate'" /></xsl:call-template> 
              </xsl:element>

              <xsl:element name="ul">
                <xsl:variable name="menu"><xsl:value-of select="@id" /></xsl:variable>
                <xsl:for-each select="/buildinfo/menuset/menu[@parent='support']">
                  <!--<xsl:sort select="@id"/>-->
                  <xsl:sort select="@priority" />
                  <xsl:variable name="id"><xsl:value-of select="@id" /></xsl:variable>
                  <xsl:element name="li">
                    <xsl:choose>
                      <xsl:when test="not(string(.))">
                        <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="$id" /></xsl:call-template>
                      </xsl:when>
                      <xsl:when test=". = concat(/buildinfo/@filename ,'.html')">
                        <xsl:element name="span">
                        <xsl:attribute name="id">selected</xsl:attribute>
                          <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="$id" /></xsl:call-template>
                        </xsl:element>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:element name="a">
                          <xsl:attribute name="href"><xsl:value-of select="." /></xsl:attribute>
                          <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="$id" /></xsl:call-template>
                        </xsl:element>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:element> <!-- /li -->
                </xsl:for-each>
              </xsl:element>
              <!--/ul-->

              <!-- Fellowship portal menu -->
              <xsl:element name="ul">
                <xsl:attribute name="class">fellowship</xsl:attribute>
                <xsl:element name="li">
                  <xsl:attribute name="class">fellowship</xsl:attribute>
                  <xsl:element name="a">
                    <xsl:attribute name="href">/fellowship/</xsl:attribute>
                    <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'fellowship/fellowship'" /></xsl:call-template>
                  </xsl:element>
                  <xsl:element name="ul">
                    <xsl:variable name="menu"><xsl:value-of select="@id" /></xsl:variable>
                    <xsl:for-each select="/buildinfo/menuset/menu[@parent='fellowship']">
                      <!--<xsl:sort select="@id"/>-->
                      <xsl:sort select="@priority" />
                      <xsl:variable name="id"><xsl:value-of select="@id" /></xsl:variable>
                      <xsl:element name="li">
                        <xsl:choose>
                          <xsl:when test="not(string(.))">
                            <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="$id" /></xsl:call-template>
                          </xsl:when>
                          <xsl:when test=". = concat(/buildinfo/@filename ,'.html')">
                            <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="$id" /></xsl:call-template>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:element name="a">
                              <xsl:attribute name="href"><xsl:value-of select="." /></xsl:attribute>
                              <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="$id" /></xsl:call-template>
                            </xsl:element>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:element> <!-- /li -->
                    </xsl:for-each>
                  </xsl:element><!-- end ul -->          
                </xsl:element>
              </xsl:element>
            </xsl:element> <!-- /li -->

            <!-- campaigns -->
            <xsl:element name="li">
              <xsl:attribute name="class">campaigns</xsl:attribute>
              <xsl:element name="a">
                <xsl:attribute name="href">/campaigns/campaigns.html</xsl:attribute>
                <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'fsfe/campaigns'" /></xsl:call-template> 
              </xsl:element>

              <xsl:element name="ul">
                <xsl:variable name="menu"><xsl:value-of select="@id" /></xsl:variable>
                        <xsl:for-each select="/buildinfo/menuset/menu[@parent='campaigns']">
                          <!--<xsl:sort select="@id"/>-->
                          <xsl:sort select="@priority" />
                          <xsl:variable name="id"><xsl:value-of select="@id" /></xsl:variable>
                          <xsl:element name="li">
                            <xsl:choose>
                              <xsl:when test="not(string(.))">
                                <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="$id" /></xsl:call-template>
                              </xsl:when>
                              <xsl:when test=". = concat(/buildinfo/@filename ,'.html')">
                                <xsl:element name="span">
                                <xsl:attribute name="id">selected</xsl:attribute>
                                  <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="$id" /></xsl:call-template>
                                </xsl:element>
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:element name="a">
                                  <xsl:attribute name="href"><xsl:value-of select="." /></xsl:attribute>
                                  <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="$id" /></xsl:call-template>
                                </xsl:element>
                              </xsl:otherwise>
                            </xsl:choose>
                          </xsl:element> <!-- /li -->
                        </xsl:for-each>
              </xsl:element>
              <!--/ul-->
            </xsl:element> <!-- /li -->

            <!-- Planet portal menu -->
            <xsl:element name="li">
              <xsl:attribute name="class">planet</xsl:attribute>
              <xsl:element name="a">
                  <xsl:attribute name="href">/news/</xsl:attribute>
                  <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'news/news'" /></xsl:call-template>
              </xsl:element>
              <!-- causes validation errors, needs li to pass validator?
              <xsl:element name="ul">
              </xsl:element>-->

              <xsl:element name="ul">
                <xsl:variable name="menu"><xsl:value-of select="@id" /></xsl:variable>
                        <xsl:for-each select="/buildinfo/menuset/menu[@parent='news']">
                          <!--<xsl:sort select="@id"/>-->
                          <xsl:sort select="@priority" />
                          <xsl:variable name="id"><xsl:value-of select="@id" /></xsl:variable>
                          <xsl:element name="li">
                            <xsl:choose>
                              <xsl:when test="not(string(.))">
                                <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="$id" /></xsl:call-template>
                              </xsl:when>
                              <xsl:when test=". = concat(/buildinfo/@filename ,'.html')">
                                <xsl:element name="span">
                                <xsl:attribute name="id">selected</xsl:attribute>
                                  <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="$id" /></xsl:call-template>
                                </xsl:element>
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:element name="a">
                                  <xsl:attribute name="href"><xsl:value-of select="." /></xsl:attribute>
                                  <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="$id" /></xsl:call-template>
                                </xsl:element>
                              </xsl:otherwise>
                            </xsl:choose>
                          </xsl:element> <!-- /li -->
                        </xsl:for-each>
              </xsl:element>
              <!--/ul-->
            </xsl:element>
            
            <!-- Legal team portal menu -->
            <xsl:element name="li">
              <xsl:attribute name="class">ftf</xsl:attribute>
              <xsl:element name="a">
                  <xsl:attribute name="href">/legal/</xsl:attribute>
                  <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'ftf/legal'" /></xsl:call-template>
              </xsl:element>
              <!-- causes validation errors, needs li to pass validator?
              <xsl:element name="ul">
              </xsl:element>-->

              <xsl:element name="ul">
                <xsl:variable name="menu"><xsl:value-of select="@id" /></xsl:variable>
                        <xsl:for-each select="/buildinfo/menuset/menu[@parent='ftf']">
                          <!--<xsl:sort select="@id"/>-->
                          <xsl:sort select="@priority" />
                          <xsl:variable name="id"><xsl:value-of select="@id" /></xsl:variable>
                          <xsl:element name="li">
                            <xsl:choose>
                              <xsl:when test="not(string(.))">
                                <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="$id" /></xsl:call-template>
                              </xsl:when>
                              <xsl:when test=". = concat(/buildinfo/@filename ,'.html')">
                                <xsl:element name="span">
                                <xsl:attribute name="id">selected</xsl:attribute>
                                  <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="$id" /></xsl:call-template>
                                </xsl:element>
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:element name="a">
                                  <xsl:attribute name="href"><xsl:value-of select="." /></xsl:attribute>
                                  <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="$id" /></xsl:call-template>
                                </xsl:element>
                              </xsl:otherwise>
                            </xsl:choose>
                          </xsl:element> <!-- /li -->
                        </xsl:for-each>
              </xsl:element>
              <!--/ul-->
            </xsl:element>

            <!-- free software section portal menu -->
            <xsl:element name="li">
              <xsl:attribute name="class">fs</xsl:attribute>
              <xsl:element name="a">
                  <xsl:attribute name="href">/freesoftware/</xsl:attribute>
                  <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'fs/fs'" /></xsl:call-template>
              </xsl:element>
              <!-- causes validation errors, needs li to pass validator?
              <xsl:element name="ul">
              </xsl:element>-->

              <xsl:element name="ul">
                <xsl:variable name="menu"><xsl:value-of select="@id" /></xsl:variable>
                        <xsl:for-each select="/buildinfo/menuset/menu[@parent='fs']">
                          <!--<xsl:sort select="@id"/>-->
                          <xsl:sort select="@priority" />
                          <xsl:variable name="id"><xsl:value-of select="@id" /></xsl:variable>
                          <xsl:element name="li">
                            <xsl:choose>
                              <xsl:when test="not(string(.))">
                                <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="$id" /></xsl:call-template>
                              </xsl:when>
                              <xsl:when test=". = concat(/buildinfo/@filename ,'.html')">
                                <xsl:element name="span">
                                <xsl:attribute name="id">selected</xsl:attribute>
                                  <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="$id" /></xsl:call-template>
                                </xsl:element>
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:element name="a">
                                  <xsl:attribute name="href"><xsl:value-of select="." /></xsl:attribute>
                                  <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="$id" /></xsl:call-template>
                                </xsl:element>
                              </xsl:otherwise>
                            </xsl:choose>
                          </xsl:element> <!-- /li -->
                        </xsl:for-each>
              </xsl:element>
              <!--/ul-->
            </xsl:element>
              
          </xsl:element>
          <!--/ul#menu-list-->
        </xsl:element>
        <!--/nav#full-menu-->

        <xsl:element name="hr" />

        <xsl:element name="section">
          <xsl:attribute name="id">source</xsl:attribute>

          <!-- "Last changed" magic -->
          <p>
            <xsl:variable name="timestamp">
              <xsl:value-of select="/buildinfo/document/timestamp"/>
            </xsl:variable>
                <!-- FIXME: over time, all pages should have the timestamp -->
                <!--        tags, so this conditional could be removed     -->
            <xsl:if test="string-length($timestamp) &gt; 0">
              <xsl:variable name="Date">
                <xsl:value-of select="substring-before(substring-after($timestamp, 'Date: '), ' $')"/>
              </xsl:variable>
              <xsl:variable name="Author">
                <xsl:value-of select="substring-before(substring-after($timestamp, 'Author: '), ' $')"/>
              </xsl:variable>
              <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'lastchanged'" /></xsl:call-template>
              <xsl:value-of select="translate ($Date, '/', '-')"/>
              (<xsl:value-of select="$Author"/>)
            </xsl:if>
          </p>

          <ul>
            <li>
              <!-- Link to the XHTML source -->
              <xsl:element name="a">
                <xsl:attribute name="href">
                  <xsl:text>/source</xsl:text>
                  <xsl:value-of select="/buildinfo/@filename"/>
                  <xsl:text>.</xsl:text>
                  <xsl:value-of select="/buildinfo/document/@language"/>
                  <xsl:text>.xhtml</xsl:text>
                </xsl:attribute>
                <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'source'" /></xsl:call-template>
              </xsl:element>
            </li>
            <li>
                <a href="/contribute/web/"><xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'contribute-web'" /></xsl:call-template></a>
            </li>
          </ul>

          <p>
            <a href="/contribute/translators/">
              <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'translate'" /></xsl:call-template>
            </a>
            <!-- Insert the appropriate translation notice -->
            <xsl:if test="/buildinfo/document/@language!=/buildinfo/@original">
              <xsl:element name="br"></xsl:element>
              <xsl:choose>
                <xsl:when test="/buildinfo/document/translator">
                  <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'translator1a'" /></xsl:call-template>
                  <xsl:value-of select="/buildinfo/document/translator"/>
                  <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'translator1b'" /></xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'translator2'" /></xsl:call-template>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'translator3a'" /></xsl:call-template>
              <xsl:element name="a">
                <xsl:attribute name="href">
                  <xsl:value-of select="/buildinfo/@filename"/>
                  <xsl:text>.en.html</xsl:text>
                </xsl:attribute>
                <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'translator3b'" /></xsl:call-template>
              </xsl:element>
              <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'translator3c'" /></xsl:call-template>
            </xsl:if>
          </p>
      
        </xsl:element>
        <!--/section#source-->

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
        <!--/section#legal-info-->

        <xsl:element name="section">
          <xsl:attribute name="id">sister-organisations</xsl:attribute>

          <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'fsfnetwork'" /></xsl:call-template>
        </xsl:element>
        <!--/section#sister-organisations-->

      </xsl:element>
      <!--/footer#bottom-->
    



	<!-- Piwik -->
	<script type="text/javascript">
	//enable piwik on plain text page only
	pkBaseURL = "http://piwik.fsfe.org/";
	if ("http:" == document.location.protocol) {
	  document.write(unescape("%3Cscript src='" + pkBaseURL + "piwik.js' type='text/javascript'%3E%3C/script%3E"));
	}
	</script>
	<script type="text/javascript">
	try {
	var piwikTracker = Piwik.getTracker(pkBaseURL + "piwik.php", 4);
	piwikTracker.trackPageView();
	piwikTracker.enableLinkTracking();
	} catch( err ) {}
	</script>
	<!-- End Piwik Tracking Code -->

        <script src="/scripts/bootstrap-3.0.3.min.js"></script>
        <script src="/scripts/master.js"></script>
        <script src="/scripts/placeholder.js"></script>
        <script src="/scripts/highlight.pack.js"></script>
    </body>
  </xsl:template>

  <!-- Insert local menu -->
  <xsl:template match="localmenu">
    <xsl:variable name="set">
      <xsl:choose>
    <xsl:when test="@set">
      <xsl:value-of select="@set"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>0</xsl:text>
    </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="dir">
      <xsl:value-of select="/buildinfo/@dirname"/>
    </xsl:variable>
    <xsl:variable name="language">
      <xsl:value-of select="/buildinfo/@language"/>
    </xsl:variable>
    <xsl:element name="div">
      <xsl:attribute name="class">localmenu</xsl:attribute>
      <xsl:element name="p">
    <xsl:text>[ </xsl:text>
    <xsl:for-each select="/buildinfo/localmenuset/localmenuitems/menu[@dir=$dir and @set=$set]">
      <xsl:sort select="@id"/>
      <xsl:variable name="style"><xsl:value-of select="@style"/></xsl:variable>
      <xsl:variable name="id"><xsl:value-of select="@id"/></xsl:variable>
      <xsl:variable name="localmenutext">
        <xsl:choose>
          <xsl:when
        test="/buildinfo/localmenuset/translate/lang_part[@dir=$dir and @id=$id and @language=$language]">
        <xsl:value-of
          select="/buildinfo/localmenuset/translate/lang_part[@dir=$dir and @id=$id and @language=$language]"/>
          </xsl:when>
          <xsl:otherwise>
        <xsl:value-of
          select="/buildinfo/localmenuset/translate/lang_part[@dir=$dir and @id=$id and @language='en']"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:element name="span">
        <xsl:attribute name="class">local_menu_item</xsl:attribute>
        <xsl:choose>
          <xsl:when test="not(substring-before(concat(/buildinfo/@filename ,'.html'), string(.)))">
        <xsl:element name="a">
          <xsl:attribute name="href"><xsl:value-of select="."/></xsl:attribute>
          <xsl:value-of select="$localmenutext"/>
        </xsl:element>
          </xsl:when>
          <xsl:otherwise>
        <xsl:attribute name="href">bamboo</xsl:attribute>
          <xsl:value-of select="$localmenutext"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:element>
      <xsl:if test="position()!=last()">
        <xsl:choose>
          <xsl:when test="$style='number'">
        <xsl:text> | </xsl:text>
          </xsl:when>
          <xsl:otherwise>
        <xsl:text> ] [ </xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
    </xsl:for-each>
    <xsl:text> ]</xsl:text>
    
      </xsl:element><!--end wrapper-->
    </xsl:element>
  </xsl:template>

  <!-- Ignore "latin" tags, used only for pritable material -->
  <xsl:template match="latin">
    <xsl:apply-templates select="@*|node()"/>
  </xsl:template>
  
  <!-- If no template matching <body> is found in the current page's XSL file, this one will be used -->
  <xsl:template match="body" priority="-1">
    <xsl:apply-templates />
  </xsl:template>
  
  <!-- Do not copy non-HTML elements to output -->
  <xsl:template match="timestamp|
               buildinfo/document/translator|
               buildinfo/set|
               buildinfo/textset|
               buildinfo/textsetbackup|
               buildinfo/menuset|
               buildinfo/trlist|
               buildinfo/fundraising|
               buildinfo/localmenuset|
               buildinfo/document/tags|
               buildinfo/document/legal|
               buildinfo/document/author|
               buildinfo/document/date|
               buildinfo/document/download|
               buildinfo/document/followup"/>
  
  <xsl:template match="set | tags | text"/>

  <!-- For all other nodes, copy verbatim -->
  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="@dt:*">
    <xsl:attribute name="{local-name()}">
      <xsl:value-of select="." />
    </xsl:attribute>
  </xsl:template>
  
  <!--
  <xsl:template match="@x:*">
    <xsl:attribute name="{local-name()}">
      <xsl:value-of select="." />
    </xsl:attribute>
  </xsl:template>
  -->
 <!--FIXME ↓-->
  <xsl:template match="fetch-news">
    <xsl:call-template name="fetch-news">
      <xsl:with-param name="tag" select="'/buildinfo/document/sidebar/@news'"/>
      <xsl:with-param name="nb-items" select="4"/>
    </xsl:call-template>
  </xsl:template>


</xsl:stylesheet>

