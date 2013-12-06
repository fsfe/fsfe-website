<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dt="http://xsltsl.org/date-time"
                xmlns:weekdays="."
                xmlns:months="."
                xmlns:str='http://xsltsl.org/string'
                exclude-result-prefixes="dt weekdays months">
  <xsl:import href="string.xsl" />
  
  <xsl:output method="xml" encoding="utf-8" indent="yes" />
  
  <xsl:template name="donate-link">
    
    <!--<xsl:element name="a">
      <xsl:attribute name="href" > -->
    
  </xsl:template>
  
  <xsl:template name="subscribe-nl">
    <form id="formnl" name="formnl" method="post" action="http://mail.fsfeurope.org/mailman/subscribe/newsletter-en">
      <p>
        <select id="language" name="language" onchange="var form = document.getElementById('formnl'); var sel=document.getElementById('language'); form.action='http://mail.fsfeurope.org/mailman/subscribe/newsletter-'+sel.options[sel.options.selectedIndex].value">
          <option value="en" selected="selected">English</option>
          <option value="el">Ελληνικά</option>	
          <option value="es">Español</option>
          <option value="de">Deutsch</option>
          <option value="fr">Français</option>
          <option value="it">Italiano</option>
          <option value="nl">Nederlands</option>
          <option value="pt">Português</option>
          <option value="ro">Română</option>
          <option value="ru">Русский</option>
          <option value="sv">Svenska</option>
          <option value="sq">Shqip</option>
        </select>
        
        <input id="email" name="email" type="email" placeholder="email address" />
        
        <xsl:call-template name="subscribe-button" />
        
      </p>
    </form>
  </xsl:template>
  
  <!--generate subscribe button in correct language-->
  <xsl:template name="subscribe-button">
    
    <xsl:variable name="submit">
      <xsl:call-template name="gettext">
        <xsl:with-param name="id" select="'subscribe'" />
      </xsl:call-template>
    </xsl:variable>
    
    <xsl:element name="input">
      <xsl:attribute name="id">submit</xsl:attribute>
      <xsl:attribute name="type">submit</xsl:attribute>
      <xsl:attribute name="value">
        <xsl:choose>
          <xsl:when test="$submit != ''">
            <xsl:value-of select="$submit" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>Submit</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>

  <!-- auto generate ID for headings if doesn't already exist -->
  <xsl:template name="generate-id">
    <xsl:copy>
      <xsl:call-template name="generate-id-attribute" />
      
      <xsl:if test="@class">
          <xsl:attribute name="class">
            <xsl:value-of select="@class" />
          </xsl:attribute>      
      </xsl:if>
        
      <xsl:apply-templates select="node()"/>
  
    </xsl:copy>
  </xsl:template>
  
  
  <xsl:template name="generate-id-attribute">
    <xsl:param name="title" select="''" />
    
    <xsl:variable name="title2">
      <xsl:choose>
        <xsl:when test="normalize-space($title)=''">
          <xsl:apply-templates select="node()" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$title" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:choose>
      <xsl:when test="not(@id) or normalize-space($title)!=''">
        <!-- replace spaces with dashes -->
        <xsl:variable name="punctuation">.,:;!?&#160;&quot;'()[]&lt;&gt;>{}</xsl:variable>
        <xsl:variable name="formattedTitle1" select="translate(normalize-space(translate($title2,$punctuation,' ')),' ','-')"/>
        
        <xsl:variable   name="accents">áàâäãéèêëíìîïóòôöõúùûüçğ</xsl:variable>
        <xsl:variable name="noaccents">aaaaaeeeeiiiiooooouuuucg</xsl:variable>
        
        <xsl:variable name="formattedTitle2">
          <xsl:call-template name="str:to-lower">
            <xsl:with-param name="text" select="$formattedTitle1" />
          </xsl:call-template>
        </xsl:variable>
        
        <xsl:attribute name="id">
          <xsl:value-of select="concat('id-',translate($formattedTitle2,$accents,$noaccents))" />
        </xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="id">
          <xsl:value-of select="@id" />
        </xsl:attribute>	
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  <xsl:template name="support-portal-javascript">
    <script type="text/javascript">
    /* <![CDATA[ */
    function map_json_to_html(data) {
        for (x in data) {
            $(x).html(data[x]);
        }
    }
    $(document).ready(function() {
        var secret = window.location.search.slice(1);
        if (secret.length == 32) {
            $.getJSON('portal-backend?'+secret, function(data) {
                $("#support_portal_loading").hide();
                $("#support_portal").show();
                if (data.error) {
                    $("#support_portal").html(data.error);
                } else {
                    map_json_to_html(data);
                }
            });
        } else {
            $("#support_portal_loading").html("Expected parameter not found, nothing to show here.");
        }
    });
    /* ]]> */
    </script>
  </xsl:template>
  
  <xsl:template name="support-form-javascript">
    <script type="text/javascript" src="/scripts/jquery.validate.min.js"></script>
    <!-- 
        script type="text/javascript" src="/scripts/jquery.validate-lozalization/messages_fi.js"></script 
        *How to inser lang code in above?*
     -->
    <script type="text/javascript">
    /* <![CDATA[ */
    $(document).ready(function() {
        $("input[name=ref_url]").val(document.referrer);
        $("input[name=ref_id]").val(window.location.search.toString().slice(1));
        
	    $("form.support").validate({
		    rules: {
			    email: {email: true, required: true},
			    country_code: {required: true}
		     },
		     /* // didn't work with Firefox! Terrible hack written below
		     submitHandler: function(form, event) {

                // stop form from submitting normally
                event.preventDefault(); // does not seem to work on Firefox
                
                var $submitbutton = $("form.support input[type='submit']");
                $submitbutton.val($submitbutton.attr("data-loading-text"))
                
                // Send the data using post and put the results in a div
                var $form = $("form.support");
                $.post($form.attr("action"), $form.serialize(),
                  function(data) {
                      $("#support_form").fadeOut();
                      $("#introduction").append('<div id="support_form_sent">'+data+'</div>');
                      piwikTracker.trackGoal(2); // logs a conversion for goal 2
                  }
                );

                return false; // prevent submit, not sure if has any effect
             }
             */
	    });
	    
	    // terrible hack to prevent submit in Firefox!
	    var newbutton = '<input type="button" value="' + $("form.support input[type='submit']").val() + '" data-loading-text="' + $("form.support input[type='submit']").attr("data-loading-text") + '"/>';
	    $("form.support input[type='submit']").after(newbutton);
	    $("form.support input[type='submit']").remove();
	    $("form.support input[type='button']").click(function(){
            if ( $("form.support").valid() ) {

                var $submitbutton = $("form.support input[type='button']");
                $submitbutton.val($submitbutton.attr("data-loading-text"))
                
                /* Send the data using post and put the results in a div */
                var $form = $("form.support");
                $.post($form.attr("action"), $form.serialize(),
                  function(data) {
                      $("#support_form").fadeOut();
                      $("#introduction").append('<div id="support_form_sent">'+data+'</div>');
                      piwikTracker.trackGoal(2); // logs a conversion for goal 2
                  }
                );

            }
	    });
    });

    /* ]]> */
    </script>
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
        <option value="CY">Cyprus (Κυπρος)</option>
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
        <option value="XK">Kosovo</option>
        <option value="LV">Latvia (Latvija)</option>
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
