<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!--
    "css-mode" controls the type of style processing.
    It can have the following values:
    - "browser" for local development.
      Styles are compiled live in the browser using the JavaScript less compiler.
    - "compiled" The website includes the "fsfe.min.css" file
       that has to be compiled by the build script.

    For fsfe.org itself the value is replaced server side before build.
  -->
  <xsl:variable name="css-mode" select="'browser'" />
</xsl:stylesheet>
