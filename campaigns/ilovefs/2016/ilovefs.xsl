<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:import href="../../../tools/xsltsl/tagging.xsl" />
  
  <xsl:import href="../../../fsfe.xsl" />
  <xsl:output method="html" encoding="utf-8" indent="yes" doctype-system="about:legacy-compat" />
  
  
  <xsl:template match="fetch-news">
    <xsl:call-template name="fetch-news">
      <xsl:with-param name="tag" select="'ilovefs'"/>
      <xsl:with-param name="nb-items" select="5"/>
    </xsl:call-template>
  </xsl:template>

  <!-- This creates looping pictures in a box. All pictures are located in a directory and have numbered names (here ilovefs-gallery-thumb-NNN.jpg) -->
  <xsl:template match="picture-box">
    <!-- appears once when <picture-box /> is called -->
    <script type="text/javascript">
      var quotes = [
      
      <!-- this template calls the loop below -->
      <xsl:call-template name="picture-box">
        <xsl:with-param name="pStart" select="1"/>
        <xsl:with-param name="pEnd" select="50"/> <!-- select maximum number of pictures which should be shown in picture box -->
      </xsl:call-template>
      <!-- and here again the one-time content -->
      
      ];

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
        setTimeout("changeImage();",5000);
      }
      
      changeImage();
      ]]>
    </script>

  </xsl:template>

  <xsl:template name="picture-box">

    <xsl:param name="pStart"/>
    <xsl:param name="pEnd"/>
    
    <xsl:if test="not($pStart > $pEnd)">
      <xsl:choose>
        <xsl:when test="$pStart = $pEnd">
          {
            'photo': 'https://fsfe.org/campaigns/ilovefs/whylovefs/photos/gallery/ilovefs-gallery-thumb-<xsl:value-of select="$pStart"/>.jpg',
          },
          <xsl:text>&#xA;</xsl:text>
        </xsl:when>
        
        <xsl:otherwise>
          <xsl:variable name="vMid" select=
           "floor(($pStart + $pEnd) div 2)"/>
          <xsl:call-template name="picture-box">
            <xsl:with-param name="pStart" select="$pStart"/>
            <xsl:with-param name="pEnd" select="$vMid"/>
          </xsl:call-template>
          <xsl:call-template name="picture-box">
            <xsl:with-param name="pStart" select="$vMid+1"/>
            <xsl:with-param name="pEnd" select="$pEnd"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>

  </xsl:template>

  <!-- How to show a link -->
<!--
  <xsl:template match="/buildinfo/document/set/news/link">
    <xsl:element name="a">
      <xsl:attribute name="href">
        <xsl:value-of select="text()" />
      </xsl:attribute>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="/buildinfo/document/text[@id='more']" />
      <xsl:text>]</xsl:text>
    </xsl:element>
  </xsl:template>
-->
  
</xsl:stylesheet>
