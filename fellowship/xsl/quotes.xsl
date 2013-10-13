<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="xml" encoding="UTF-8" indent="yes" />

	<xsl:template name="quote-box">
		<xsl:param name="tag" select="''"/> <!-- if left empty, all quotes will be selected -->

		<div id="quote-box">
			<div id="quote-box-inner" class="logo-list quote">
				<div class="img">
					<noscript>
						<img src="graphics/people/fry.jpg"/>
					</noscript>
				</div>

				<div class="cont">
					<noscript>
						<p class="txt">It is time once and for all to end the pointless 
							nonsense of one document sent on one platform being incomprehensible 
							to the user of another.</p>
						<p><span class="author">
							Stephen Fry, actor &amp; screenwriter, technology journalist, The Guardian
						</span></p>
					</noscript>
				</div>
			</div>
		</div>

		<script type="text/javascript">
			/* &lt;![CDATA[ */

			var quotes = [
			<xsl:for-each select="/html/set/quotes/quote[@tag=$tag or $tag='']">
				{
					'txt': '<xsl:call-template name="escape"><xsl:with-param name="string" select="normalize-space(txt)"/></xsl:call-template>',
					'photo': '<xsl:value-of select="normalize-space(photo)"/>',
					'author': '<xsl:call-template name="escape"><xsl:with-param name="string" select="normalize-space(author)"/></xsl:call-template>',
					'license': '<xsl:call-template name="escape"><xsl:with-param name="string" select="normalize-space(license)"/></xsl:call-template>',
				},
			</xsl:for-each>
			];

			<![CDATA[
			var index = 0;
			function changeImage () {

				var oldIndex = index;
				//index = (index+1)%quotes.length;
				index = Math.floor(Math.random()*quotes.length);

				$('#quote-box-inner').fadeOut('slow', function() {
					$('#quote-box-inner div.img').html('<img src="'+quotes[index]['photo']+'"/>');
					$('#quote-box-inner div.cont').html('<p class="txt"><a href="/testimonials.html" title="Who else supports DFD?" class="quote-box">'
					                              + quotes[index]['txt']
					                              + '</a></p><p><span class="author">'
					                              + quotes[index]['author']
					                              + '</span><span class="license">'
					                              + quotes[index]['license']
					                              + '</span></p>'
					);
					$('#quote-box-inner').fadeIn('slow', function() {});
				});

				setTimeout("changeImage();",10000);

			}

			changeImage();
			]]>

			/* ]]&gt; */
		</script>

	</xsl:template>

	<xsl:template name="escape">
		<xsl:param name="string"/>
		<xsl:variable name="apos" select='"&apos;"' />
		<xsl:choose>
			<xsl:when test='contains($string, $apos)'>
				<xsl:value-of select="substring-before($string,$apos)" />
				<xsl:text>\'</xsl:text>
				<xsl:call-template name="escape">
					<xsl:with-param name="string" select="substring-after($string, $apos)" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$string" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
