<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" encoding="UTF-8" indent="yes" />

  <xsl:template name="escape">
    <xsl:param name="string"/>
    <xsl:variable name="apos" select='"&apos;"' />
    <xsl:choose>
      <xsl:when test='contains($string, $apos)'>
        <xsl:value-of select="substring-before($string,$apos)" />
        <xsl:text>\'</xsl:text>
        <xsl:call-template name="escape">
          <xsl:with-param name="string" select="substring-after($string, $apos)" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$string" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="testimonial-list">
      <xsl:for-each select="/buildinfo/document/set/quote">
      <div id="quote-box">
      	<div id="quote-box-inner" class="logo-list quote">
          <div class="img">
	    <xsl:element name="img">
              <xsl:attribute name="src">
                <xsl:value-of select="normalize-space(photo)"/>
              </xsl:attribute>
            </xsl:element>
          </div>
          
          <div class="cont">
            <p class="text txt">
              <xsl:call-template name="escape"><xsl:with-param name="string" select="normalize-space(text)"/></xsl:call-template>
            </p>
            <p><span class="author"><xsl:call-template name="escape">
	      <xsl:with-param name="string" select="normalize-space(author)"/></xsl:call-template>
            </span><span class="license">
              <xsl:call-template name="escape"><xsl:with-param name="string" select="normalize-space(license)"/></xsl:call-template>
            </span></p>
          </div>
      	</div>
      </div>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="testimonial-box">

      <xsl:variable name="first-testimonial" select="/buildinfo/document/set/quote[position()=1]" /> 

      <div id="quote-box">
      	<div id="quote-box-inner" class="logo-list quote">
          <div class="img">
              <noscript>
                  <img>
                      <xsl:attribute name="src">
                        <xsl:value-of select="$first-testimonial/photo"/>
                      </xsl:attribute>
                  </img>
            </noscript>
          </div>
          
          <div class="cont">
              <noscript>
                  <p class="text txt">
                    <xsl:value-of select="$first-testimonial/text" />
                  </p>
                  <p>
                      <span class="author">
                          <xsl:value-of select="$first-testimonial/author" />
                      </span>
                      <span class="license">
                          <xsl:value-of select="$first-testimonial/license" />
                      </span>
                  </p>
            </noscript>
          </div>
      	</div>
      </div>

      <script type="text/javascript">
      /* &lt;![CDATA[ */
      
      var quotes = [
      <xsl:for-each select="/buildinfo/document/set/quote">
      {
        'text': '<xsl:call-template name="escape"><xsl:with-param name="string" select="normalize-space(text)"/></xsl:call-template>',
        'photo': '<xsl:value-of select="normalize-space(photo)"/>',
        'author': '<xsl:call-template name="escape"><xsl:with-param name="string" select="normalize-space(author)"/></xsl:call-template>',
        'license': '<xsl:call-template name="escape"><xsl:with-param name="string" select="normalize-space(license)"/></xsl:call-template>',
      },
      </xsl:for-each>
      ];
      
      <![CDATA[
      var index = Math.floor(Math.random()*quotes.length);
      function changeImage () {
      
      	$('#quote-box-inner').fadeOut('slow', function() {
      	  $('#quote-box-inner div.img').html('<img src="'+quotes[index]['photo']+'"/>');
      	  $('#quote-box-inner div.cont').html('<p class="text txt">'
      	                                + quotes[index]['text']
      	                                + '</p><p><span class="author">'
      	                                + quotes[index]['author']
      	                                + '</span><span class="license">'
      	                                + quotes[index]['license']
      	                                + '</span></p>'
      	  );
      	  $('#quote-box-inner').fadeIn('slow', function() {});
      	});
      
      	index = (index+1)%quotes.length;
      	setTimeout("changeImage();",15000);
      
      }
      
      changeImage();
      ]]>
      
      /* ]]&gt; */
    </script>
  </xsl:template>
</xsl:stylesheet>
