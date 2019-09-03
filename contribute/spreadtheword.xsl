<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../fsfe.xsl" />
  <xsl:import href="../tools/xsltsl/countries.xsl" />
  <xsl:output method="html" encoding="utf-8" indent="yes" doctype-system="about:legacy-compat" />

  <!-- dynamic content -->
  <xsl:template match="dynamic-content">
    <xsl:variable name="type"><xsl:value-of select="@type"/></xsl:variable>

    <xsl:for-each select="/buildinfo/document/set/item [@type = $type]">
      <xsl:sort select="@order" order="ascending"/>
      <xsl:variable name="id"><xsl:value-of select="@id"/></xsl:variable>
      <xsl:choose>

        <!-- item is an introductionary text -->
        <xsl:when test="@introduction = 'yes'">
          <xsl:element name="div">
            <xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
            <xsl:element name="p">
              <xsl:copy-of select="/buildinfo/document/set/info[@id=$id]/text" />
            </xsl:element>
          </xsl:element>
        </xsl:when>

        <!-- item is a normal promo item -->
        <xsl:otherwise>
          <!-- item -->
          <xsl:element name="div">
            <xsl:attribute name="class">row promoitem</xsl:attribute>
            <xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
            <xsl:variable name="year"><xsl:value-of select="@year"/></xsl:variable>

            <!-- Image -->
            <xsl:for-each select="image">
              <xsl:element name="div">
                <xsl:attribute name="class">grow col-md-2</xsl:attribute>
                <xsl:element name="a">
                  <xsl:if test="/buildinfo/document/set/info[@id=$id]/imagelink != ''">
                    <xsl:attribute name="target">_blank</xsl:attribute>
                    <xsl:attribute name="href">
                      <xsl:value-of select="/buildinfo/document/set/info[@id=$id]/imagelink" />
                    </xsl:attribute>
                  </xsl:if>
                  <xsl:element name="img">
                    <xsl:attribute name="class">promoimg img-rounded</xsl:attribute>
                    <xsl:attribute name="src">
                      <xsl:value-of select="@imgsmall" />
                    </xsl:attribute>
                  </xsl:element>
                </xsl:element>
              </xsl:element>
            </xsl:for-each>

            <!-- item details -->
            <xsl:element name="div">
              <xsl:attribute name="class">col-md-10 promoitemdetails</xsl:attribute>

              <!-- Name -->
              <xsl:element name="h4">
                <xsl:value-of select="/buildinfo/document/set/info[@id=$id]/name" />
              </xsl:element>

              <!-- Description -->
              <xsl:if test="/buildinfo/document/set/info[@id=$id]/description != ''">
                <xsl:element name="p">
                  <xsl:copy-of select="/buildinfo/document/set/info[@id=$id]/description" />
                </xsl:element>
              </xsl:if>

              <xsl:element name="div">
                <xsl:attribute name="class">col-md-6</xsl:attribute>

                <!-- Type -->
                <xsl:if test="/buildinfo/document/set/info[@id=$id]/type != ''">
                  <xsl:element name="div">
                    <xsl:attribute name="class">row</xsl:attribute>
                    <xsl:element name="div">
                      <xsl:attribute name="class">col-md-12</xsl:attribute>
                      <xsl:element name="span">
                        <xsl:attribute name="class">detail-label</xsl:attribute>
                        <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'stw-type'" /></xsl:call-template>
                      </xsl:element>
                      <xsl:element name="span">
                        <xsl:value-of select="/buildinfo/document/set/info[@id=$id]/type" />
                      </xsl:element>
                    </xsl:element>
                  </xsl:element>
                </xsl:if>

                <!-- Size -->
                <xsl:if test="/buildinfo/document/set/info[@id=$id]/size != ''">
                  <xsl:element name="div">
                    <xsl:attribute name="class">row</xsl:attribute>
                    <xsl:element name="div">
                      <xsl:attribute name="class">col-md-12</xsl:attribute>
                      <xsl:element name="span">
                        <xsl:attribute name="class">detail-label</xsl:attribute>
                        <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'stw-size'" /></xsl:call-template>
                      </xsl:element>
                      <xsl:element name="span">
                        <xsl:value-of select="/buildinfo/document/set/info[@id=$id]/size" />
                      </xsl:element>
                    </xsl:element>
                  </xsl:element>
                </xsl:if>

                <!-- Context (e.g Campaign) -->
                <xsl:if test="/buildinfo/document/set/info[@id=$id]/context != ''">
                  <xsl:element name="div">
                    <xsl:attribute name="class">row</xsl:attribute>
                    <xsl:element name="div">
                      <xsl:attribute name="class">col-md-12</xsl:attribute>
                      <xsl:element name="span">
                        <xsl:attribute name="class">detail-label</xsl:attribute>
                        <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'stw-context'" /></xsl:call-template>
                      </xsl:element>
                      <xsl:element name="span">
                        <xsl:copy-of select="/buildinfo/document/set/info[@id=$id]/context" />
                      </xsl:element>
                    </xsl:element>
                  </xsl:element>
                </xsl:if>

                <!-- Download -->
                <xsl:if test="/buildinfo/document/set/info[@id=$id]/languages != ''">
                  <xsl:element name="div">
                    <xsl:attribute name="class">row</xsl:attribute>
                    <xsl:element name="div">
                      <xsl:attribute name="class">col-md-12</xsl:attribute>
                      <xsl:element name="span">
                        <xsl:attribute name="class">detail-label</xsl:attribute>
                        <xsl:element name="abbr"> <!-- mouseover info text -->
                          <xsl:attribute name="title">
                            <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'stw-languages-tooltip'" /></xsl:call-template>
                          </xsl:attribute>
                          <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'stw-languages'" /></xsl:call-template>
                        </xsl:element>
                      </xsl:element>
                      <xsl:element name="span">
                        <xsl:copy-of select="/buildinfo/document/set/info[@id=$id]/languages" />
                      </xsl:element>
                    </xsl:element>
                  </xsl:element>
                </xsl:if>

                <!-- Printed order -->
                <xsl:if test="/buildinfo/document/set/info[@id=$id]/printed != ''">
                  <xsl:element name="div">
                    <xsl:attribute name="class">row</xsl:attribute>
                    <xsl:element name="div">
                      <xsl:attribute name="class">col-md-12</xsl:attribute>
                      <xsl:element name="span">
                        <xsl:attribute name="class">detail-label</xsl:attribute>
                        <xsl:element name="abbr"> <!-- mouseover info text -->
                          <xsl:attribute name="title">
                            <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'stw-printed-tooltip'" /></xsl:call-template>
                          </xsl:attribute>
                          <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'stw-printed'" /></xsl:call-template>
                        </xsl:element>
                      </xsl:element>
                      <xsl:element name="span">
                        <xsl:copy-of select="/buildinfo/document/set/info[@id=$id]/printed" />
                      </xsl:element>
                    </xsl:element>
                  </xsl:element>
                </xsl:if>
              </xsl:element>

              <xsl:element name="div">
                <xsl:attribute name="class">col-md-6</xsl:attribute>

                <!-- Author -->
                <xsl:if test="/buildinfo/document/set/info[@id=$id]/author != ''">
                  <xsl:element name="div">
                    <xsl:attribute name="class">row</xsl:attribute>
                    <xsl:element name="div">
                      <xsl:attribute name="class">col-md-12</xsl:attribute>
                      <xsl:element name="span">
                        <xsl:attribute name="class">detail-label</xsl:attribute>
                        <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'stw-author'" /></xsl:call-template>
                      </xsl:element>
                      <xsl:element name="span">
                        <xsl:copy-of select="/buildinfo/document/set/info[@id=$id]/author" />
                      </xsl:element>
                    </xsl:element>
                  </xsl:element>
                </xsl:if>

                <!-- License -->
                <xsl:if test="/buildinfo/document/set/info[@id=$id]/license != ''">
                  <xsl:element name="div">
                    <xsl:attribute name="class">row</xsl:attribute>
                    <xsl:element name="div">
                      <xsl:attribute name="class">col-md-12</xsl:attribute>
                      <xsl:element name="span">
                        <xsl:attribute name="class">detail-label</xsl:attribute>
                        <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'stw-license'" /></xsl:call-template>
                      </xsl:element>
                      <xsl:element name="span">
                        <xsl:copy-of select="/buildinfo/document/set/info[@id=$id]/license" />
                      </xsl:element>
                    </xsl:element>
                  </xsl:element>
                </xsl:if>

                <!-- Year -->
                <xsl:if test="/buildinfo/document/set/info[@id=$id]/year != ''">
                  <xsl:element name="div">
                    <xsl:attribute name="class">row</xsl:attribute>
                    <xsl:element name="div">
                      <xsl:attribute name="class">col-md-12</xsl:attribute>
                      <xsl:element name="span">
                        <xsl:attribute name="class">detail-label</xsl:attribute>
                        <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'stw-year'" /></xsl:call-template>
                      </xsl:element>
                      <xsl:element name="span">
                        <xsl:value-of select="$year"/>
                      </xsl:element>
                    </xsl:element>
                  </xsl:element>
                </xsl:if>

                <!-- Source -->
                <xsl:if test="/buildinfo/document/set/info[@id=$id]/source != ''">
                  <xsl:element name="div">
                    <xsl:attribute name="class">row</xsl:attribute>
                    <xsl:element name="div">
                      <xsl:attribute name="class">col-md-12</xsl:attribute>
                      <xsl:element name="span">
                        <xsl:attribute name="class">detail-label</xsl:attribute>
                        <xsl:element name="abbr"> <!-- mouseover info text -->
                          <xsl:attribute name="title">
                            <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'stw-source-tooltip'" /></xsl:call-template>
                          </xsl:attribute>
                          <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'stw-source'" /></xsl:call-template>
                        </xsl:element>
                      </xsl:element>
                      <xsl:element name="span">
                        <xsl:copy-of select="/buildinfo/document/set/info[@id=$id]/source" />
                      </xsl:element>
                    </xsl:element>
                  </xsl:element>
                </xsl:if>

                <!-- TODO: REMOVE if not used -->
                <!-- Printready -->
                <xsl:if test="/buildinfo/document/set/info[@id=$id]/printready != ''">
                  <xsl:element name="div">
                    <xsl:attribute name="class">row</xsl:attribute>
                    <xsl:element name="div">
                      <xsl:attribute name="class">col-md-12</xsl:attribute>
                      <xsl:element name="span">
                        <xsl:attribute name="class">detail-label</xsl:attribute>
                        <xsl:element name="abbr"> <!-- mouseover info text -->
                          <xsl:attribute name="title">
                            <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'stw-printready-tooltip'" /></xsl:call-template>
                          </xsl:attribute>
                          <xsl:call-template name="fsfe-gettext"><xsl:with-param name="id" select="'stw-printready'" /></xsl:call-template>
                        </xsl:element>
                      </xsl:element>
                      <xsl:element name="span">
                        <xsl:copy-of select="/buildinfo/document/set/info[@id=$id]/printready" />  -->
                      </xsl:element>
                    </xsl:element>
                  </xsl:element>
                </xsl:if>
              </xsl:element>
            </xsl:element>
          </xsl:element>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <!-- Dropdown list of countries requiring a choice -->
  <!-- when copying this, remember importing the xsl, and editing the .source file -->
  <xsl:template match="country-list">
    <xsl:call-template name="country-list">
      <xsl:with-param name="required" select="'yes'"/>
      <xsl:with-param name="class" select="'form-control'"/>
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
