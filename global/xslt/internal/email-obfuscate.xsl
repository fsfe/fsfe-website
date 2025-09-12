<?xml version="1.0" encoding="UTF-8"?>
<!-- ====================================================================== -->
<!-- XML tag for obfuscating an email address against scaper bots           -->
<!-- ====================================================================== -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exsl="http://exslt.org/common" version="1.0">
  <xsl:import href="../thirdparty/tokenize.xsl"/>
  <!-- plain email is the input -->
  <xsl:template name="email" match="email">
    <xsl:param name="email" select="."/>
    <xsl:param name="mailto" select="@mailto"/>
    <xsl:param name="subject" select="@subject"/>
    <!-- Split email on each character, creating a <token>character</token> element each -->
    <xsl:variable name="email-tokens">
      <xsl:call-template name="tokenize">
        <xsl:with-param name="string" select="$email"/>
        <xsl:with-param name="delimiters" select="''"/>
      </xsl:call-template>
    </xsl:variable>
    <!-- Replace the most common characters (with 4 exceptions) with their respective HTML entity or Hex -->
    <xsl:variable name="email-encoded">
      <xsl:for-each select="exsl:node-set($email-tokens)/token">
        <xsl:choose>
          <!--
            make sure only defined characters are replaced.
            To increase confusion, we do not replace e, m, r, and .
          -->
          <xsl:when test="translate(text(), 'abcdfghijklnopqstuvwxyz0123456789+-@','xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx') = 'x'">
            <xsl:text>&amp;#</xsl:text>
            <xsl:choose>
              <!-- lowercase characters -->
              <xsl:when test="text()='a'">x0061</xsl:when>
              <xsl:when test="text()='b'">98</xsl:when>
              <xsl:when test="text()='c'">x0063</xsl:when>
              <xsl:when test="text()='d'">100</xsl:when>
              <xsl:when test="text()='f'">102</xsl:when>
              <xsl:when test="text()='g'">x0067</xsl:when>
              <xsl:when test="text()='h'">104</xsl:when>
              <xsl:when test="text()='i'">x0069</xsl:when>
              <xsl:when test="text()='j'">106</xsl:when>
              <xsl:when test="text()='k'">x006b</xsl:when>
              <xsl:when test="text()='l'">108</xsl:when>
              <xsl:when test="text()='n'">110</xsl:when>
              <xsl:when test="text()='o'">x006f</xsl:when>
              <xsl:when test="text()='p'">112</xsl:when>
              <xsl:when test="text()='q'">x0071</xsl:when>
              <xsl:when test="text()='s'">x0073</xsl:when>
              <xsl:when test="text()='t'">116</xsl:when>
              <xsl:when test="text()='u'">x0075</xsl:when>
              <xsl:when test="text()='v'">118</xsl:when>
              <xsl:when test="text()='w'">x0077</xsl:when>
              <xsl:when test="text()='x'">120</xsl:when>
              <xsl:when test="text()='y'">x0079</xsl:when>
              <xsl:when test="text()='z'">122</xsl:when>
              <!-- numbers -->
              <xsl:when test="text()='0'">x0030</xsl:when>
              <xsl:when test="text()='1'">49</xsl:when>
              <xsl:when test="text()='2'">x0032</xsl:when>
              <xsl:when test="text()='3'">51</xsl:when>
              <xsl:when test="text()='4'">x0034</xsl:when>
              <xsl:when test="text()='5'">53</xsl:when>
              <xsl:when test="text()='6'">x0036</xsl:when>
              <xsl:when test="text()='7'">55</xsl:when>
              <xsl:when test="text()='8'">x0038</xsl:when>
              <xsl:when test="text()='9'">57</xsl:when>
              <!-- special chars relevant for emails -->
              <xsl:when test="text()='+'">43</xsl:when>
              <xsl:when test="text()='-'">x002d</xsl:when>
              <xsl:when test="text()='@'">64</xsl:when>
            </xsl:choose>
            <xsl:text>;</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="text()"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </xsl:variable>
    <!-- /$email-encoded -->
    <!-- Output email address in desired form -->
    <xsl:choose>
      <!-- Should be a clickable mailto: link -->
      <xsl:when test="$mailto = 'yes'">
        <!--
          Note: Super-ugly hack to avoid that HTML entities are escaped in the href
          attribute. Therefore, the a element is created "manually"
        -->
        <xsl:text disable-output-escaping="yes">&lt;a href="mailto:</xsl:text>
        <xsl:value-of select="$email-encoded" disable-output-escaping="yes"/>
        <xsl:text>?</xsl:text>
        <xsl:if test="$subject">
          <xsl:text>subject=</xsl:text>
          <xsl:value-of select="$subject"/>
        </xsl:if>
        <xsl:text disable-output-escaping="yes">"&gt;</xsl:text>
        <xsl:value-of select="$email-encoded" disable-output-escaping="yes"/>
        <xsl:text disable-output-escaping="yes">&lt;/a&gt;</xsl:text>
      </xsl:when>
      <!-- Default: just the obfuscated email address as string -->
      <xsl:otherwise>
        <xsl:value-of select="$email-encoded" disable-output-escaping="yes"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
