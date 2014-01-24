<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../tools/xsltsl/translations.xsl" />
  <xsl:import href="../tools/xsltsl/static-elements.xsl" />

  <!-- HTML 5 compatibility doctype, since our XSLT parser doesn't support disabling output escaping -->
  <xsl:output method="html" encoding="utf-8" indent="yes" doctype-system="about:legacy-compat" />
  
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
    <xsl:copy>

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
      <xsl:variable name="urlprefix"><xsl:if test="/buildinfo/document/@external">https://www.fsfe.org</xsl:if></xsl:variable>
      
      <xsl:element name="link">
        <xsl:attribute name="rel">stylesheet</xsl:attribute>
        <xsl:attribute name="media">all</xsl:attribute>
        <xsl:attribute name="href"><xsl:value-of select="$urlprefix"/>/look/generic.css</xsl:attribute>
        <xsl:attribute name="type">text/css</xsl:attribute>
      </xsl:element>

      <xsl:element name="link">
        <xsl:attribute name="rel">stylesheet</xsl:attribute>
        <xsl:attribute name="media">all</xsl:attribute>
        <xsl:attribute name="href"><xsl:value-of select="$urlprefix"/>/look/fellowship.css</xsl:attribute>
        <xsl:attribute name="type">text/css</xsl:attribute>
      </xsl:element>
      
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
        <xsl:attribute name="href"><xsl:value-of select="$urlprefix"/>/graphics/fsfe.ico</xsl:attribute>
        <xsl:attribute name="type">image/x-icon</xsl:attribute>
      </xsl:element>
      
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
      
      <script type="text/javascript" src="/scripts/jquery.js"></script>
      <script type="text/javascript" src="/scripts/master.js"></script>
      <script type="text/javascript" src="/scripts/placeholder.js"></script>
      
      <xsl:comment>
        <![CDATA[
          [if lt IE 8]>
            <script src="http://ie7-js.googlecode.com/svn/version/2.1(beta4)/IE8.js"></script>
          <![endif]
        ]]>
      </xsl:comment>
      
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
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
    
    
    <!-- copy original <h1> -->
    <xsl:copy>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
    
    
    <!-- Apply news page rules -->
    <xsl:if test="string(/buildinfo/document/@newsdate) and
                    (not(string(/buildinfo/document/@type)) or
                    /buildinfo/document/@type != 'newsletter')">
      
      <!-- add publishing information (author, date) -->
      <xsl:element name="div">
        <xsl:attribute name="id">article-metadata</xsl:attribute>
          <xsl:element name="p">
            <span class="label"> <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'published'" /></xsl:call-template>: </span><xsl:value-of select="/buildinfo/document/@newsdate" />
          </xsl:element>
      </xsl:element>
      
    </xsl:if>
    <!-- End apply news page rules -->
    
    <!-- Apply newsletter page -->
    <xsl:if test="string(/buildinfo/document/@newsdate) and /buildinfo/document/@type = 'newsletter'">
      <xsl:call-template name="subscribe-nl" />
    </xsl:if>
    <!-- End apply newsletter page rules -->
    
    <!-- Apply article rules -->
    <xsl:if test = "string(/buildinfo/document/head/meta[@name='author-name-1']/@content)">
      <xsl:element name="div">
        <xsl:attribute name="id">article-metadata</xsl:attribute>
        
        <xsl:element name="p">
          <xsl:if test = "string(/buildinfo/document/head/meta[@name='author-name-1']/@content)">
            <span class="label"><xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'author'" /></xsl:call-template>: </span>
            <xsl:choose>
              <xsl:when test="/buildinfo/document/head/meta[@name='author-link-1']">
                <xsl:variable name="author-link-1" select="/buildinfo/document/head/meta[@name='author-link-1']/@content" />
                <a rel='author' href='{$author-link-1}'>
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
                , <a rel='author' href='{$author-link-2}'>
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
                , <a rel='author' href='{$author-link-3}'>
                <xsl:value-of select="/buildinfo/document/head/meta[@name='author-name-3']/@content" /> </a> 
              </xsl:when>
              <xsl:otherwise>
                , <xsl:value-of select="/buildinfo/document/head/meta[@name='author-name-3']/@content" /> 
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
      
          <span class="label"> <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'published'" /></xsl:call-template>: </span><xsl:value-of select="/buildinfo/document/head/meta[@name='publication-date']/@content" />
          
          <xsl:if test = "string(/buildinfo/document/head/meta[@name='pdf-link']/@content)">
            <span class="label">PDF: </span>
            <xsl:variable name="pdf-link" select="/buildinfo/document/head/meta[@name='pdf-link']/@content" />
            <a href='{$pdf-link}'>download</a>
          </xsl:if>
          
        </xsl:element> <!-- </p> -->
      </xsl:element> <!-- </div> -->
    </xsl:if>
    <!-- End Apply article rules -->
         
  </xsl:template>
  <!-- End modifications to H1 -->  

  <!-- HTML body -->
  <xsl:template name="fsfe-body">
    <body>

      <!-- For pages used on external web servers, use absolute URLs -->
      <xsl:variable name="urlprefix"><xsl:if test="/buildinfo/document/@external">https://fsfe.org</xsl:if></xsl:variable>

      <!-- First of all, a comment to make clear this is generated -->
      <xsl:comment>This file was generated by an XSLT script. Please do not edit.</xsl:comment>

      <!-- This marker is needed by /tools/make_fellowship_templates.sh -->
      <xsl:comment>Start-fellowship-header</xsl:comment>

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

      <xsl:element name="div">
        <xsl:attribute name="id">wrapper</xsl:attribute>
    <xsl:element name="div">
      <xsl:attribute name="id">wrapper-inner</xsl:attribute>
      <xsl:comment>Unnecessary div, for IE only</xsl:comment>

      <xsl:element name="p">
          <xsl:attribute name="class">n</xsl:attribute>
          <xsl:comment>Give non-graphical browsers a way to skip the menu.</xsl:comment>
          <xsl:element name="a">
        <xsl:attribute name="href">#content</xsl:attribute>
        <xsl:text>Skip menu</xsl:text>
          </xsl:element>
        </xsl:element>
      
        <!-- Page header -->
        <xsl:element name="div">
          <xsl:attribute name="id">header</xsl:attribute>

          <!-- Logo -->
          <xsl:element name="div">
        <xsl:attribute name="id">logo</xsl:attribute>
        <xsl:element name="a">
          <xsl:attribute name="href">/fellowship</xsl:attribute>
          <xsl:element name="img">
            <xsl:attribute name="alt">FSFE Fellowship Logo</xsl:attribute>
            <xsl:attribute name="src"><xsl:value-of select="$urlprefix"/>/graphics/fellowship/fellowship-page-logo-300x91.png</xsl:attribute>
          </xsl:element>
        </xsl:element>
          </xsl:element>
          
          <!-- Statement -->
          <xsl:element name="p">
            
            <xsl:attribute name="id">statement</xsl:attribute>
            
            <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'statement1'" /></xsl:call-template>
            <xsl:element name="a">
              <xsl:attribute name="href">/freesoftware/index.<xsl:value-of select="/buildinfo/@language"/>.html</xsl:attribute>
              <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'statement-fs'" /></xsl:call-template>
            </xsl:element>
            <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'statement2'" /></xsl:call-template>.<!--intentional full stop goes here-->
            
            <xsl:element name="a">
              <xsl:attribute name="href">/about</xsl:attribute>
              <xsl:attribute name="style">padding-left: 1em;</xsl:attribute>
              <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'learn-more'" />
            </xsl:call-template>
            </xsl:element>.<!--intentional full stop goes here-->
            
          </xsl:element>
          
        </xsl:element><!-- end Page header -->
        
        <!-- Sidebar -->
        <xsl:element name="div">
          <xsl:attribute name="id">sidebar</xsl:attribute>
    
          <!-- Menu -->
          <xsl:element name="div">
      <xsl:attribute name="id">menu</xsl:attribute>
      
      <xsl:element name="ul">

        <!-- Fellowship portal menu -->
        <xsl:element name="li">
    <xsl:attribute name="class">fellowship</xsl:attribute>

    <xsl:element name="a">
      <xsl:attribute name="href">/fellowship/join</xsl:attribute>
      <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'fellowship/fellowship'" /></xsl:call-template>
    </xsl:element>

    <xsl:element name="ul">
      <xsl:variable name="menu"><xsl:value-of select="@id" /></xsl:variable>

      <xsl:for-each select="/buildinfo/menuset/menu[@parent='fellowship']">
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
        </xsl:element>
      </xsl:for-each>
    </xsl:element>
        </xsl:element>
        
        <!-- FSFE portal menu -->
        <xsl:element name="li">
    <xsl:attribute name="class">fsfe</xsl:attribute>

    <xsl:element name="a">
      <xsl:attribute name="href">/</xsl:attribute>
      <xsl:text>FSFE</xsl:text>
    </xsl:element>

    <xsl:element name="ul">       
      <xsl:variable name="menu"><xsl:value-of select="@id" /></xsl:variable>

      <xsl:for-each select="/buildinfo/menuset/menu[@parent='fsfe']">
        <xsl:sort select="@priority" />
        <xsl:variable name="id"><xsl:value-of select="@id" /></xsl:variable>
        <xsl:element name="li">
          <xsl:choose>

      <!-- <menu id="fsfe" /> (illformed XML header for menu) -->
      <xsl:when test="not(string(.))">
        <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="$id" /></xsl:call-template>
      </xsl:when>

      <!-- Selected menu item, we're on this page -->
      <xsl:when test=". = concat(/buildinfo/@filename ,'.html')">
        <xsl:element name="span">
          <xsl:attribute name="id">selected</xsl:attribute>
          <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="$id" /></xsl:call-template>
        </xsl:element>
      </xsl:when>

      <!-- Regular menu item, nonselected -->
      <xsl:otherwise>
        <xsl:element name="a">
          <xsl:attribute name="href"><xsl:value-of select="." /></xsl:attribute>
          <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="$id" /></xsl:call-template>
        </xsl:element>
      </xsl:otherwise>

          </xsl:choose>     
        </xsl:element>
      </xsl:for-each>
    </xsl:element>
        </xsl:element>

        <!-- Planet portal menu -->
        <xsl:element name="li">
    <xsl:attribute name="class">planet</xsl:attribute>
    <xsl:element name="a">
      <xsl:attribute name="href">http://planet.fsfe.org/</xsl:attribute>
      <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'planet/blogs'" /></xsl:call-template>
    </xsl:element>
    <!-- causes validation errors, needs li to pass validator?
         <xsl:element name="ul">
         
         </xsl:element>-->
        </xsl:element>
        


        <!-- Wiki -->
        <xsl:element name="li">
    <xsl:attribute name="class">wiki</xsl:attribute>
    <xsl:element name="a">
      <xsl:attribute name="href">http://wiki.fsfe.org/</xsl:attribute>
      Wiki
    </xsl:element>
        </xsl:element> <!-- /li -->
      </xsl:element> <!-- /ul -->

      
    </xsl:element><!-- end menu -->
        
        <xsl:element name="div">
          <xsl:attribute name="id">search</xsl:attribute>
          
          <xsl:element name="h2">
            <xsl:attribute name="class">n</xsl:attribute>
            <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'search'" /></xsl:call-template>
          </xsl:element>

          <xsl:element name="form">
        <xsl:attribute name="method">get</xsl:attribute>
        <xsl:attribute name="action">http://search.fsfe.org/yacysearch.html</xsl:attribute>

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
              <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'submit'" /></xsl:call-template>
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
        </xsl:element><!-- End search -->

        <!-- Newsletter form
        <xsl:element name="div">
          <xsl:attribute name="id">newsletter</xsl:attribute>
        
        <xsl:element name="h2">
          <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'receive-newsletter'" /></xsl:call-template>
        </xsl:element>

        <xsl:element name="form">
          <xsl:attribute name="method">get</xsl:attribute>
          <xsl:attribute name="action">http://search.fsfe.org/yacysearch.html</xsl:attribute>

          <xsl:element name="p">
          
            <xsl:element name="select">
              <xsl:attribute name="name">lang</xsl:attribute>
            <option><xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'language'" /></xsl:call-template></option>
            </xsl:element>
            
          </xsl:element>
          <xsl:element name="p">
            
            <xsl:element name="input">
              <xsl:attribute name="type">image</xsl:attribute>
              <xsl:attribute name="src">/graphics/icons/search-button.png</xsl:attribute>
            </xsl:element>
          
            <xsl:element name="input">
              <xsl:attribute name="type">text</xsl:attribute>
              <xsl:attribute name="name">query</xsl:attribute>
              <xsl:attribute name="placeholder">
            email@example.org
              </xsl:attribute>          
          </xsl:element>
        </xsl:element>
          </xsl:element>
        </xsl:element>
        end Newsletter form -->
        
        <!-- translations -->
        <xsl:element name="div">
        <xsl:attribute name="id">translations</xsl:attribute>
        <xsl:element name="ul">
          <xsl:for-each select="/buildinfo/trlist/tr">
        <xsl:sort select="@id"/>
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
        </xsl:element><!-- end translations -->
        
      </xsl:element><!-- End sidebar -->

      </xsl:element>
      
      <xsl:element name="div">
        <xsl:attribute name="id">content</xsl:attribute>
        
        <!-- Outdated note -->
        <xsl:if test="/buildinfo/@outdated='yes'">
          <xsl:element name="p">
        <xsl:attribute name="class">warning red</xsl:attribute>
        <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'outdated'" /></xsl:call-template>
          </xsl:element>
        </xsl:if>
        
        <!-- Missing translation note -->
        <xsl:if test="/buildinfo/@language!=/buildinfo/document/@language">
          <xsl:element name="p">
        <xsl:attribute name="class">warning red</xsl:attribute>
        <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'notranslation'" /></xsl:call-template>
          </xsl:element>
        </xsl:if>
            
        <!-- Info box -->
        <xsl:element name="div">
          <xsl:attribute name="id">infobox</xsl:attribute>
          <xsl:if test = "/buildinfo/document/head/meta[@name='under-construction' and @content='true']">
        <xsl:element name="p">
          <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'under-construction'" /></xsl:call-template>
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

        <!-- This marker is needed by /tools/make_fellowship_templates.sh -->
        <xsl:comment>Stop-fellowship-header</xsl:comment>

        <!-- Here goes the actual content of the <body> node of the input file -->
        <xsl:apply-templates select="body"/>

        <!-- This marker is needed by /tools/make_fellowship_templates.sh -->
        <xsl:comment>Start-fellowship-footer</xsl:comment>

        <!-- Link to top -->
        <xsl:element name="p">
          <xsl:attribute name="class">n</xsl:attribute>
          <xsl:element name="a">
        <xsl:attribute name="href">#top</xsl:attribute>
        <xsl:text>To top</xsl:text>
          </xsl:element>
        </xsl:element>
      </xsl:element>
      <!-- End Content -->

    </xsl:element><!--end wrapper-inner-->
    
    <!-- Footer -->
    <div id="footer">
      <div id="notice">
        <p>
          Copyright © 2001-2011 <a href="/">Free Software
        Foundation Europe</a>. <strong>
        <a href="/contact/contact.html">
          <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'contact-us'" /></xsl:call-template>
        </a></strong>.<br />

          <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'permission'" /></xsl:call-template><br />

          <!-- "Last changed" magic -->
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
        <a href="/contribute/translators/">
          <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'translate'" /></xsl:call-template>
        </a>
          </li>
        </ul>

        <p>
          <!-- Insert the appropriate translation notice -->
          <xsl:if test="/buildinfo/document/@language!=/buildinfo/@original">
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
      </div> <!-- /#notice -->          
      
      <!-- Sister organizations -->
      <xsl:element name="div">
        <xsl:attribute name="id">sister-organisations</xsl:attribute>        
        <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'fsfnetwork'" /></xsl:call-template>
      </xsl:element>
      
    </div> <!-- /#footer -->

      <!-- Piwik -->
      <script type="text/javascript">
      //var pkBaseURL = (("https:" == document.location.protocol) ? "https://piwik.fsfe.org/" : "http://piwik.fsfe.org/");
      //document.write(unescape("%3Cscript src='" + pkBaseURL + "piwik.js' type='text/javascript'%3E%3C/script%3E"));
      
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
      </script><noscript><p><img src="http://piwik.fsfe.org/piwik.php?idsite=4" style="border:0" alt="" /></p></noscript>
      <!-- End Piwik Tracking Code -->
    
      </xsl:element>
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

  <!-- Do not copy non-HTML elements to output -->
  <xsl:template match="timestamp|
               translator|
               buildinfo/set|
               buildinfo/textset|
               buildinfo/textsetbackup|
               buildinfo/menuset|
               buildinfo/trlist|
               buildinfo/fundraising|
               buildinfo/localmenuset|
               tags"/>

  <!-- For all other nodes, copy verbatim -->
  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>
  <!--
  <xsl:template match="@x:*">
    <xsl:attribute name="{local-name()}">
      <xsl:value-of select="." />
    </xsl:attribute>
  </xsl:template>
  -->
</xsl:stylesheet>
