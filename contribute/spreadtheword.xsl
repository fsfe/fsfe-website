<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../fsfe.xsl" />
  <xsl:import href="../build/xslt/countries.xsl" />

  <!-- Fill dynamic content -->
  <xsl:template match="dynamic-content">
    <xsl:variable name="type"><xsl:value-of select="@type"/></xsl:variable>

    <xsl:for-each select="/buildinfo/document/set/item [@type = $type]">
      <xsl:sort select="@order" order="ascending"/>

      <xsl:variable name="id"><xsl:value-of select="@id"/></xsl:variable>

      <xsl:choose>
        <!-- item is just an introductionary text -->
        <xsl:when test="@introduction = 'yes'">
          <xsl:element name="p">
            <xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
            <xsl:attribute name="style">clear: both;</xsl:attribute>
            <xsl:copy-of select="/buildinfo/document/set/info[@id=$id]/text" />
          </xsl:element>
        </xsl:when>
        <xsl:otherwise>
          <!-- item is a normal promo item -->
          <!-- Full Item -->
          <xsl:element name="div">
            <xsl:attribute name="class">left break margin-vertical</xsl:attribute>
            <xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>

            <xsl:variable name="year"><xsl:value-of select="@year"/></xsl:variable>

            <!-- Name -->
            <xsl:element name="p">
              <xsl:element name="strong">
                <xsl:value-of select="/buildinfo/document/set/info[@id=$id]/name" />
              </xsl:element>
            </xsl:element>
            <!-- / Name -->

            <!-- Image -->
            <xsl:for-each select="image">
              <!-- <xsl:element name="a">
                <xsl:attribute name="href">
                  <xsl:value-of select="@imglarge" />
                </xsl:attribute>
                <xsl:attribute name="title">
                  <xsl:value-of select="/buildinfo/document/set/info[@id=$id]/name" />
                </xsl:attribute> -->

                <xsl:element name="img">
                  <xsl:attribute name="class">left grid-30</xsl:attribute>
                  <xsl:attribute name="src">
                    <xsl:value-of select="@imgsmall" />
                  </xsl:attribute>
                </xsl:element> <!-- /img -->
              <!-- </xsl:element> --> <!-- /a -->
            </xsl:for-each>
            <!-- /Image -->

            <!-- Description -->
            <xsl:element name="p">
              <xsl:attribute name="class">right grid-70</xsl:attribute>
              <xsl:attribute name="style">margin-top:0;</xsl:attribute>
              <xsl:copy-of select="/buildinfo/document/set/info[@id=$id]/description" />
            </xsl:element>
            <!-- / Description -->

        <!-- Printed version -->
              <xsl:if test="/buildinfo/document/set/info[@id=$id]/printed != ''">
                <xsl:element name="p">
            <xsl:attribute name="class">right grid-70</xsl:attribute>
                  <!--<xsl:attribute name="style">font-size:0.8em</xsl:attribute>-->
                  <xsl:element name="abbr"> <!-- mouseover info text -->
                    <xsl:attribute name="title">
                      <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'stw-printed-tooltip'" /></xsl:call-template>
                    </xsl:attribute>
                    <xsl:element name="strong"> <!-- Field name -->
                      <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'stw-printed'" /></xsl:call-template>
                    </xsl:element> <!-- /strong -->
                  </xsl:element> <!-- /abbr -->
                  <xsl:text>: </xsl:text>
                  <xsl:element name="br"></xsl:element>
                  <xsl:copy-of select="/buildinfo/document/set/info[@id=$id]/printed" /> <!-- Dynamic value of the field -->
                </xsl:element> <!-- /p -->
                <!--<xsl:element name="br"></xsl:element>-->
              </xsl:if>

            <!-- Details -->
            <xsl:element name="p">
              <xsl:attribute name="class">right grid-70</xsl:attribute>

              <!-- Type -->
              <xsl:if test="/buildinfo/document/set/info[@id=$id]/type != ''">
                <xsl:element name="strong">
                  <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'stw-type'" /></xsl:call-template>
                  <xsl:text>: </xsl:text>
                </xsl:element>
                <xsl:value-of select="/buildinfo/document/set/info[@id=$id]/type" />
                <xsl:element name="br"></xsl:element>
              </xsl:if>

              <!-- Size -->
              <xsl:if test="/buildinfo/document/set/info[@id=$id]/size != ''">
                <xsl:element name="strong">
                  <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'stw-size'" /></xsl:call-template>
                  <xsl:text>: </xsl:text>
                </xsl:element>
                <xsl:value-of select="/buildinfo/document/set/info[@id=$id]/size" />
                <xsl:element name="br"></xsl:element>
              </xsl:if>

              <!-- Context (e.g Campaign) -->
              <xsl:if test="/buildinfo/document/set/info[@id=$id]/context != ''">
                <xsl:element name="strong">
                  <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'stw-context'" /></xsl:call-template>
                  <xsl:text>: </xsl:text>
                </xsl:element>
                <xsl:copy-of select="/buildinfo/document/set/info[@id=$id]/context" />
                <xsl:element name="br"></xsl:element>
              </xsl:if>

              <!-- Languages -->
              <xsl:if test="/buildinfo/document/set/info[@id=$id]/languages != ''">
                <xsl:element name="span">
                  <!--<xsl:attribute name="style">font-size:0.8em</xsl:attribute>-->
                  <xsl:element name="abbr"> <!-- mouseover info text -->
                    <xsl:attribute name="title">
                      <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'stw-languages-tooltip'" /></xsl:call-template>
                    </xsl:attribute>
                    <xsl:element name="strong"> <!-- Field name -->
                      <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'stw-languages'" /></xsl:call-template>
                    </xsl:element> <!-- /strong -->
                  </xsl:element> <!-- /abbr -->
                  <xsl:text>: </xsl:text>
                  <xsl:element name="br"></xsl:element>
                  <xsl:copy-of select="/buildinfo/document/set/info[@id=$id]/languages" /> <!-- Dynamic value of the field -->
                </xsl:element> <!-- /span -->
                <xsl:element name="br"></xsl:element>
              </xsl:if>

              <!-- License -->
              <xsl:if test="/buildinfo/document/set/info[@id=$id]/license != ''">
                <xsl:element name="strong">
                  <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'stw-license'" /></xsl:call-template>
                  <xsl:text>: </xsl:text>
                </xsl:element>
                <xsl:copy-of select="/buildinfo/document/set/info[@id=$id]/license" />
                <xsl:element name="br"></xsl:element>
              </xsl:if>

              <!-- Author -->
              <xsl:if test="/buildinfo/document/set/info[@id=$id]/author != ''">
                <xsl:element name="strong">
                  <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'stw-author'" /></xsl:call-template>
                  <xsl:text>: </xsl:text>
                </xsl:element>
                <xsl:copy-of select="/buildinfo/document/set/info[@id=$id]/author" />
                <xsl:element name="br"></xsl:element>
              </xsl:if>

              <!-- Year -->
              <xsl:if test="/buildinfo/document/set/info[@id=$id]/year != ''">
                <xsl:element name="strong">
                  <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'stw-year'" /></xsl:call-template>
                  <xsl:text>: </xsl:text>
                </xsl:element>
                <xsl:value-of select="$year"/>
                <xsl:element name="br"></xsl:element>
              </xsl:if>


              <!-- SMALLER TEXT -->
              <!-- Source -->
              <xsl:if test="/buildinfo/document/set/info[@id=$id]/source != ''">
                <xsl:element name="span">
                  <xsl:attribute name="style">font-size:0.8em</xsl:attribute>
                  <xsl:element name="abbr"> <!-- mouseover info text -->
                    <xsl:attribute name="title">
                      <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'stw-source-tooltip'" /></xsl:call-template>
                    </xsl:attribute>
                    <xsl:element name="strong"> <!-- Field name -->
                      <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'stw-source'" /></xsl:call-template>
                    </xsl:element> <!-- /strong -->
                  </xsl:element> <!-- /abbr -->
                  <xsl:text>: </xsl:text>
                  <xsl:element name="br"></xsl:element>
                  <xsl:copy-of select="/buildinfo/document/set/info[@id=$id]/source" /> <!-- Dynamic value of the field -->
                </xsl:element> <!-- /span -->
                <xsl:element name="br"></xsl:element>
              </xsl:if>

              <!-- Printready -->
              <xsl:if test="/buildinfo/document/set/info[@id=$id]/printready != ''">
                <xsl:element name="span">
                  <xsl:attribute name="style">font-size:0.8em</xsl:attribute>
                  <xsl:element name="abbr"> <!-- mouseover info text -->
                    <xsl:attribute name="title">
                      <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'stw-printready-tooltip'" /></xsl:call-template>
                    </xsl:attribute>
                    <xsl:element name="strong"> <!-- Field name -->
                      <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'stw-printready'" /></xsl:call-template>
                    </xsl:element> <!-- /strong -->
                  </xsl:element> <!-- /abbr -->
                  <xsl:text>: </xsl:text>
                  <xsl:element name="br"></xsl:element>
                  <xsl:copy-of select="/buildinfo/document/set/info[@id=$id]/printready" /> <!-- Dynamic value of the field -->
                </xsl:element> <!-- /span -->
                <xsl:element name="br"></xsl:element>
              </xsl:if>

            </xsl:element>
            <!-- / Details -->

          </xsl:element>
          <!-- / Full Item -->

        </xsl:otherwise>

      </xsl:choose>



    </xsl:for-each>

  </xsl:template>

  <!-- Dropdown list of countries requiring a choice -->
  <!-- when copying this, remember importing the xsl, and editing the .source file -->
  <xsl:template match="country-list">
    <xsl:call-template name="country-list">
      <xsl:with-param name="required" select="'yes'"/>
      <xsl:with-param name="subset" select="'eea'"/>
    </xsl:call-template>
  </xsl:template>

  <!-- Add a hidden field to the form to identify the language used. -->
  <xsl:template match="add-language">
    <xsl:element name="input">
      <xsl:attribute name="type">hidden</xsl:attribute>
      <xsl:attribute name="name">language</xsl:attribute>
      <xsl:attribute name="value">
        <xsl:value-of select="/buildinfo/@language" />
      </xsl:attribute>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
