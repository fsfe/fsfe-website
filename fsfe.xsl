<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!--
  <xsl:output method="html" encoding="utf-8" indent="yes"
    doctype-public="-//W3C//DTD HTML 4.0 Transitional//EN"
    doctype-system="http://www.w3.org/TR/REC-html40/loose.dtd"/>
  -->

  <xsl:output method="html" encoding="utf-8" indent="yes" doctype-public="html" />

  <!-- The top level element of the input file is "buildinfo" -->
  <xsl:template match="buildinfo">
    <xsl:apply-templates select="node()"/>
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
      <xsl:apply-templates select="node()"/>
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
      <link rel="stylesheet" media="all" href="/look/generic.css" type="text/css" />
      <link rel="stylesheet" media="print" href="/look/print.css" type="text/css" />
      <xsl:if test="/buildinfo/@language='ar'">
        <link rel="stylesheet" media="all" href="/look/rtl.css" type="text/css" />
      </xsl:if>
      <link rel="shortcut icon" href="/graphics/fsfe.ico" type="image/x-icon" />
      <xsl:element name="link">
        <xsl:attribute name="rel">alternate</xsl:attribute>
        <xsl:attribute name="title">FSFE <xsl:value-of select="/buildinfo/textset/text[@id='menu1/news']" /></xsl:attribute>
        <xsl:attribute name="href">/news/news.<xsl:value-of select="/buildinfo/@language" />.rss</xsl:attribute>
        <xsl:attribute name="type">application/rss+xml</xsl:attribute>
      </xsl:element>
      <xsl:element name="link">
        <xsl:attribute name="rel">alternate</xsl:attribute>
        <xsl:attribute name="title">FSFE <xsl:value-of select="/buildinfo/textset/text[@id='menu1/events']" /></xsl:attribute>
        <xsl:attribute name="href">/events/events.<xsl:value-of select="/buildinfo/@language" />.rss</xsl:attribute>
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
    <xsl:copy>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
    
    <!-- Apply news page rules -->
    <xsl:if test="string(/buildinfo/document/html/@newsdate)">
      <xsl:element name="div">
      <xsl:attribute name="id">article-metadata</xsl:attribute>
	<xsl:element name="p">
	  <span class="label"> <xsl:apply-templates select="/buildinfo/textset/text[@id='published']/node()" />: </span><xsl:value-of select="/buildinfo/document/html/@newsdate" />
	</xsl:element>
      </xsl:element>
    </xsl:if> 
    <!-- End apply news page rules -->
    
    <!-- Apply article rules -->
    <xsl:if test = "string(/buildinfo/document/head/meta[@name='author-name-1']/@content)">
      <xsl:element name="div">
      <xsl:attribute name="id">article-metadata</xsl:attribute>
      <xsl:element name="p">
	<xsl:if test = "string(/buildinfo/document/head/meta[@name='author-name-1']/@content)">
	  <span class="label"><xsl:apply-templates select="/buildinfo/textset/text[@id='author']/node()" />: </span>
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
	
	  <span class="label"> <xsl:apply-templates select="/buildinfo/textset/text[@id='published']/node()" />: </span><xsl:value-of select="/buildinfo/document/head/meta[@name='publication-date']/@content" />
	  
	  <xsl:if test = "string(/buildinfo/document/head/meta[@name='pdf-link']/@content)">
	    <span class="label">PDF: </span>
	    <xsl:variable name="pdf-link" select="/buildinfo/document/head/meta[@name='pdf-link']/@content" />
	    <a href='{$pdf-link}'>download</a>
	  </xsl:if>
	  
	</xsl:element>
      </xsl:element>
    </xsl:if>
    <!-- End Apply article rules -->
	     
  </xsl:template>
  <!-- End modifications to H1 -->  

  <!-- HTML body -->
  <xsl:template match="body">
    <xsl:copy>

      <!-- First of all, a comment to make clear this is generated -->
      <xsl:comment>This file was generated by an XSLT script. Please do not edit.</xsl:comment>

      <!-- Service notice (for downtime, upgrades, etc. enable this) -->
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
      </div>

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
		  <xsl:attribute name="href">/</xsl:attribute>
		  <xsl:element name="img">
		    <xsl:attribute name="alt">FSFE Logo</xsl:attribute>
		    <xsl:attribute name="src">/graphics/logo.png</xsl:attribute>
		  </xsl:element>
		</xsl:element>
	      </xsl:element>
	      
	      <!-- Statement -->
	      <xsl:element name="p">
		<xsl:attribute name="id">statement</xsl:attribute>
		Free Software Foundation Europe is a non-profit organisation dedicated
		to the furthering of Free Software, and works to promote freedom in emerging
		digital society. <a href="/about">Learn more</a>
	      </xsl:element>
	      
	    </xsl:element><!-- end Page header -->
	    
	    <!-- Sidebar -->
	    <xsl:element name="div">
	      <xsl:attribute name="id">sidebar</xsl:attribute>
		
	      <!-- Menu -->
	      <xsl:element name="div">
		<xsl:attribute name="id">menu</xsl:attribute>
		
		<xsl:element name="ul">
		
		  <!-- FSFE portal menu -->
		  <xsl:element name="li">
		    <xsl:attribute name="class">fsfe</xsl:attribute>
		    <xsl:element name="a">
		      <xsl:attribute name="href">/</xsl:attribute>
		      FSFE
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
				<xsl:value-of select="/buildinfo/textset/text[@id=$id]|
								/buildinfo/textsetbackup/text[@id=$id
								and not(@id=/buildinfo/textset/text/@id)]"/>
			      </xsl:when>
			      <xsl:when test=". = concat(/buildinfo/@filename ,'.html')">
				<xsl:element name="span">
				<xsl:attribute name="id">selected</xsl:attribute>
				<xsl:value-of select="/buildinfo/textset/text[@id=$id]| /buildinfo/textsetbackup/text[@id=$id and not(@id=/buildinfo/textset/text/@id)]"/>
				</xsl:element>
			      </xsl:when>
			      <xsl:otherwise>
				<xsl:element name="a">
				  <xsl:attribute name="href"><xsl:value-of select="." /></xsl:attribute>
				  <xsl:value-of select="/buildinfo/textset/text[@id=$id]|
								  /buildinfo/textsetbackup/text[@id=$id
								  and not(@id=/buildinfo/textset/text/@id)]"/>
				</xsl:element>
			      </xsl:otherwise>
			    </xsl:choose>
			  
			  </xsl:element> <!-- /li -->
			</xsl:for-each>

		      </xsl:element>

		  </xsl:element> <!-- /li -->
		  
		  <!-- Planet portal menu -->
		  <xsl:element name="li">
		    <xsl:attribute name="class">planet</xsl:attribute>
		    <xsl:element name="a">
		      <xsl:attribute name="href">http://planet.fsfe.org</xsl:attribute>
		      Planet
		    </xsl:element>
		    <!-- causes validation errors, needs li to pass validator?
		    <xsl:element name="ul">
		    
		    </xsl:element>-->
		  </xsl:element>
		  
		  <!-- Fellowship portal menu -->
		  <xsl:element name="li">
		    <xsl:attribute name="class">fellowship</xsl:attribute>
		    <xsl:element name="a">
		      <xsl:attribute name="href">http://fellowship.fsfe.org</xsl:attribute>
		      Fellowship
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
				<xsl:value-of select="/buildinfo/textset/text[@id=$id]|
								/buildinfo/textsetbackup/text[@id=$id
								and not(@id=/buildinfo/textset/text/@id)]"/>
			      </xsl:when>
			      <xsl:when test=". = concat(/buildinfo/@filename ,'.html')">
				<xsl:value-of select="/buildinfo/textset/text[@id=$id]|
								/buildinfo/textsetbackup/text[@id=$id
								and not(@id=/buildinfo/textset/text/@id)]"/>
			      </xsl:when>
			      <xsl:otherwise>
				<xsl:element name="a">
				  <xsl:attribute name="href"><xsl:value-of select="." /></xsl:attribute>
				  <xsl:value-of select="/buildinfo/textset/text[@id=$id]|
								  /buildinfo/textsetbackup/text[@id=$id
								  and not(@id=/buildinfo/textset/text/@id)]"/>
				</xsl:element>
			      </xsl:otherwise>
			    </xsl:choose>
			  
			  </xsl:element> <!-- /li -->
			</xsl:for-each>
		      </xsl:element><!-- end li -->
		    </xsl:element><!-- end ul -->		  
		
		</xsl:element><!-- end ul -->

	    
	      </xsl:element><!-- end menu -->
	    
	    <xsl:element name="div">
	      <xsl:attribute name="id">search</xsl:attribute>
	      
	      <xsl:element name="h2">
		<xsl:attribute name="class">n</xsl:attribute>
		<xsl:value-of select="/buildinfo/textset/text[@id='search']" />
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
		  <!--<xsl:element name="input">
		    <xsl:attribute name="type">image</xsl:attribute>
		    <xsl:attribute name="src">/graphics/icons/search-button.png</xsl:attribute>
		  </xsl:element>-->

		  <xsl:element name="input">
		    <xsl:attribute name="type">text</xsl:attribute>
		    <xsl:attribute name="name">query</xsl:attribute>
		    <xsl:attribute name="placeholder">
		      <xsl:value-of select="/buildinfo/textset/text[@id='search']" />
		    </xsl:attribute>
		  </xsl:element>

		  <xsl:element name="input">
		    <xsl:attribute name="type">submit</xsl:attribute>
		    <xsl:attribute name="name">search</xsl:attribute>
		    <xsl:attribute name="value">Submit</xsl:attribute>
		  </xsl:element>

		</xsl:element>
	      </xsl:element>
	    </xsl:element><!-- End search -->

	    <!-- Newsletter form
	    <xsl:element name="div">
	      <xsl:attribute name="id">newsletter</xsl:attribute>
		
		<xsl:element name="h2">
		  <xsl:value-of select="/buildinfo/textset/text[@id='receive-newsletter']" />
		</xsl:element>

		<xsl:element name="form">
		  <xsl:attribute name="method">get</xsl:attribute>
		  <xsl:attribute name="action">http://search.fsfe.org/yacysearch.html</xsl:attribute>

		  <xsl:element name="p">
		  
		    <xsl:element name="select">
		      <xsl:attribute name="name">lang</xsl:attribute>
			<option><xsl:value-of select="/buildinfo/textset/text[@id='language']" /></option>
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
		<xsl:apply-templates select="/buildinfo/textset/text[@id='outdated']/node()" />
	      </xsl:element>
	    </xsl:if>
	    
	    <!-- Missing translation note -->
	    <xsl:if test="/buildinfo/@language!=/buildinfo/document/@language">
	      <xsl:element name="p">
		<xsl:apply-templates select="/buildinfo/textset/text[@id='notranslation']/node()" />
	      </xsl:element>
	    </xsl:if>
	    <!-- Missing translation note -->
	        
	    <!-- Start info box -->
	    <xsl:element name="div"> 
	      <xsl:attribute name="id">infobox</xsl:attribute>
	      <xsl:if test = "/buildinfo/document/head/meta[@name='under-construction' and @content='true']">
		<xsl:element name="p">
		  <xsl:apply-templates select="/buildinfo/textset/text[@id='under-construction']/node()" />
		</xsl:element>
	      </xsl:if>
	    </xsl:element>
	    <!-- End info box -->
	    
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
		  </xsl:if>
		</xsl:element>-->
	    <!-- End Fundraising box -->

	    <!-- Here goes the actual content of the <body> node of the input file -->
	    <xsl:apply-templates select="node()"/>

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
	      Copyright © 2001-2010 <a href="/">Free Software
		Foundation Europe</a>. <strong><a href="/contact/contact.html">Contact us</a></strong>.<br />

	      <xsl:apply-templates select="/buildinfo/textset/text[@id='permission']/node()" /><br />

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
		<xsl:apply-templates select="/buildinfo/textset/text[@id='lastchanged']/node()"/>
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
		  <xsl:text>Source code</xsl:text>
		</xsl:element>
	      </li>

	      <li>
		<a href="/contribute/translators/">Translate this
		  page?</a>
	      </li>
	    </ul>

	    <p>
	      <!-- Insert the appropriate translation notice -->
	      <xsl:if test="/buildinfo/document/@language!=/buildinfo/@original">
		<xsl:choose>
		  <xsl:when test="/buildinfo/document/translator">
		    <xsl:value-of select="/buildinfo/textset/text[@id='translator1a']"/>
		    <xsl:value-of select="/buildinfo/document/translator"/>
		    <xsl:value-of select="/buildinfo/textset/text[@id='translator1b']"/>
		  </xsl:when>
		  <xsl:otherwise>
		    <xsl:value-of select="/buildinfo/textset/text[@id='translator2']"/>
		  </xsl:otherwise>
		</xsl:choose>
		<xsl:value-of select="/buildinfo/textset/text[@id='translator3a']"/>
		<xsl:element name="a">
		  <xsl:attribute name="href">
		    <xsl:value-of select="/buildinfo/@filename"/>
		    <xsl:text>.en.html</xsl:text>
		  </xsl:attribute>
		  <xsl:value-of select="/buildinfo/textset/text[@id='translator3b']"/>
		</xsl:element>
		<xsl:value-of select="/buildinfo/textset/text[@id='translator3c']"/>
	      </xsl:if>
	    </p>
	  </div> <!-- /#notice -->          
	  
	<!-- Sister organisations -->
	<xsl:element name="div">
	<xsl:attribute name="id">sister-organisations</xsl:attribute>        
	  <xsl:apply-templates select="/buildinfo/textset/text[@id='fsfnetwork']/node()"/>
	</xsl:element><!-- end sister organisations-->
	  
	</div> <!-- /#footer -->
	
        <!-- AWstats javascript tracking code -->
        <script language="javascript" type="text/javascript" src="/scripts/awstats_misc_tracker.js" ></script>
	<noscript><img src="/scripts/awstats_misc_tracker.js?nojs=y" height="0" width="0" border="0" style="display: none" alt="script" /></noscript>
	
      </xsl:element>
    </xsl:copy>
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
		       buildinfo/localmenuset"/>

  <!-- For all other nodes, copy verbatim -->
  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>


<!--  -->
