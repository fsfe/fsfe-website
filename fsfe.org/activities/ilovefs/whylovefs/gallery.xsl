<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:import href="../../../fsfe.xsl"/>
  <!-- This creates a page containing images of a gallery.
All pictures are located in a directory and have numbered names (here ilovefs-gallery-thumb-NNN.jpg)
The generated list will start at the largest number ('to' aka 'max') and end with the smallest ('from' aka 'min) -->
  <!-- This creates looping pictures in a box. All pictures are located in a directory and have numbered names (here ilovefs-gallery-thumb-NNN.jpg) -->
  <xsl:template match="picture-box-report-2024">
    <!-- appears once when <picture-box-report-2024 /> is called -->
    <xsl:variable name="from">
      <xsl:value-of select="@from"/>
    </xsl:variable>
    <xsl:variable name="to">
      <xsl:value-of select="@to"/>
    </xsl:variable>
    <div id="picture-box-report-2024" style="height:397px;">
      <!-- change to height of pictures -->
      <div id="picture-box-report-2024-inner" class="logo-list quote">
        <a href="https://download.fsfe.org/campaigns/ilovefs/share-pics/picturebox-report-2024/Pic-1.jpg">
          <div class="img">
            <noscript>
              <img>
                <xsl:attribute name="src">https://download.fsfe.org/campaigns/ilovefs/share-pics/picturebox-report-2024/Pic-1.jpg</xsl:attribute>
              </img>
            </noscript>
          </div>
          <!-- /img -->
        </a>
      </div>
      <!-- /picture-box-report-2024-inner -->
    </div>
    <!-- /picture-box-report-2024 -->
    <script type="text/javascript">
      /* &lt;![CDATA[ */
      var quotes = [
      <!-- this template calls the loop below -->
      <xsl:call-template name="picture-box-report-2024"><xsl:with-param name="num" select="$from"/><!-- starting number --><xsl:with-param name="max" select="$to"/><!-- select maximum number of pictures which should be shown in picture box --></xsl:call-template>
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
    <xsl:if test="not($num &gt; $max)">
      {
        'photo': 'https://download.fsfe.org/campaigns/ilovefs/share-pics/picturebox-report-2024/Pic-<xsl:value-of select="$num"/>.jpg',
	'link': 'https://download.fsfe.org/campaigns/ilovefs/share-pics/picturebox-report-2024/Pic-<xsl:value-of select="$num"/>.jpg',
      },
      <xsl:call-template name="picture-box-report-2024"><!-- initiate the next round --><xsl:with-param name="num"><xsl:value-of select="$num+1"/><!-- count +1 --></xsl:with-param><xsl:with-param name="max" select="$max"/></xsl:call-template>
    </xsl:if>
  </xsl:template>
  <!-- / picture-box-report-2024 -->
  <xsl:template match="picture-list">
    <!-- appears once when <picture-list /> is called -->
    <!-- this template calls the loop below -->
    <xsl:variable name="from">
      <xsl:value-of select="@from"/>
    </xsl:variable>
    <xsl:variable name="to">
      <xsl:value-of select="@to"/>
    </xsl:variable>
    <xsl:call-template name="picture-list">
      <xsl:with-param name="min" select="$from"/>
      <!-- lowest number, will linked at the very bottom-->
      <xsl:with-param name="max" select="$to"/>
      <!-- select maximum number of pictures which should be shown in picture list -->
    </xsl:call-template>
  </xsl:template>
  <xsl:template name="picture-list">
    <xsl:param name="min"/>
    <xsl:param name="max"/>
    <xsl:if test="$max &gt; $min">
      <!-- left side (uneven numbers) -->
      <xsl:element name="div">
        <xsl:attribute name="class">captioned left</xsl:attribute>
        <xsl:attribute name="style">max-width: 300px; width: 40%;</xsl:attribute>
        <xsl:element name="a">
          <xsl:attribute name="href">https://download.fsfe.org/campaigns/ilovefs/gallery/ilovefs-gallery-<xsl:value-of select="$max"/>.jpg</xsl:attribute>
          <xsl:element name="img">
            <xsl:attribute name="src">https://download.fsfe.org/campaigns/ilovefs/gallery/thumbs/ilovefs-gallery-thumb-<xsl:value-of select="$max"/>.jpg</xsl:attribute>
            <xsl:attribute name="alt">A picture of one or more Free Software loving persons</xsl:attribute>
            <xsl:attribute name="width">100%</xsl:attribute>
          </xsl:element>
          <!-- /img -->
        </xsl:element>
        <!-- /a -->
      </xsl:element>
      <!-- /div -->
      <!-- right side (even numbers) -->
      <xsl:element name="div">
        <xsl:attribute name="class">captioned right</xsl:attribute>
        <xsl:attribute name="style">max-width: 300px; width: 40%;</xsl:attribute>
        <xsl:element name="a">
          <xsl:attribute name="href">https://download.fsfe.org/campaigns/ilovefs/gallery/ilovefs-gallery-<xsl:value-of select="$max - 1"/>.jpg</xsl:attribute>
          <xsl:element name="img">
            <xsl:attribute name="src">https://download.fsfe.org/campaigns/ilovefs/gallery/thumbs/ilovefs-gallery-thumb-<xsl:value-of select="$max - 1"/>.jpg</xsl:attribute>
            <xsl:attribute name="alt">A picture of one or more Free Software loving persons</xsl:attribute>
            <xsl:attribute name="width">100%</xsl:attribute>
          </xsl:element>
          <!-- /img -->
        </xsl:element>
        <!-- /a -->
      </xsl:element>
      <!-- /div -->
      <!-- initiate the next round -->
      <xsl:call-template name="picture-list">
        <xsl:with-param name="max">
          <xsl:value-of select="$max - 2"/>
          <!-- count -2, because -1 is already the right side -->
        </xsl:with-param>
        <xsl:with-param name="min" select="$min"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  <!-- / picture-list -->
</xsl:stylesheet>
