<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:import href="translations.xsl" />
  
  <xsl:output method="xml" encoding="UTF-8" indent="yes" />
  
  <xsl:template name="campaigns">

    <div  id="campaigns-boxes" class="cycle-slideshow"  data-cycle-pause-on-hover="true" data-cycle-speed="500"  data-cycle-timeout="9000" data-cycle-slides="a"  data-cycle-fx="scrollHorz" data-cycle-swipe="true">
        <div class="cycle-pager"/>
        <!--xsl:for-each select="   /buildinfo/textset/campaigns/campaign   "-->

        <xsl:for-each select="   /buildinfo/textset/campaigns/campaign[  @id = 'zacchiroli' or @id = 'dfd'  ]  ">
            <!--TODO select only campaigns asked from index.xsl-->

            <a href="{link}" class="campaign-box" id="{@id}">
                <img src="{photo}" alt="" />
                <p class="text">
                    <xsl:value-of select="   text   " />
                </p>
                <span class="author">
                    <xsl:value-of select="   author   " />
                </span>
            </a>
        </xsl-for-each>
    </div>
    
  </xsl:template>
  
</xsl:stylesheet>
