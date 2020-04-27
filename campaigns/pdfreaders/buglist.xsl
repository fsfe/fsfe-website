<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../../fsfe.xsl" />

  <!-- Fill dynamic index -->
  <xsl:template match="dynamic-index">
    <xsl:for-each select="/buildinfo/document/set/buglist">
      <xsl:sort select="@country"/>

      <xsl:variable name="country">
        <xsl:value-of select="@country"/>
      </xsl:variable>

      <xsl:element name="li">
        <xsl:element name="a">
          <xsl:attribute name="href">
            <xsl:text>#</xsl:text>
            <xsl:value-of select="$country"/>
          </xsl:attribute>
          <xsl:value-of select="/buildinfo/document/set/country[@id=$country]"/>
        </xsl:element>
      </xsl:element>

    </xsl:for-each>
  </xsl:template>
  
  
  <!-- fill in global figures -->
  
  <xsl:variable name="solved">
    <xsl:value-of select="count( /buildinfo/document/set/buglist/bug[@closed != ''] )" />
  </xsl:variable>
  
  <xsl:variable name="total">
    <xsl:value-of select="count( /buildinfo/document/set/buglist/bug )" />
  </xsl:variable>
  
  <xsl:template match="solved">
    <xsl:value-of select="$solved" />
  </xsl:template>
  
  <xsl:template match="bugs">
    <xsl:value-of select="$total" />
  </xsl:template>
  
  <xsl:template match="globalpct">
    <xsl:value-of select="floor($solved div $total * 100)" />
  </xsl:template>
  
  
  <!-- <xsl:key name="indivs-by-name" match="/buildinfo/document/set/buglist/bug/@name" use="normalize-space(.)" />
  <xsl:key name="groups-by-name" match="/buildinfo/document/set/buglist/bug/@group" use="normalize-space(.)" /> -->
  
  <!-- Fill dynamic content -->
  <xsl:template match="dynamic-content">
    
    <!-- <xsl:value-of select="count( /buildinfo/document/set/buglist/bug[@closed != ''] ) " /><br/>
    <xsl:value-of select="count( /buildinfo/document/set/buglist/bug ) " /><br/>
    <xsl:value-of select="floor( count(/buildinfo/document/set/buglist/bug[@closed != '']) div count( /buildinfo/document/set/buglist/bug ) * 100)" /><br/>
    -->
    
    <xsl:for-each select="/buildinfo/document/set/buglist">
      <xsl:sort select="@country"/>
      
      <xsl:variable name="country">
        <xsl:value-of select="@country"/>
      </xsl:variable>
      
      <!-- Heading -->
      <xsl:element name="h2">
        <xsl:attribute name="id">
          <xsl:value-of select="$country"/>
        </xsl:attribute>
        <xsl:value-of select="/buildinfo/document/set/country[@id=$country]"/>
        <xsl:variable name="nbsolved" select="count( /buildinfo/document/set/buglist[@country=$country]/bug[@closed != ''] )" />
        <xsl:variable name="nbinst" select="count( /buildinfo/document/set/buglist[@country=$country]/bug )" />
        (<xsl:value-of select="$nbsolved" />/<xsl:value-of select="$nbinst" /> = <xsl:value-of select="floor($nbsolved div $nbinst * 100)" />%)
      </xsl:element>
      
      <!-- Table header -->
      <xsl:element name="table">
        <xsl:element name="tr">
          <xsl:element name="th"><xsl:value-of select="/buildinfo/document/text[@id='institution-name']"/></xsl:element>
          <!--<xsl:element name="th"><xsl:value-of select="/buildinfo/document/text[@id='institution-address']"/></xsl:element>-->
          <!--<xsl:element name="th"><xsl:value-of select="/buildinfo/document/text[@id='institution-url']"/></xsl:element>-->
          <xsl:element name="th"><xsl:value-of select="/buildinfo/document/text[@id='opened']"/></xsl:element>
          <xsl:element name="th"><xsl:value-of select="/buildinfo/document/text[@id='closed']"/></xsl:element>
          <xsl:element name="th"><xsl:value-of select="/buildinfo/document/text[@id='name']"/></xsl:element>
          <xsl:element name="th"><xsl:value-of select="/buildinfo/document/text[@id='group']"/></xsl:element>
          <xsl:element name="th"><xsl:value-of select="/buildinfo/document/text[@id='closedby']"/></xsl:element>
          <xsl:element name="th"><xsl:value-of select="/buildinfo/document/text[@id='comment']"/></xsl:element>
        </xsl:element>
        
        <!-- Table rows -->
        <xsl:for-each select="bug">
          <xsl:element name="tr">
	        <xsl:if test = "string(@closed)">
	          <xsl:attribute name="class">highlighted</xsl:attribute>
	        </xsl:if>
            <xsl:element name="td">
              <xsl:element name="a">
                <xsl:attribute name="href">
                  <xsl:value-of select="@institution-url"/>
                </xsl:attribute>
                <xsl:value-of select="@institution-name"/><!--<xsl:value-of select="/buildinfo/document/text[@id='link']"/>-->
              </xsl:element>
            </xsl:element>
            <xsl:comment><xsl:element name="td"><xsl:value-of select="translate(@institution-address, '-', '–' )"/></xsl:element></xsl:comment>
            <xsl:element name="td"><xsl:value-of select="@opened"/></xsl:element>
            <xsl:element name="td"><xsl:value-of select="@closed"/></xsl:element>
            <xsl:element name="td"><xsl:value-of select="@name"/></xsl:element>
            <xsl:element name="td"><xsl:value-of select="@group"/></xsl:element>
            <xsl:element name="td"><xsl:value-of select="@closedby"/></xsl:element>
            <xsl:element name="td"><xsl:value-of select="@comment"/></xsl:element>
          </xsl:element>
        </xsl:for-each>
      </xsl:element>

    </xsl:for-each>
    
    <!-- List of participants -->
    <!-- 
    <xsl:value-of select="count(/buildinfo/document/set/buglist/bug/@group[ generate-id() = generate-id(key('groups-by-name', normalize-space(.))) ])" />
    
    <xsl:element name="ul">
      
      <xsl:for-each select=" /buildinfo/document/set/buglist/bug/@group[ generate-id() = generate-id(key('groups-by-name', normalize-space(.))) ] ">
        <xsl:sort select="count( /buildinfo/document/set/buglist/bug/@name = . )" data-type="number" />
        
        <xsl:variable name="name" select="." />
        
        <xsl:if test="position() &lt;= 5">
          
          <xsl:element name="li">
            <xsl:value-of select="count( /buildinfo/document/set/buglist/bug[@group=$name] )" />
            <xsl:text>-</xsl:text>
            <xsl:value-of select="$name" />
          </xsl:element>
          
        </xsl:if>
        
      </xsl:for-each>
    
    </xsl:element>
    -->
    
  </xsl:template>

</xsl:stylesheet>
