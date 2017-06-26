<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:include href="sharebuttons.xsl" />
  <xsl:include href="fsfe_sidebar.xsl" />

  <xsl:template name="taglinks">
    <xsl:param name="prefix" />

    <ul class="taglist"><xsl:for-each select="/buildinfo/document/tags/tag">
      <xsl:variable name="keyname"
           select="translate(@key,'ABCDEFGHIJKLMNOPQRSTUVWXYZ-_+ /','abcdefghijklmnopqrstuvwxyz')"/>
      <xsl:variable name="tagname"
           select="translate(.,'ABCDEFGHIJKLMNOPQRSTUVWXYZ-_+ /','abcdefghijklmnopqrstuvwxyz')"/>

      <xsl:choose><xsl:when test="@key and .">
        <li><a href="/tags/tagged-{$keyname}.html"><xsl:value-of select="."/></a></li>
      </xsl:when><xsl:when test="@content and not(@content = '')"> <!-- Legacy -->
        <li><a href="/tags/tagged-{$tagname}.html"><xsl:value-of select="@content"/></a></li>
      </xsl:when><xsl:when test="@key"> <!-- bad style -->
        <li><a href="/tags/tagged-{$keyname}.html"><xsl:value-of select="@key"/></a></li>
      </xsl:when><xsl:otherwise> <!-- Legacy and bad style -->
        <li><a href="/tags/tagged-{$tagname}.html"><xsl:value-of select="."/></a></li>
      </xsl:otherwise></xsl:choose>
    </xsl:for-each></ul>
  </xsl:template>

  <xsl:template name="fsfe_mainsection">
    <xsl:element name="section">
      <xsl:attribute name="id">main</xsl:attribute>
      <xsl:attribute name="role">main</xsl:attribute>
  
      <xsl:element name="article">
        <xsl:attribute name="id">content</xsl:attribute>
        <xsl:if test="/buildinfo/document/body/@microformats">
          <xsl:attribute name="class"><xsl:value-of select="/buildinfo/document/body/@microformats" /></xsl:attribute>
        </xsl:if>
  
        <!-- Here goes the actual content of the <body> node of the input file -->
        <xsl:apply-templates select="/buildinfo/document/event/body | /buildinfo/document/news/body | /buildinfo/document/body/* | /buildinfo/document/body/node()" />
        
        <!-- Show tags if this is a news press release or an event -->
        <xsl:if test="(/buildinfo/document/@newsdate or /buildinfo/document/event)
                      and /buildinfo/document/tags/tag[not(. = 'front-page' or @key = 'front-page')]">
          <aside id="tags">
            <h2><xsl:call-template name="fsfe-gettext">
              <xsl:with-param name="id" select="'tags'" />
            </xsl:call-template></h2>

            <xsl:call-template name="taglinks"/>
          </aside>
        </xsl:if> <!-- /tags -->
        
        <!-- SOCIAL NETWORK LINKS (BOTTOM) -->
        <xsl:if test = "not(/buildinfo/document/body/@class = 'frontpage') and
                        not(/buildinfo/document/body/@class = 'errorpage')">
          <xsl:call-template name="sharebuttons"/>
        </xsl:if>
  
      </xsl:element>
      <!--/article#content-->
  
      <xsl:if test = "/buildinfo/document/sidebar or /buildinfo/document/@newsdate">
          <xsl:call-template name="sidebar"/>
      </xsl:if>
  
      <xsl:if test = "/buildinfo/document/legal">
        <footer class="copyright notice creativecommons">

          <xsl:choose><xsl:when test = "/buildinfo/document/legal/license">
            <xsl:element name="a">
              <xsl:attribute name="href">
                <xsl:value-of select="/buildinfo/document/legal/license"/>
              </xsl:attribute>
              <xsl:attribute name="rel">license</xsl:attribute>
              <xsl:value-of select="/buildinfo/document/legal/notice"/>
            </xsl:element>
          </xsl:when><xsl:otherwise>
            <span><xsl:value-of select="/buildinfo/document/legal/notice"/></span>
          </xsl:otherwise></xsl:choose>
  
        </footer>
        <!--/footer-->
      </xsl:if>
  
      <!--Depreciated: it's here only for "backward compatibility"  cc license way-->
      <xsl:if test = "string(/buildinfo/document/head/meta[@name='cc-license']/@content)">
        <footer id="cc-licenses"><xsl:element name="p">
          <img src="/graphics/cc-logo.png" alt="Creative Commons logo" />
          <xsl:for-each select="/buildinfo/document/head/meta[@name='cc-license']">
            <xsl:value-of select="@content"/> •
          </xsl:for-each>
        </xsl:element></footer>
      </xsl:if>
  
    </xsl:element>
    <!--/section#main-->
  </xsl:template>

</xsl:stylesheet>
