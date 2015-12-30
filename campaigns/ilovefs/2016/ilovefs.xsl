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
    
    <div id="picture-box" <!--style="height: 225px"-->> <!-- change height of pictures -->
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
        <xsl:with-param name="pStart" select="1"/>
        <xsl:with-param name="pEnd" select="42"/> <!-- select maximum number of pictures which should be shown in picture box -->
      </xsl:call-template>
      <!-- and here again the one-time content -->
      ];
      
      <![CDATA[
      var index = Math.floor(Math.random()*quotes.length);
      function changeImage() {
        $('#picture-box-inner').fadeTo(600, 0, function() {
          $('#picture-box-inner').html('<a href="' + quotes[index]['link'] + '">'
                                     + '<div class="img"><img src="' + quotes[index]['photo'] + '"/></div>'
                                     );
          $('#picture-box-inner').fadeTo(600, 1, function() {});
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
    <xsl:param name="pStart"/>
    <xsl:param name="pEnd"/>
    
    <xsl:if test="not($pStart > $pEnd)">
      <xsl:choose>
        <xsl:when test="$pStart = $pEnd">
          {
            'photo': '/campaigns/ilovefs/whylovefs/photos/gallery/ilovefs-gallery-thumb-<xsl:value-of select="$pStart"/>.jpg',
            'link': 'http://download.fsfe.org/campaigns/ilovefs/gallery/ilovefs-gallery-<xsl:value-of select="$pStart"/>.jpg',
          },
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
  <!-- / picture-box -->

  <!-- may be needed for picture box if text appears and has to be sanitised -->
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

  <!-- How to show a link -->
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
  
</xsl:stylesheet>
