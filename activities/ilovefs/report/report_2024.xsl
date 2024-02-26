<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../../../fsfe.xsl" />

  <!-- Include the file containing the content of the current year -->
  <xsl:template match="current-year">
    <xsl:copy-of select="/buildinfo/document/set/module/node()" />
  </xsl:template>

  <!-- This creates looping pictures in a box. All pictures are located in a directory and have numbered names (here ilovefs-gallery-thumb-NNN.jpg) -->
  <xsl:template match="picture-box-index">
    <!-- appears once when <picture-box-index /> is called -->
    <xsl:variable name="from"><xsl:value-of select="@from"/></xsl:variable>
    <xsl:variable name="to"><xsl:value-of select="@to"/></xsl:variable>

    <div id="picture-box-index" style="height:340.157px;"> <!-- change to height of pictures -->
      <div id="picture-box-index-inner" class="logo-list quote">
        <a href="https://download.fsfe.org/campaigns/ilovefs/share-pics/picturebox/Share-Pic-1.jpg">
          <div class="img">
            <noscript>
              <img>
                <xsl:attribute name="src">https://download.fsfe.org/campaigns/ilovefs/share-pics/picturebox/Share-Pic-1.jpg</xsl:attribute>
              </img>
            </noscript>
          </div> <!-- /img -->
        </a>
      </div> <!-- /picture-box-index-inner -->
    </div> <!-- /picture-box-index -->
    
    <script type="text/javascript">
      /* &lt;![CDATA[ */
      var quotes = [
      <!-- this template calls the loop below -->
      <xsl:call-template name="picture-box-index">
        <xsl:with-param name="num" select="$from"/> <!-- starting number -->
        <xsl:with-param name="max" select="$to"/> <!-- select maximum number of pictures which should be shown in picture box -->
      </xsl:call-template>
      <!-- and here again the one-time content -->
      ];

      <![CDATA[
      var index = Math.floor(Math.random()*quotes.length);
      function changeImage() {
        $('#picture-box-index-inner').fadeOut('slow', function() {
          $('#picture-box-index-inner').html('<a href="' + quotes[index]['link'] + '">'
                                     + '<div class="img"><img src="' + quotes[index]['photo'] + '"/></div>'
                                     );
          $('#picture-box-index-inner').fadeIn('slow', function() {});
          });
        index = (index+1)%quotes.length;
        setTimeout("changeImage();",5000);
      }
      changeImage();
      ]]>

      /* ]]&gt; */

    </script>
  </xsl:template>

  <xsl:template name="picture-box-index">
    <xsl:param name="num"/>
    <xsl:param name="max"/>
    <xsl:if test="not($num > $max)">
      {
        'photo': 'https://download.fsfe.org/campaigns/ilovefs/share-pics/picturebox/Share-Pic-<xsl:value-of select="$num"/>.jpg',
        'link': 'https://download.fsfe.org/campaigns/ilovefs/share-pics/picturebox/Share-Pic-<xsl:value-of select="$num"/>.jpg',
      },
      <xsl:call-template name="picture-box-index"> <!-- initiate the next round -->
        <xsl:with-param name="num">
          <xsl:value-of select="$num+1" /> <!-- count +1 -->
        </xsl:with-param>
        <xsl:with-param name="max" select="$max"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  <!-- / picture-box-index -->

<!-- Report picturebox -->
  
      <!-- This creates looping pictures in a box. All pictures are located in a directory and have numbered names (here ilovefs-gallery-thumb-NNN.jpg) -->
  <xsl:template match="picture-box-report-2024">
    <!-- appears once when <picture-box-report-2024 /> is called -->
    <xsl:variable name="from"><xsl:value-of select="@from"/></xsl:variable>
    <xsl:variable name="to"><xsl:value-of select="@to"/></xsl:variable>

    <div id="picture-box-report-2024" style="height:397px;"> <!-- change to height of pictures -->
      <div id="picture-box-report-2024-inner" class="logo-list quote">
        <a href="https://download.fsfe.org/campaigns/ilovefs/share-pics/picturebox-report-2024/Pic-1.jpg">
          <div class="img">
            <noscript>
              <img>
		      <xsl:attribute name="src">https://download.fsfe.org/campaigns/ilovefs/share-pics/picturebox-report-2024/Pic-1.jpg</xsl:attribute>
              </img>
            </noscript>
          </div> <!-- /img -->
        </a>
      </div> <!-- /picture-box-report-2024-inner -->
    </div> <!-- /picture-box-report-2024 -->

    <script type="text/javascript">
      /* &lt;![CDATA[ */
      var quotes = [
      <!-- this template calls the loop below -->
      <xsl:call-template name="picture-box-report-2024">
        <xsl:with-param name="num" select="$from"/> <!-- starting number -->
        <xsl:with-param name="max" select="$to"/> <!-- select maximum number of pictures which should be shown in picture box -->
      </xsl:call-template>
      <!-- and here again the one-time content -->
      ];

      <![CDATA[
      var index = Math.floor(Math.random()*quotes.length);
      function changeImage() {
        $('#picture-box-report-2024-inner').fadeOut('slow', function() {
          $('#picture-box-report-2024-inner').html('<a href="' + quotes[index]['link'] + '">'
                                     + '<div class="img"><img src="' + quotes[index]['photo'] + '"/></div>'
                                     );
          $('#picture-box-report-2024-inner').fadeIn('slow', function() {});
          });
        index = (index+1)%quotes.length;
        setTimeout("changeImage();",5000);
      }
      changeImage();
      ]]>

      /* ]]&gt; */

    </script>
  </xsl:template>

  <xsl:template name="picture-box-report-2024">
    <xsl:param name="num"/>
    <xsl:param name="max"/>
    <xsl:if test="not($num > $max)">
      {
        'photo': 'https://download.fsfe.org/campaigns/ilovefs/share-pics/picturebox-report-2024/Pic-<xsl:value-of select="$num"/>.jpg',
	'link': 'https://download.fsfe.org/campaigns/ilovefs/share-pics/picturebox-report-2024/Pic-<xsl:value-of select="$num"/>.jpg',
      },
      <xsl:call-template name="picture-box-report-2024"> <!-- initiate the next round -->
        <xsl:with-param name="num">
          <xsl:value-of select="$num+1" /> <!-- count +1 -->
        </xsl:with-param>
        <xsl:with-param name="max" select="$max"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  <!-- / picture-box-report-2024 -->
  
</xsl:stylesheet>
