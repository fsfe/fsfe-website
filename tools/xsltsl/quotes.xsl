<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:import href="translations.xsl" />
  
  <xsl:output method="xml" encoding="UTF-8" indent="yes" />
  
  <xsl:template name="quote-box">
    <xsl:param name="tag" select="''"/> <!-- if left empty, all quotes will be selected -->
    
    <div id="cb1-back">
      <xsl:call-template name="first-quote">
        <xsl:with-param name="tag" select="$tag" />
      </xsl:call-template>
    </div>
    
    <div id="cb1-front">
      <!-- -->
    </div>
    
    <!-- javascript code for rotating quotes -->
    <script type="text/javascript">
      
      var quotes = [
        <xsl:choose>
          <xsl:when test="count(/buildinfo/textset/quotes/quote[@tag=$tag or $tag=''])>0">
            <xsl:call-template name="get-js-quotes">
              <xsl:with-param name="quotes-xpath" select="/buildinfo/textset/quotes/quote[@tag=$tag or $tag='']" />
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="get-js-quotes">
              <xsl:with-param name="quotes-xpath" select="/buildinfo/textsetbackup/quotes/quote[@tag=$tag or $tag='']" />
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      ];
      
      var index = 0;
      function changeImage () {
        
        var oldIndex = index;
        index = (index+1)%quotes.length;
        
        var newContent = 
          "&lt;a href='/donate/donate.html'&gt;" +
          "&lt;img src='"+quotes[index]['photo']+"' /&gt;" +
          "&lt;p&gt;"+quotes[index]['text']+"&lt;br/&gt;"+
          "&lt;strong&gt;"+quotes[index]['author']+"&lt;/strong&gt;&lt;/p&gt;"+
          "&lt;/a&gt;";
        
        $('#cb1-front').html($('#cb1-back').html());
        $('#cb1-front').fadeIn(0);
        
        $('#cb1-back').fadeOut(0);
        $('#cb1-back').html(newContent);
        
        $('#cb1-front').fadeOut('slow', function() {
          $('#cb1-back').fadeIn('slow', function() {});
        });
        
        setTimeout("changeImage();",10000);
        
      }
      
      setTimeout("changeImage();",10000);
    </script>
    
  </xsl:template>
  
  
  <xsl:template name="get-js-quotes">
    <xsl:param name="quotes-xpath" />
    
    <xsl:for-each select="$quotes-xpath">
      <xsl:sort select="@pos" data-type="number" />
      {
        'photo':  "<xsl:call-template name="get-quote-photo"><xsl:with-param name="id" select="@id" /></xsl:call-template>",
        'text':   "<xsl:call-template name="get-quote-text-escaped"><xsl:with-param name="id" select="@id" /></xsl:call-template>",
        'author': "<xsl:call-template name="get-quote-author-escaped"><xsl:with-param name="id" select="@id" /></xsl:call-template>"
      },
    </xsl:for-each>
    
  </xsl:template>
  
  
  <xsl:template name="first-quote">
    <xsl:param name="tag" />
    
    <xsl:choose>
      <xsl:when test="count(/buildinfo/textset/quotes/quote[@tag=$tag or $tag=''])>0">
        <xsl:call-template name="display-first-quote">
          <xsl:with-param name="quotes-xpath" select="/buildinfo/textset/quotes/quote[@tag=$tag or $tag='']" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise >
        <xsl:call-template name="display-first-quote">
          <xsl:with-param name="quotes-xpath" select="/buildinfo/textsetbackup/quotes/quote[@tag=$tag or $tag='']" />
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>
  
  
  <xsl:template name="display-first-quote">
    <xsl:param name="quotes-xpath" />
    
    <xsl:for-each select="$quotes-xpath">
      <xsl:sort select="@pos" data-type="number" />
      
      <xsl:if test="position() = 1">
        
        <a href="/donate/donate.html">
          <xsl:element name="img">
            <xsl:attribute name="src">
              <xsl:call-template name="get-quote-photo">
                <xsl:with-param name="id" select="@id" />
              </xsl:call-template>
            </xsl:attribute>
          </xsl:element>
          <p>
            <xsl:call-template name="get-quote-text">
              <xsl:with-param name="id" select="@id" />
            </xsl:call-template>
            <br/>
            <strong>
              <xsl:call-template name="get-quote-author">
                <xsl:with-param name="id" select="@id" />
              </xsl:call-template>
            </strong>
          </p>
        </a>
        
      </xsl:if>
      
    </xsl:for-each>
    
  </xsl:template>
  
</xsl:stylesheet>
