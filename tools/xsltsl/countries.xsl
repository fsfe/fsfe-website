<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:import href="feeds.xsl" />
    <xsl:output method="xml"
                encoding="UTF-8"
                indent="yes" />
    
    <!-- displays list of people for a given country (or a given team, i.e. "main") -->
    <xsl:template name="country-people-list">
        <xsl:param name="team"
                   select="''" />
        <!-- parameter 'team' is your country code -->
        
        <xsl:variable name="teamcomma"><xsl:value-of select="$team" />,</xsl:variable>
        <xsl:variable name="commateam">, <xsl:value-of select="$team" /></xsl:variable>
        
        <xsl:element name="ul">
            <xsl:attribute name="class">people</xsl:attribute>
            <xsl:for-each select="/html/set/person[
                                    contains(@teams, $commateam) or
				                    contains(@teams, $teamcomma) or
				                    @teams=$team or
				                    $team='']"> 
                
                <xsl:sort select="@id" />
                <xsl:variable name="id"
                              select="@id" />

<!--                <xsl:variable name="avatar" select="@avatar" />-->

                <xsl:element name="li">
                    <xsl:element name="p">
                        <!-- Picture -->
                        <xsl:choose>
                                <xsl:when test="avatar">
                                        <xsl:choose>
                                            <xsl:when test="link != ''">
                                                <xsl:element name="a">
                                                    <xsl:attribute name="href">
                                                        <xsl:value-of select="link" />
                                                    </xsl:attribute>
                                                    
                <!--                                    <xsl:call-template name="avatar">-->
                <!--                                     <xsl:with-param name="id" select="$id" />-->
                <!--                                     <xsl:with-param name="haveavatar" select="$avatar" />-->
                <!--                                    </xsl:call-template>-->
                                                        <xsl:element name="img">
                                                                <xsl:attribute name="alt"><xsl:value-of select="name" /></xsl:attribute>
                                                                <xsl:attribute name="src"><xsl:value-of select="avatar" /></xsl:attribute>
                                                        </xsl:element>
                                                    
                                                </xsl:element>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                
                <!--                                <xsl:call-template name="avatar">-->
                <!--                                 <xsl:with-param name="id" select="$id" />-->
                <!--                                 <xsl:with-param name="haveavatar" select="$avatar" />-->
                <!--                                </xsl:call-template>-->
                                                <xsl:element name="img">
                                                        <xsl:attribute name="alt"><xsl:value-of select="name" /></xsl:attribute>
                                                        <xsl:attribute name="src"><xsl:value-of select="avatar" /></xsl:attribute>
                                                </xsl:element>
                                                
                                            </xsl:otherwise>
                                        </xsl:choose>
                                </xsl:when>
                                <xsl:otherwise>
                                        <xsl:element name="img">
                                                <xsl:attribute name="alt"><xsl:value-of select="name" /></xsl:attribute>
                                                <xsl:attribute name="src">/graphics/default-avatar.png</xsl:attribute>
                                        </xsl:element>
                                </xsl:otherwise>
                        </xsl:choose>
                        <!-- Name; if link is given show as link -->
                        <xsl:element name="span">
                            <xsl:attribute name="class">
                            name</xsl:attribute>
                            <xsl:choose>
                                <xsl:when test="link != ''">
                                    <xsl:element name="a">
                                        <xsl:attribute name="href">
                                            <xsl:value-of select="link" />
                                        </xsl:attribute>
                                        <xsl:value-of select="name" />
                                    </xsl:element>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="name" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:element>
                        <!-- E-mail -->
                        <xsl:element name="span">
                            <xsl:attribute name="class">
                            email</xsl:attribute>
                            <xsl:if test="email != ''">
                                <xsl:value-of select="email" />
                            </xsl:if>
                        </xsl:element>
                        <!-- Functions -->
                        <xsl:for-each select="function">
                            <xsl:if test="position()!=1">
                                <xsl:text>, </xsl:text>
                            </xsl:if>
                            <xsl:variable name="function">
                                <xsl:value-of select="." />
                            </xsl:variable>
                            <xsl:apply-templates select="/html/set/function[@id=$function]/node()" />
                            <xsl:if test="@country != ''">
                                <xsl:text> </xsl:text>
                                <xsl:variable name="country">
                                    <xsl:value-of select="@country" />
                                </xsl:variable>
                                <xsl:value-of select="/html/set/country[@id=$country]" />
                            </xsl:if>
                            <xsl:if test="@project != ''">
                                <xsl:text> </xsl:text>
                                <xsl:variable name="project">
                                    <xsl:value-of select="@project" />
                                </xsl:variable>
                                <xsl:element name="a">
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="/html/set/project[@id=$project]/link" />
                                    </xsl:attribute>
                                    <xsl:value-of select="/html/set/project[@id=$project]/title" />
                                </xsl:element>
                            </xsl:if>
                            <xsl:if test="@volunteers != ''">
                                <xsl:text> </xsl:text>
                                <xsl:variable name="volunteers">
                                    <xsl:value-of select="@volunteers" />
                                </xsl:variable>
                                <xsl:apply-templates select="/html/set/volunteers[@id=$volunteers]/node()" />
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:element>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    
    
    <xsl:template name="country-list">
			
			<select id="country" name="country">
				
				<xsl:for-each select="/html/set/country">
					<xsl:sort select="." lang="en" />
					
					<option><xsl:value-of select="." /></option>
					
				</xsl:for-each>
				
			</select>
			
    </xsl:template>
    
    <!-- refactored these her from the support form -->
    <xsl:template name="country-list-europe">
        <option value="AL">Albania (Shqipëria)</option>
        <option value="AD">Andorra</option>
        <option value="AT">Austria (Österreich)</option>
        <option value="BY">Belarus (Белару́сь)</option>
        <option value="BE">Belgium (België)</option>
        <option value="BA">Bosnia and Herzegovina (Bosna i Hercegovina)</option>
        <option value="BG">Bulgaria (България)</option>
        <option value="HR">Croatia (Hrvatska)</option>
        <option value="CZ">Czech Republic (Česko)</option>
        <option value="DK">Denmark (Danmark)</option>
        <option value="EE">Estonia (Eesti)</option>
        <option value="FO">Faroe Islands</option>
        <option value="FI">Finland (Suomi)</option>
        <option value="FR">France</option>
        <option value="DE">Germany (Deutschland)</option>
        <option value="GI">Gibraltar</option>
        <option value="GR">Greece (Ελλάς)</option>
        <option value="GL">Greenland</option>
        <option value="HU">Hungary (Magyarország)</option>
        <option value="IS">Iceland (Ísland)</option>
        <option value="IE">Ireland</option>
        <option value="IT">Italy (Italia)</option>
        <option value="LI">Liechtenstein</option>
        <option value="LT">Lithuania (Lietuva)</option>
        <option value="LU">Luxembourg (Lëtzebuerg)</option>
        <option value="MK">Macedonia [FYROM] (Македонија)</option>
        <option value="MT">Malta</option>
        <option value="MD">Moldova</option>
        <option value="MC">Monaco</option>
        <option value="ME">Montenegro (Црна Гора)</option>
        <option value="NL">Netherlands (Nederland)</option>
        <option value="NO">Norway (Norge)</option>
        <option value="PL">Poland (Polska)</option>
        <option value="PT">Portugal</option>
        <option value="RO">Romania (România)</option>
        <option value="RU">Russia (Россия)</option>
        <option value="SM">San Marino</option>
        <option value="RS">Serbia (Србија)</option>
        <option value="SK">Slovakia (Slovensko)</option>
        <option value="SI">Slovenia (Slovenija)</option>
        <option value="ES">Spain (España)</option>
        <option value="SE">Sweden (Sverige)</option>
        <option value="CH">Switzerland (Schweiz)</option>
        <option value="TR">Turkey (Türkiye)</option>
        <option value="UA">Ukraine (Україна)</option>
        <option value="GB">United Kingdom</option>
        <option value="VA">Vatican City (Città del Vaticano)</option>
    </xsl:template>
    <xsl:template name="country-list-other-continents">
        <option value="AF">Afghanistan (‫افغانستان‬‎)</option>
        <option value="AX">Åland Islands</option>
        <option value="DZ">Algeria (‫الجزائر‬‎)</option>
        <option value="AS">American Samoa</option>
        <option value="AO">Angola</option>
        <option value="AI">Anguilla</option>
        <option value="AQ">Antarctica</option>
        <option value="AG">Antigua and Barbuda</option>
        <option value="AR">Argentina</option>
        <option value="AM">Armenia (Հայաստան)</option>
        <option value="AW">Aruba</option>
        <option value="AU">Australia</option>
        <option value="AZ">Azerbaijan (Azərbaycan)</option>
        <option value="BS">Bahamas</option>
        <option value="BH">Bahrain (‫البحرين‬‎)</option>
        <option value="BD">Bangladesh (বাংলাদেশ)</option>
        <option value="BB">Barbados</option>
        <option value="BZ">Belize</option>
        <option value="BJ">Benin (Bénin)</option>
        <option value="BM">Bermuda</option>
        <option value="BT">Bhutan (འབྲུག་ཡུལ)</option>
        <option value="BO">Bolivia</option>
        <option value="BW">Botswana</option>
        <option value="BV">Bouvet Island</option>
        <option value="BR">Brazil (Brasil)</option>
        <option value="IO">British Indian Ocean Territory</option>
        <option value="VG">British Virgin Islands</option>
        <option value="BN">Brunei (Brunei Darussalam)</option>
        <option value="BF">Burkina Faso</option>
        <option value="BI">Burundi (Uburundi)</option>
        <option value="KH">Cambodia (Kampuchea)</option>
        <option value="CM">Cameroon (Cameroun)</option>
        <option value="CA">Canada</option>
        <option value="CV">Cape Verde (Cabo Verde)</option>
        <option value="KY">Cayman Islands</option>
        <option value="CF">Central African Republic (République Centrafricaine)</option>
        <option value="TD">Chad (Tchad)</option>
        <option value="CL">Chile</option>
        <option value="CN">China (中国)</option>
        <option value="CX">Christmas Island</option>
        <option value="CC">Cocos [Keeling] Islands</option>
        <option value="CO">Colombia</option>
        <option value="KM">Comoros (Comores)</option>
        <option value="CD">Congo [DRC]</option>
        <option value="CG">Congo [Republic]</option>
        <option value="CK">Cook Islands</option>
        <option value="CR">Costa Rica</option>
        <option value="CI">Côte d’Ivoire</option>
        <option value="CU">Cuba</option>
        <option value="CY">Cyprus (Κυπρος)</option>
        <option value="DJ">Djibouti</option>
        <option value="DM">Dominica</option>
        <option value="DO">Dominican Republic</option>
        <option value="EC">Ecuador</option>
        <option value="EG">Egypt (‫مصر‬‎)</option>
        <option value="SV">El Salvador</option>
        <option value="GQ">Equatorial Guinea (Guinea Ecuatorial)</option>
        <option value="ER">Eritrea (Ertra)</option>
        <option value="ET">Ethiopia (Ityop&#39;iya)</option>
        <option value="FK">Falkland Islands [Islas Malvinas]</option>
        <option value="FJ">Fiji</option>
        <option value="GF">French Guiana</option>
        <option value="PF">French Polynesia</option>
        <option value="TF">French Southern Territories</option>
        <option value="GA">Gabon</option>
        <option value="GM">Gambia</option>
        <option value="GE">Georgia (საქართველო)</option>
        <option value="GH">Ghana</option>
        <option value="GD">Grenada</option>
        <option value="GP">Guadeloupe</option>
        <option value="GU">Guam</option>
        <option value="GT">Guatemala</option>
        <option value="GG">Guernsey</option>
        <option value="GN">Guinea (Guinée)</option>
        <option value="GW">Guinea-Bissau (Guiné-Bissau)</option>
        <option value="GY">Guyana</option>
        <option value="HT">Haiti (Haïti)</option>
        <option value="HM">Heard Island and McDonald Islands</option>
        <option value="HN">Honduras</option>
        <option value="HK">Hong Kong</option>
        <option value="IN">India</option>
        <option value="ID">Indonesia</option>
        <option value="IR">Iran (‫ایران‬‎)</option>
        <option value="IQ">Iraq (‫العراق‬‎)</option>
        <option value="IM">Isle of Man</option>
        <option value="IL">Israel (‫ישראל‬‎)</option>
        <option value="JM">Jamaica</option>
        <option value="JP">Japan (日本)</option>
        <option value="JE">Jersey</option>
        <option value="JO">Jordan (‫الاردن‬‎)</option>
        <option value="KZ">Kazakhstan (Қазақстан)</option>
        <option value="KE">Kenya</option>
        <option value="KI">Kiribati</option>
        <option value="KW">Kuwait (‫الكويت‬‎)</option>
        <option value="KG">Kyrgyzstan (Кыргызстан)</option>
        <option value="LA">Laos (ນລາວ)</option>
        <option value="LV">Latvia (Latvija)</option>
        <option value="LB">Lebanon (‫لبنان‬‎)</option>
        <option value="LS">Lesotho</option>
        <option value="LR">Liberia</option>
        <option value="LY">Libya (‫ليبيا‬‎)</option>
        <option value="MO">Macau</option>
        <option value="MG">Madagascar (Madagasikara)</option>
        <option value="MW">Malawi</option>
        <option value="MY">Malaysia</option>
        <option value="MV">Maldives (‫ގުޖޭއްރާ ޔާއްރިހޫމްޖ‬‎)</option>
        <option value="ML">Mali</option>
        <option value="MH">Marshall Islands</option>
        <option value="MQ">Martinique</option>
        <option value="MR">Mauritania (‫موريتانيا‬‎)</option>
        <option value="MU">Mauritius</option>
        <option value="YT">Mayotte</option>
        <option value="MX">Mexico (México)</option>
        <option value="FM">Micronesia</option>
        <option value="MN">Mongolia (Монгол Улс)</option>
        <option value="MS">Montserrat</option>
        <option value="MA">Morocco (‫المغرب‬‎)</option>
        <option value="MZ">Mozambique (Moçambique)</option>
        <option value="MM">Myanmar [Burma] (Myanmar (Burma))</option>
        <option value="NA">Namibia</option>
        <option value="NR">Nauru (Naoero)</option>
        <option value="NP">Nepal (नेपाल)</option>
        <option value="AN">Netherlands Antilles</option>
        <option value="NC">New Caledonia</option>
        <option value="NZ">New Zealand</option>
        <option value="NI">Nicaragua</option>
        <option value="NE">Niger</option>
        <option value="NG">Nigeria</option>
        <option value="NU">Niue</option>
        <option value="NF">Norfolk Island</option>
        <option value="MP">Northern Mariana Islands</option>
        <option value="KP">North Korea (조선)</option>
        <option value="OM">Oman (‫عمان‬‎)</option>
        <option value="PK">Pakistan (‫پاکستان‬‎)</option>
        <option value="PW">Palau (Belau)</option>
        <option value="PS">Palestinian Territories</option>
        <option value="PA">Panama (Panamá)</option>
        <option value="PG">Papua New Guinea</option>
        <option value="PY">Paraguay</option>
        <option value="PE">Peru (Perú)</option>
        <option value="PH">Philippines (Pilipinas)</option>
        <option value="PN">Pitcairn Islands</option>
        <option value="PR">Puerto Rico</option>
        <option value="QA">Qatar (‫قطر‬‎)</option>
        <option value="RE">Réunion</option>
        <option value="RW">Rwanda</option>
        <option value="SH">Saint Helena</option>
        <option value="KN">Saint Kitts and Nevis</option>
        <option value="LC">Saint Lucia</option>
        <option value="PM">Saint Pierre and Miquelon</option>
        <option value="VC">Saint Vincent and the Grenadines</option>
        <option value="WS">Samoa</option>
        <option value="ST">São Tomé and Príncipe</option>
        <option value="SA">Saudi Arabia (‫المملكة العربية السعودية‬‎)</option>
        <option value="SN">Senegal (Sénégal)</option>
        <option value="SC">Seychelles</option>
        <option value="SL">Sierra Leone</option>
        <option value="SG">Singapore (Singapura)</option>
        <option value="SB">Solomon Islands</option>
        <option value="SO">Somalia (Soomaaliya)</option>
        <option value="ZA">South Africa</option>
        <option value="GS">South Georgia and the South Sandwich Islands</option>
        <option value="KR">South Korea (한국)</option>
        <option value="LK">Sri Lanka</option>
        <option value="SD">Sudan (‫السودان‬‎)</option>
        <option value="SR">Suriname</option>
        <option value="SJ">Svalbard and Jan Mayen</option>
        <option value="SZ">Swaziland</option>
        <option value="SY">Syria (‫سوريا‬‎)</option>
        <option value="TW">Taiwan (台灣)</option>
        <option value="TJ">Tajikistan (Тоҷикистон)</option>
        <option value="TZ">Tanzania</option>
        <option value="TH">Thailand (ราชอาณาจักรไทย)</option>
        <option value="TL">Timor-Leste</option>
        <option value="TG">Togo</option>
        <option value="TK">Tokelau</option>
        <option value="TO">Tonga</option>
        <option value="TT">Trinidad and Tobago</option>
        <option value="TN">Tunisia (‫تونس‬‎)</option>
        <option value="TM">Turkmenistan (Türkmenistan)</option>
        <option value="TC">Turks and Caicos Islands</option>
        <option value="TV">Tuvalu</option>
        <option value="UM">U.S. Minor Outlying Islands</option>
        <option value="VI">U.S. Virgin Islands</option>
        <option value="UG">Uganda</option>
        <option value="AE">United Arab Emirates (‫الإمارات العربيّة المتّحدة‬‎)</option>
        <option value="US">United States</option>
        <option value="UY">Uruguay</option>
        <option value="UZ">Uzbekistan (O&#39;zbekiston)</option>
        <option value="VU">Vanuatu</option>
        <option value="VE">Venezuela</option>
        <option value="VN">Vietnam (Việt Nam)</option>
        <option value="WF">Wallis and Futuna</option>
        <option value="EH">Western Sahara (‫الصحراء الغربية‬‎)</option>
        <option value="YE">Yemen (‫اليمن‬‎)</option>
        <option value="ZM">Zambia</option>
        <option value="ZW">Zimbabwe</option>    
    </xsl:template>
    
</xsl:stylesheet>
