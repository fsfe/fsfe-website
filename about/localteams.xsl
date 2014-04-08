<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:import href="../tools/xsltsl/countries.xsl" />
  <xsl:import href="../fsfe.xsl" />
  <xsl:output method="html" encoding="utf-8" indent="yes" doctype-system="about:legacy-compat" />
  
  <!-- 
    For documentation on tagging (e.g. display a people list), take a
    look at the documentation under
      /tools/xsltsl/documentation-tagging.txt
  -->
  
  <!-- Fill dynamic content -->  
  
  <!-- Athens -->
    <xsl:template match="athens-members">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'athens'" />
    </xsl:call-template>
  </xsl:template>
  
  
  
  <!-- Austria -->
  <xsl:template match="austria-members">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'austria'" />
    </xsl:call-template>
  </xsl:template>
  
  <!-- Barcelona -->
  <xsl:template match="barcelona-members">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'barcelona'" />
    </xsl:call-template>
  </xsl:template>
  
  <!-- Bari -->
  <xsl:template match="bari-members">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'bari'" />
    </xsl:call-template>
  </xsl:template>
   
  
  <!-- Berlin -->
  <xsl:template match="berlin-members">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'berlin'" />
    </xsl:call-template>
  </xsl:template>
  
  <!-- Bonn -->
  <xsl:template match="bonn-members">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'bonn'" />
    </xsl:call-template>
  </xsl:template>
  
  <!-- Cologne -->
  <xsl:template match="cologne-members">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'cologne'" />
    </xsl:call-template>
  </xsl:template>
  
  
  <!-- Copenhagen -->
    <xsl:template match="aarhus-members">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'aarhus'" />
    </xsl:call-template>
  </xsl:template>
  
  <!-- Düsseldorf -->
  <xsl:template match="duesseldorf-members">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'duesseldorf'" />
    </xsl:call-template>
  </xsl:template>
  
  <!-- Frankfurt -->
  <xsl:template match="frankfurt-members">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'frankfurt'" />
    </xsl:call-template>
  </xsl:template>
  
  <!-- Germany -->
    <xsl:template match="germany-members">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'germany'" />
    </xsl:call-template>
  </xsl:template>
  
  
  
  <!-- Hamburg -->
  <xsl:template match="hamburg-members">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'hamburg'" />
    </xsl:call-template>
  </xsl:template>
  
  <!-- Italy -->
  <xsl:template match="italy-members">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'italy'" />
    </xsl:call-template>
  </xsl:template>
  
    <!-- Linz -->
  <xsl:template match="linz-members">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'linz'" />
    </xsl:call-template>
  </xsl:template>
  
  <!-- Manchester -->
    <xsl:template match="manchester-members">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'manchester'" />
    </xsl:call-template>
  </xsl:template>
  
  
  <!-- München -->
  <xsl:template match="munich-members">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'munich'" />
    </xsl:call-template>
  </xsl:template>
  
  <!-- Netherlands -->
  <xsl:template match="netherlands-members">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'netherlands'" />
    </xsl:call-template>
  </xsl:template>
  
  <!-- Paris -->
  <xsl:template match="paris-members">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'paris'" />
    </xsl:call-template>
  </xsl:template>
  
  <!-- Spain -->
  <xsl:template match="spain-members">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'spain'" />
    </xsl:call-template>
  </xsl:template>
  
  <!-- Switzerland -->
  <xsl:template match="switzerland-members">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'switzerland'" />
    </xsl:call-template>
  </xsl:template>
  
    <!-- Vienna -->
  <xsl:template match="vienna-members">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'vienna'" />
    </xsl:call-template>
  </xsl:template>


  <!-- Zurich -->
  <xsl:template match="zurich-members">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'zurich'" />
    </xsl:call-template>
  </xsl:template>
  
</xsl:stylesheet>
