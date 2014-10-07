<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- xsl:import href="../../build/xslt/fsfe_headings.xsl" / -->
  <xsl:include href="../../build/xslt/notifications.xsl" />
  <!--xsl:include href="../../build/xslt/fsfe_followupsection.xsl" /-->
  <xsl:include href="../../build/xslt/translation_list.xsl" />
  <xsl:include href="../../build/xslt/footer_sitenav.xsl" />
  <xsl:include href="../../build/xslt/footer_sourcelink.xsl" />
  <xsl:include href="../../build/xslt/footer_legal.xsl" />

  <xsl:include href="../../tools/xsltsl/static-elements.xsl" />
  <xsl:include href="../../tools/xsltsl/translations.xsl" />

  <xsl:template name="page-body">
    <xsl:element name="body">
      <xsl:element name="header">
        <xsl:attribute name="id">top</xsl:attribute>
<!--
        <xsl:element name="div">
          <xsl:attribute name="class">logo</xsl:attribute>
          <xsl:element name="a">
            <xsl:attribute name="href">http://drm.info</xsl:attribute>
            <xsl:element name="img">
              <xsl:attribute name="src">logos/drm_logo_top.png</xsl:attribute>
              <xsl:attribute name="alt">DRM.Info</xsl:attribute>
            </xsl:element>
          </xsl:element>
        </xsl:element>
-->
        <xsl:call-template name="translation_list" />

		<xsl:element name="div">
          <xsl:attribute name="id">menu</xsl:attribute>
	  <xsl:element name="div">
            <xsl:attribute name="class">container</xsl:attribute>

            <xsl:element name="ul">
	    <xsl:attribute name="class">links</xsl:attribute>
              <xsl:element name="li">
                <xsl:attribute name="class">menu-302 first</xsl:attribute>
		<xsl:element name="a">
                  <xsl:attribute name="href">what-is-drm.en.html</xsl:attribute>
		  What is DRM
                </xsl:element>
              </xsl:element>
              <xsl:element name="li">
                 <xsl:attribute name="class">menu-302 first</xsl:attribute>
		<xsl:element name="a">
                  <xsl:attribute name="href">citizen-rights.en.html</xsl:attribute>
                  Citizens Rights
                </xsl:element>
              </xsl:element>
              <xsl:element name="li">
		 <xsl:attribute name="class">menu-302 first</xsl:attribute>
                <xsl:element name="a">
                  <xsl:attribute name="href">privacy.en.html</xsl:attribute>
                  Privacy
                </xsl:element>
              </xsl:element>
	      <xsl:element name="li">
                 <xsl:attribute name="class">menu-302 first</xsl:attribute>
                <xsl:element name="a">
                  <xsl:attribute name="href">creativity.en.html</xsl:attribute>
                  Creativity
                </xsl:element>
              </xsl:element>
	      <xsl:element name="li">
                 <xsl:attribute name="class">menu-302 first</xsl:attribute>
                <xsl:element name="a">
                  <xsl:attribute name="href">act-now.en.html</xsl:attribute>
                  Act!
                </xsl:element>
              </xsl:element>
            </xsl:element>
	  </xsl:element>
        </xsl:element>

      </xsl:element>
      


 
<!--      <xsl:call-template name="notifications" /> -->

      <xsl:element name="div"> <xsl:attribute name="class">col2</xsl:attribute>
	
          <xsl:apply-templates select="body/node()" />
	</xsl:element>
      </xsl:element>
      
    
      <xsl:element name="div"><xsl:attribute name="class">col3</xsl:attribute>
	<xsl:element name="h3">Powered By</xsl:element>
        <xsl:element name="ul">
           <xsl:attribute name="class">links</xsl:attribute>
           <xsl:element name="li">
             <xsl:element name="a"><xsl:attribute name="href">https://fsfe.org/</xsl:attribute>
               <xsl:element name="img">
                 <xsl:attribute name="src">logos/logosmall.png</xsl:attribute>
                 <xsl:attribute name="alt">FSFE</xsl:attribute>
                 <xsl:attribute name="title">FSF Europe</xsl:attribute>
               </xsl:element>
             </xsl:element>
           </xsl:element>
</xsl:element>
        

	 <xsl:element name="h4">In Collaboration with</xsl:element>
	 <xsl:element name="ul">
	   <xsl:attribute name="class">links</xsl:attribute>
	   <xsl:element name="li">
	     <xsl:element name="a"><xsl:attribute name="href">https://digitalegesellschaft.de/</xsl:attribute>
	       <xsl:element name="img">
	         <xsl:attribute name="src">logos/digitalle-gesellschaft-logo.png</xsl:attribute>
		 <xsl:attribute name="alt">Digitalle Gesellschaft</xsl:attribute>
		 <xsl:attribute name="title">Digitalle Gesellschaft</xsl:attribute>
	       </xsl:element>
	     </xsl:element>
	   </xsl:element>
	   <xsl:element name="li">
             <xsl:element name="a"><xsl:attribute name="href">http://www.defectivebydesign.org/</xsl:attribute>
               <xsl:element name="img">
                 <xsl:attribute name="src">logos/dbd-logo-small.png</xsl:attribute>
                 <xsl:attribute name="alt">Defective By Design</xsl:attribute>
                 <xsl:attribute name="title">Defective By Design</xsl:attribute>
               </xsl:element>
             </xsl:element>
           </xsl:element>
	  <xsl:element name="li">
             <xsl:element name="a"><xsl:attribute name="href">http://www.eff.org/</xsl:attribute>
               <xsl:element name="img">
                 <xsl:attribute name="src">logos/EFF-logo-trans.thumbnail.png</xsl:attribute>
                 <xsl:attribute name="alt">Electronic Frontier Foundation</xsl:attribute>
                 <xsl:attribute name="title">Electronic Frontier Foundation</xsl:attribute>
               </xsl:element>
             </xsl:element>
           </xsl:element>
	   <xsl:element name="li">
             <xsl:element name="a"><xsl:attribute name="href">http://www.ccc.de/</xsl:attribute>
               <xsl:element name="img">
                 <xsl:attribute name="src">logos/ccc.png</xsl:attribute>
                 <xsl:attribute name="alt">Chaos Computer Club</xsl:attribute>
                 <xsl:attribute name="title">Chaos Computer Club</xsl:attribute>
               </xsl:element>
             </xsl:element>
           </xsl:element>
	</xsl:element>	
</xsl:element>
<!--      <xsl:element name="hr" /> 
      <xsl:element name="footer">
        <xsl:attribute name="id">bottom</xsl:attribute>
 
        <xsl:call-template name="footer_sitenav" />
        <xsl:element name="hr" />
        <xsl:call-template name="footer_sourcelink" />
        <xsl:call-template name="footer_legal" />
 
        <xsl:element name="section">
          <xsl:attribute name="id">sister-organisations</xsl:attribute>
          <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'fsfnetwork'" /></xsl:call-template>
        </xsl:element> 
      </xsl:element> -->

   
  </xsl:template>
</xsl:stylesheet>
