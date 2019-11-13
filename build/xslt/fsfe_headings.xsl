<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Modify H1 -->
  <xsl:template match="h1">
    
    <!-- Apply news page PRE-rules -->
    <xsl:if test="string(/buildinfo/document/@newsdate) and
                    (not(string(/buildinfo/document/@type)) or
                    /buildinfo/document/@type != 'newsletter' and
                    /buildinfo/document/@type != 'podcast')">
      
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
    
    <!-- Apply podcast page PRE-rules -->
    <xsl:if test="string(/buildinfo/document/@newsdate) and /buildinfo/document/@type = 'podcast'">
      <xsl:element name="p">
        <xsl:attribute name="id">category</xsl:attribute>
        <xsl:element name="a">
          <xsl:attribute name="href">/news/podcast.<xsl:value-of select="/buildinfo/@language"/>.html</xsl:attribute>
          <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'podcast'" /></xsl:call-template>
        </xsl:element>
      </xsl:element>
    </xsl:if>

    <!-- auto generate ID for headings if it doesn't already exist -->
    <xsl:call-template name="generate-id" />
    
    <!-- Apply news page rules -->
    <xsl:if test="string(/buildinfo/document/@newsdate) and
                    (not(string(/buildinfo/document/@type)) or
                    /buildinfo/document/@type != 'newsletter')">

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
                  <xsl:when test="@id and document('../../about/people/people.en.xml')/personset/person[@id=$id]">
                  <!-- if the author is in fsfe's people.xml then we take information from there --> 
                    <xsl:choose>
                      <!-- person has a link -->
                      <xsl:when test="document('../../about/people/people.en.xml')/personset/person[@id=$id]/link">
                          <xsl:element name="a">
                                  <xsl:attribute name="class">author p-author h-card</xsl:attribute>
                                  <xsl:attribute name="rel">author</xsl:attribute>
                                  <xsl:attribute name="href"><xsl:value-of select="document('../../about/people/people.en.xml')/personset/person[@id=$id]/link" /></xsl:attribute>
                                  <xsl:if test="document('../../about/people/people.en.xml')/personset/person[@id=$id]/avatar">
                                          <xsl:element name="img">
                                                  <xsl:attribute name="alt"></xsl:attribute>
                                                  <xsl:attribute name="src"><xsl:value-of select="document('../../about/people/people.en.xml')/personset/person[@id=$id]/avatar" /></xsl:attribute>
                                          </xsl:element>
                                  </xsl:if>
                                  <xsl:value-of select="document('../../about/people/people.en.xml')/personset/person[@id=$id]/name" />
                          </xsl:element>
                      </xsl:when>
                      <!-- person has no link -->
                      <xsl:otherwise>
                          <xsl:if test="document('../../about/people/people.en.xml')/personset/person[@id=$id]/avatar">
                                  <xsl:element name="img">
                                          <xsl:attribute name="alt"></xsl:attribute>
                                          <xsl:attribute name="src"><xsl:value-of select="document('../../about/people/people.en.xml')/personset/person[@id=$id]/avatar" /></xsl:attribute>
                                  </xsl:element>
                          </xsl:if>
                          <span class="author p-author">
                            <xsl:value-of select="document('../../about/people/people.en.xml')/personset/person[@id=$id]/name" />
                          </span>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:when>
                  <!-- person is not in people.en.xml -->
                  <xsl:otherwise>
                    <xsl:choose>
                      <!-- person has a link -->
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
                          </xsl:element>
                      </xsl:when>
                      <!-- person has no link -->
                      <xsl:otherwise>
                          <xsl:if test="avatar">
                                  <xsl:element name="img">
                                          <xsl:attribute name="alt"></xsl:attribute>
                                          <xsl:attribute name="src"><xsl:value-of select="avatar" /></xsl:attribute>
                                  </xsl:element>
                          </xsl:if>
                          <span class="author p-author">
                            <xsl:value-of select="name" />
                          </span>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:otherwise>
              </xsl:choose>
              
              <!-- choose whether to put a comma or an "and" between authors -->
              <xsl:choose>
                <!-- second-last author and not first author -->
                <xsl:when test="position() = last()-1 and not(position() = 1)">
                  <xsl:text>, </xsl:text><xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'and'" /></xsl:call-template><xsl:text>&#160;</xsl:text>
                </xsl:when>
                <!-- second-last author and first author -->
                <xsl:when test="position() = last()-1 and position() = 1">
                  <xsl:text> </xsl:text><xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'and'" /></xsl:call-template><xsl:text>&#160;</xsl:text>
                </xsl:when>
                <!-- not last author -->
                <xsl:when test="not(position() = last())">
                  <xsl:text>, </xsl:text>
                </xsl:when>
                <!-- last or only author -->
                <xsl:otherwise>
                  <xsl:text> </xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            
          </xsl:for-each>
    </xsl:if>
    
    <!-- only show date if <date> exists (not news entries for example) -->
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
        <xsl:element name="br" />
        <span class="download"><xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'download'" /></xsl:call-template>:&#160;</span>
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

</xsl:stylesheet>

