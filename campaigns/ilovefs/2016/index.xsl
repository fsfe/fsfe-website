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
    
    <div id="picture-box" style="height:225px;"> <!-- change to height of pictures -->
      <div id="picture-box-inner" class="logo-list quote">
        <a href="http://download.fsfe.org/campaigns/ilovefs/gallery/ilovefs-gallery-1.jpg">
          <div class="img">
            <noscript>
              <img>
                <xsl:attribute name="src">/campaigns/ilovefs/whylovefs/photos/gallery/ilovefs-gallery-thumb-1.jpg</xsl:attribute>
              </img>
            </noscript>
          </div> <!-- /img -->
        </a>
      </div> <!-- /picture-box-inner -->
    </div> <!-- /picture-box -->
    
    <script type="text/javascript">
      /* &lt;![CDATA[ */
      var quotes = [
      <!-- this template calls the loop below -->
      <xsl:call-template name="picture-box">
        <xsl:with-param name="num" select="1"/> <!-- starting number -->
        <xsl:with-param name="max" select="68"/> <!-- select maximum number of pictures which should be shown in picture box -->
      </xsl:call-template>
      <!-- and here again the one-time content -->
      ];
      
      <![CDATA[
      var index = Math.floor(Math.random()*quotes.length);
      function changeImage() {
        $('#picture-box-inner').fadeOut('slow', function() {
          $('#picture-box-inner').html('<a href="' + quotes[index]['link'] + '">'
                                     + '<div class="img"><img src="' + quotes[index]['photo'] + '"/></div>'
                                     );
          $('#picture-box-inner').fadeIn('slow', function() {});
          });
        index = (index+1)%quotes.length;
        setTimeout("changeImage();",5000);
      }
      
      changeImage();
      ]]>
      
      /* ]]&gt; */
      
    </script>
  </xsl:template>

  <xsl:template name="picture-box">
    <xsl:param name="num"/>
    <xsl:param name="max"/>
    <xsl:if test="not($num > $max)">
      {
        'photo': '/campaigns/ilovefs/whylovefs/photos/gallery/ilovefs-gallery-thumb-<xsl:value-of select="$num"/>.jpg',
        'link': 'http://download.fsfe.org/campaigns/ilovefs/gallery/ilovefs-gallery-<xsl:value-of select="$num"/>.jpg',
      },
      <xsl:call-template name="picture-box"> <!-- initiate the next round -->
        <xsl:with-param name="num">
          <xsl:value-of select="$num+1" /> <!-- count +1 -->
        </xsl:with-param>
        <xsl:with-param name="max" select="$max"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  <!-- / picture-box -->
  
</xsl:stylesheet>
