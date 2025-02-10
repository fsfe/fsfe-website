<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../../fsfe.xsl" />
  <xsl:import href="../../../build/xslt/countries.xsl" />

  <!-- Dropdown list of countries requiring a choice -->
  <!-- when copying this, remember importing the xsl, and editing the .source file -->
  <xsl:template match="country-list">
    <xsl:call-template name="country-list">
      <xsl:with-param name="class" select="'form-control'"/>
      <xsl:with-param name="required" select="'yes'"/>
      <xsl:with-param name="subset" select="'yh4f'"/>
    </xsl:call-template>
  </xsl:template>

  <!-- "Videobox" (provisional name) with YH4F/related talks -->
  <xsl:template match="talks">

    <figure id="yh4f-figure">
      <div>
        <div id="yh4f-iframe-container">
          <iframe id="yh4f-iframe" src="https://media.fsfe.org/videos/embed/0dbe49c1-bd7d-44ca-bb97-1b922b3e110e" frameborder="0" allowfullscreen="" sandbox="allow-same-origin allow-scripts allow-popups allow-forms" />
        </div>
      </div>
      <figcaption id="yh4f-slideshow-caption">
        <button onclick="prevVideo();">←</button>
        <a id="yh4f-title" href="https://media.fsfe.org/w/2GqZexjuYceajrbo7B8Sc1">Youth Hacking 4 Freedom</a>
        <button onclick="nextVideo();">→</button>
      </figcaption>
    </figure>

    <script type="text/javascript">
      /* &lt;![CDATA[ */
      var videos = [
      <xsl:for-each select="/buildinfo/document/set/talk">
        {
          title: "<xsl:value-of select="title"/>",
          iframe_url: "<xsl:value-of select="iframe-url"/>",
          external_url: "<xsl:value-of select="external-url"/>",
        },
      </xsl:for-each>
      ];

      <![CDATA[
      var index = Math.floor(Math.random()*videos.length);

      function nextVideo() {
        index = (index+1)%videos.length;
        updateVideo();
      }

      function prevVideo() {
        index = (index-1+videos.length)%videos.length;
        updateVideo();
      }

      function updateVideo() {
        $('#yh4f-iframe').attr("src", videos[index]['iframe_url']);
        $('#yh4f-title').attr("href", videos[index]['external_url']);
        $('#yh4f-title').text(videos[index]['title']);
      }
      ]]>

      /* ]]&gt; */
    </script>
  </xsl:template>
</xsl:stylesheet>
