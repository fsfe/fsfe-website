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
      <xsl:with-param name="display" select="'coordinators'" />
    </xsl:call-template>
  </xsl:template>
  
  <!-- Austria -->
  <xsl:template match="austria-members">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'at'" />
      <xsl:with-param name="display" select="'coordinators'" />
    </xsl:call-template>
  </xsl:template>
  
  <!-- Barcelona -->
  <xsl:template match="barcelona-members">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'barcelona'" />
      <xsl:with-param name="display" select="'coordinators'" />
    </xsl:call-template>
  </xsl:template>
  
  <!-- Bari -->
  <xsl:template match="bari-members">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'bari'" />
      <xsl:with-param name="display" select="'coordinators'" />
    </xsl:call-template>
  </xsl:template>
  
  <!-- Belgium -->
  <xsl:template match="belgium-members">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'be'" />
      <xsl:with-param name="display" select="'coordinators'" />
    </xsl:call-template>
  </xsl:template>
   
  <!-- Berlin -->
  <xsl:template match="berlin-members">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'berlin'" />
      <xsl:with-param name="display" select="'coordinators'" />
    </xsl:call-template>
  </xsl:template>
  
  <!-- Bonn -->
  <xsl:template match="bonn-members">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'bonn'" />
      <xsl:with-param name="display" select="'coordinators'" />
    </xsl:call-template>
  </xsl:template>
  
  <!-- Cologne -->
  <xsl:template match="cologne-members">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'cologne'" />
      <xsl:with-param name="display" select="'coordinators'" />
    </xsl:call-template>
  </xsl:template>
  
  <!-- Copenhagen -->
    <xsl:template match="aarhus-members">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'aarhus'" />
      <xsl:with-param name="display" select="'coordinators'" />
    </xsl:call-template>
  </xsl:template>
  
  <!-- Düsseldorf -->
  <xsl:template match="duesseldorf-members">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'duesseldorf'" />
      <xsl:with-param name="display" select="'coordinators'" />
    </xsl:call-template>
  </xsl:template>
  
  <!-- Germany -->
    <xsl:template match="germany-members">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'de'" />
      <xsl:with-param name="display" select="'coordinators'" />
    </xsl:call-template>
  </xsl:template>
  
  <!-- Great Britain -->
    <xsl:template match="unitedkingdom-members">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'gb'" />
      <xsl:with-param name="display" select="'coordinators'" />
    </xsl:call-template>
  </xsl:template>
  
  <!-- Hamburg -->
  <xsl:template match="hamburg-members">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'hamburg'" />
      <xsl:with-param name="display" select="'coordinators'" />
    </xsl:call-template>
  </xsl:template>
  
  <!-- Italy -->
  <xsl:template match="italy-members">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'it'" />
      <xsl:with-param name="display" select="'coordinators'" />
    </xsl:call-template>
  </xsl:template>
  
    <!-- Linz -->
  <xsl:template match="linz-members">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'linz'" />
      <xsl:with-param name="display" select="'coordinators'" />
    </xsl:call-template>
  </xsl:template>
  
  <!-- Manchester -->
    <xsl:template match="manchester-members">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'manchester'" />
      <xsl:with-param name="display" select="'coordinators'" />
    </xsl:call-template>
  </xsl:template>
  
  <!-- München -->
  <xsl:template match="munich-members">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'munich'" />
      <xsl:with-param name="display" select="'coordinators'" />
    </xsl:call-template>
  </xsl:template>
  
  <!-- Netherlands -->
  <xsl:template match="netherlands-members">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'nl'" />
      <xsl:with-param name="display" select="'coordinators'" />
    </xsl:call-template>
  </xsl:template>
  
  <!-- Paris -->
  <xsl:template match="paris-members">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'paris'" />
      <xsl:with-param name="display" select="'coordinators'" />
    </xsl:call-template>
  </xsl:template>
  
  <!-- Representatives -->
  <xsl:template match="representatives-members">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'representatives'" />
    </xsl:call-template>
  </xsl:template>

  <!-- Rhein/Main -->
  <xsl:template match="rheinmain-members">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'rheinmain'" />
      <xsl:with-param name="display" select="'coordinators'" />
    </xsl:call-template>
  </xsl:template>

    <!-- Slovenia -->
  <xsl:template match="slovenia-members">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'si'" />
      <xsl:with-param name="display" select="'coordinators'" />
    </xsl:call-template>
  </xsl:template>
  
  <!-- Spain -->
  <xsl:template match="spain-members">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'es'" />
      <xsl:with-param name="display" select="'coordinators'" />
    </xsl:call-template>
  </xsl:template>
  
  <!-- Switzerland -->
  <xsl:template match="switzerland-members">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'ch'" />
      <xsl:with-param name="display" select="'coordinators'" />
    </xsl:call-template>
  </xsl:template>
  
    <!-- Vienna -->
  <xsl:template match="vienna-members">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'vienna'" />
      <xsl:with-param name="display" select="'coordinators'" />
    </xsl:call-template>
  </xsl:template>

  <!-- Zurich -->
  <xsl:template match="zurich-members">
    <xsl:call-template name="country-people-list">
      <xsl:with-param name="team" select="'zurich'" />
      <xsl:with-param name="display" select="'coordinators'" />
    </xsl:call-template>
  </xsl:template>
  
</xsl:stylesheet>
