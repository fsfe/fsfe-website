<?php
/*
Copyright (C) 2012 Otto Kekäläinen <otto@fsfe.org> for Free Software Foundation Europe

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the 
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

// report errors
//error_reporting(E_ALL);
//ini_set('display_errors', 'On');

/*
TODO:
- refactor to use standard FSFE header and footer
- restrict access to FSFE Fellows
- sort countries by sum of last date, not on sum of first date like is done now
*/

try {
    // open the database
	$db = new PDO( 'sqlite:../../../db/support.sqlite' ); 
}
catch(PDOException $e) {
	print 'Error while connecting to Database: '.$e->getMessage();
}



// total supporters ever, including unconfirmed
try {
    $sql = "SELECT *, COUNT(*) AS supporters FROM t1 ";
    
    // enable stats for single referrers
    if (isset($_GET['ref_id'])) {
        $sql .= "WHERE ref_id = '". sqlite_escape_string($_GET['ref_id']) ."' ";
    }
    if (isset($_GET['ref_url'])) {
        $sql .= "WHERE ref_url LIKE '%". sqlite_escape_string($_GET['ref_url']) ."%' ";
    }
    if (isset($_GET['country_code'])) {
        $sql .= "WHERE country_code  = '". sqlite_escape_string($_GET['country_code']) ."' ";
    }    
    $query = $db->prepare($sql);
    $query->execute();
}
catch(PDOException $e) {
    print "Database Error: \n";
    print_r($db->errorInfo());
}

$row = $query->fetch(PDO::FETCH_ASSOC);
$total = $row['supporters'];



function ts_days_ago($days) {
    $days_ago = mktime(0, 0, 0, date("m"), date("d")-$days, date("Y"));
    return date("Y-m-d", $days_ago) . " 23:59:59";
}

function epoc_days_ago($days) {
    return mktime(0, 0, 0, date("m"), date("d")-$days, date("Y"));
}

$series = array();

for ($i = 90; $i >= 0; $i--) {

    try {
	    // check data
	    $sql = "SELECT *, COUNT(*) AS supporters FROM t1 WHERE confirmed != '' AND time <= Datetime('". ts_days_ago($i) ."') ";

        // enable stats for single referrers
	    if (isset($_GET['ref_id'])) {
	        $sql .= "AND ref_id = '". sqlite_escape_string($_GET['ref_id']) ."' ";
	    }
	    if (isset($_GET['ref_url'])) {
	        $sql .= "AND ref_url LIKE '%". sqlite_escape_string($_GET['ref_url']) ."%' ";
	    }
	    if (isset($_GET['country_code'])) {
	        $sql .= "AND country_code  = '". sqlite_escape_string($_GET['country_code']) ."' ";
	    }
	    
	    $sql .= "GROUP BY country_code ORDER BY supporters DESC";
	    //echo $sql;
	    $query = $db->prepare($sql);
	    $query->execute();
    }
    catch(PDOException $e) {
	    print "Database Error: \n";
	    print_r($db->errorInfo());
    }

    if ($i == 0) { $total_confirmed = 0; }
    if ($i == 90) { $total_confirmed_at_beginning = 0; }

    while ($row = $query->fetch(PDO::FETCH_ASSOC)) {
        // true if at least one row to return
        
        if ($row["country_code"] == "") { continue; } // skip to next row if country empty

        $series[$row["country_code"]][] = array(
            "x" => epoc_days_ago($i),
            "y" => $row["supporters"]
        );
        
        /*    print_r($row);
        example: Array
        (
            [id] => 157
            [time] => 2012-07-13 05:27:41
            [firstname] => Krrtrtta
            [lastname] => Toirtrla
            [email] => krifgfga.tofgfgla@luukku.com
            [country_code] => FI
            [secret] => 7c016a4ab30efa2899a0ec76a92fg6b
            [signed] => 
            [confirmed] => 
            [updated] => 
            [supporters] => 116
        )
        */

        if ($i == 0) { $total_confirmed += $row["supporters"]; } // at the end of the time period, equals totals now
        if ($i == 90) { $total_confirmed_at_beginning += $row["supporters"]; }
        
    }

}

$growth = $total_confirmed - $total_confirmed_at_beginning;
$estimate = $total_confirmed + $growth*4;



// country list
$countries = array (
  'AD' => 'Andorra',
  'AE' => 'United Arab Emirates',
  'AF' => 'Afghanistan',
  'AG' => 'Antigua and Barbuda',
  'AI' => 'Anguilla',
  'AL' => 'Albania',
  'AM' => 'Armenia',
  'AN' => 'Netherlands Antilles',
  'AO' => 'Angola',
  'AQ' => 'Antarctica',
  'AR' => 'Argentina',
  'AS' => 'American Samoa',
  'AT' => 'Austria',
  'AU' => 'Australia',
  'AW' => 'Aruba',
  'AX' => 'Åland Islands',
  'AZ' => 'Azerbaijan',
  'BA' => 'Bosnia and Herzegovina',
  'BB' => 'Barbados',
  'BD' => 'Bangladesh',
  'BE' => 'Belgium',
  'BF' => 'Burkina Faso',
  'BG' => 'Bulgaria',
  'BH' => 'Bahrain',
  'BI' => 'Burundi',
  'BJ' => 'Benin',
  'BL' => 'Saint Barthélemy',
  'BM' => 'Bermuda',
  'BN' => 'Brunei',
  'BO' => 'Bolivia',
  'BQ' => 'British Antarctic Territory',
  'BR' => 'Brazil',
  'BS' => 'Bahamas',
  'BT' => 'Bhutan',
  'BV' => 'Bouvet Island',
  'BW' => 'Botswana',
  'BY' => 'Belarus',
  'BZ' => 'Belize',
  'CA' => 'Canada',
  'CC' => 'Cocos [Keeling] Islands',
  'CD' => 'Congo - Kinshasa',
  'CF' => 'Central African Republic',
  'CG' => 'Congo - Brazzaville',
  'CH' => 'Switzerland',
  'CI' => 'Côte d’Ivoire',
  'CK' => 'Cook Islands',
  'CL' => 'Chile',
  'CM' => 'Cameroon',
  'CN' => 'China',
  'CO' => 'Colombia',
  'CR' => 'Costa Rica',
  'CS' => 'Serbia and Montenegro',
  'CT' => 'Canton and Enderbury Islands',
  'CU' => 'Cuba',
  'CV' => 'Cape Verde',
  'CX' => 'Christmas Island',
  'CY' => 'Cyprus',
  'CZ' => 'Czech Republic',
  'DD' => 'East Germany',
  'DE' => 'Germany',
  'DJ' => 'Djibouti',
  'DK' => 'Denmark',
  'DM' => 'Dominica',
  'DO' => 'Dominican Republic',
  'DZ' => 'Algeria',
  'EC' => 'Ecuador',
  'EE' => 'Estonia',
  'EG' => 'Egypt',
  'EH' => 'Western Sahara',
  'ER' => 'Eritrea',
  'ES' => 'Spain',
  'ET' => 'Ethiopia',
  'FI' => 'Finland',
  'FJ' => 'Fiji',
  'FK' => 'Falkland Islands',
  'FM' => 'Micronesia',
  'FO' => 'Faroe Islands',
  'FQ' => 'French Southern and Antarctic Territories',
  'FR' => 'France',
  'FX' => 'Metropolitan France',
  'GA' => 'Gabon',
  'GB' => 'United Kingdom',
  'GD' => 'Grenada',
  'GE' => 'Georgia',
  'GF' => 'French Guiana',
  'GG' => 'Guernsey',
  'GH' => 'Ghana',
  'GI' => 'Gibraltar',
  'GL' => 'Greenland',
  'GM' => 'Gambia',
  'GN' => 'Guinea',
  'GP' => 'Guadeloupe',
  'GQ' => 'Equatorial Guinea',
  'GR' => 'Greece',
  'GS' => 'South Georgia and the South Sandwich Islands',
  'GT' => 'Guatemala',
  'GU' => 'Guam',
  'GW' => 'Guinea-Bissau',
  'GY' => 'Guyana',
  'HK' => 'Hong Kong SAR China',
  'HM' => 'Heard Island and McDonald Islands',
  'HN' => 'Honduras',
  'HR' => 'Croatia',
  'HT' => 'Haiti',
  'HU' => 'Hungary',
  'ID' => 'Indonesia',
  'IE' => 'Ireland',
  'IL' => 'Israel',
  'IM' => 'Isle of Man',
  'IN' => 'India',
  'IO' => 'British Indian Ocean Territory',
  'IQ' => 'Iraq',
  'IR' => 'Iran',
  'IS' => 'Iceland',
  'IT' => 'Italy',
  'JE' => 'Jersey',
  'JM' => 'Jamaica',
  'JO' => 'Jordan',
  'JP' => 'Japan',
  'JT' => 'Johnston Island',
  'KE' => 'Kenya',
  'KG' => 'Kyrgyzstan',
  'KH' => 'Cambodia',
  'KI' => 'Kiribati',
  'KM' => 'Comoros',
  'KN' => 'Saint Kitts and Nevis',
  'KP' => 'North Korea',
  'KR' => 'South Korea',
  'KW' => 'Kuwait',
  'KY' => 'Cayman Islands',
  'KZ' => 'Kazakhstan',
  'LA' => 'Laos',
  'LB' => 'Lebanon',
  'LC' => 'Saint Lucia',
  'LI' => 'Liechtenstein',
  'LK' => 'Sri Lanka',
  'LR' => 'Liberia',
  'LS' => 'Lesotho',
  'LT' => 'Lithuania',
  'LU' => 'Luxembourg',
  'LV' => 'Latvia',
  'LY' => 'Libya',
  'MA' => 'Morocco',
  'MC' => 'Monaco',
  'MD' => 'Moldova',
  'ME' => 'Montenegro',
  'MF' => 'Saint Martin',
  'MG' => 'Madagascar',
  'MH' => 'Marshall Islands',
  'MI' => 'Midway Islands',
  'MK' => 'Macedonia',
  'ML' => 'Mali',
  'MM' => 'Myanmar [Burma]',
  'MN' => 'Mongolia',
  'MO' => 'Macau SAR China',
  'MP' => 'Northern Mariana Islands',
  'MQ' => 'Martinique',
  'MR' => 'Mauritania',
  'MS' => 'Montserrat',
  'MT' => 'Malta',
  'MU' => 'Mauritius',
  'MV' => 'Maldives',
  'MW' => 'Malawi',
  'MX' => 'Mexico',
  'MY' => 'Malaysia',
  'MZ' => 'Mozambique',
  'NA' => 'Namibia',
  'NC' => 'New Caledonia',
  'NE' => 'Niger',
  'NF' => 'Norfolk Island',
  'NG' => 'Nigeria',
  'NI' => 'Nicaragua',
  'NL' => 'Netherlands',
  'NO' => 'Norway',
  'NP' => 'Nepal',
  'NQ' => 'Dronning Maud Land',
  'NR' => 'Nauru',
  'NT' => 'Neutral Zone',
  'NU' => 'Niue',
  'NZ' => 'New Zealand',
  'OM' => 'Oman',
  'PA' => 'Panama',
  'PC' => 'Pacific Islands Trust Territory',
  'PE' => 'Peru',
  'PF' => 'French Polynesia',
  'PG' => 'Papua New Guinea',
  'PH' => 'Philippines',
  'PK' => 'Pakistan',
  'PL' => 'Poland',
  'PM' => 'Saint Pierre and Miquelon',
  'PN' => 'Pitcairn Islands',
  'PR' => 'Puerto Rico',
  'PS' => 'Palestinian Territories',
  'PT' => 'Portugal',
  'PU' => 'U.S. Miscellaneous Pacific Islands',
  'PW' => 'Palau',
  'PY' => 'Paraguay',
  'PZ' => 'Panama Canal Zone',
  'QA' => 'Qatar',
  'RE' => 'Réunion',
  'RO' => 'Romania',
  'RS' => 'Serbia',
  'RU' => 'Russia',
  'RW' => 'Rwanda',
  'SA' => 'Saudi Arabia',
  'SB' => 'Solomon Islands',
  'SC' => 'Seychelles',
  'SD' => 'Sudan',
  'SE' => 'Sweden',
  'SG' => 'Singapore',
  'SH' => 'Saint Helena',
  'SI' => 'Slovenia',
  'SJ' => 'Svalbard and Jan Mayen',
  'SK' => 'Slovakia',
  'SL' => 'Sierra Leone',
  'SM' => 'San Marino',
  'SN' => 'Senegal',
  'SO' => 'Somalia',
  'SR' => 'Suriname',
  'ST' => 'São Tomé and Príncipe',
  'SU' => 'Union of Soviet Socialist Republics',
  'SV' => 'El Salvador',
  'SY' => 'Syria',
  'SZ' => 'Swaziland',
  'TC' => 'Turks and Caicos Islands',
  'TD' => 'Chad',
  'TF' => 'French Southern Territories',
  'TG' => 'Togo',
  'TH' => 'Thailand',
  'TJ' => 'Tajikistan',
  'TK' => 'Tokelau',
  'TL' => 'Timor-Leste',
  'TM' => 'Turkmenistan',
  'TN' => 'Tunisia',
  'TO' => 'Tonga',
  'TR' => 'Turkey',
  'TT' => 'Trinidad and Tobago',
  'TV' => 'Tuvalu',
  'TW' => 'Taiwan',
  'TZ' => 'Tanzania',
  'UA' => 'Ukraine',
  'UG' => 'Uganda',
  'UM' => 'U.S. Minor Outlying Islands',
  'US' => 'United States',
  'UY' => 'Uruguay',
  'UZ' => 'Uzbekistan',
  'VA' => 'Vatican City',
  'VC' => 'Saint Vincent and the Grenadines',
  'VD' => 'North Vietnam',
  'VE' => 'Venezuela',
  'VG' => 'British Virgin Islands',
  'VI' => 'U.S. Virgin Islands',
  'VN' => 'Vietnam',
  'VU' => 'Vanuatu',
  'WF' => 'Wallis and Futuna',
  'WK' => 'Wake Island',
  'WS' => 'Samoa',
  'YD' => 'People\'s Democratic Republic of Yemen',
  'YE' => 'Yemen',
  'YT' => 'Mayotte',
  'ZA' => 'South Africa',
  'ZM' => 'Zambia',
  'ZW' => 'Zimbabwe',
  'ZZ' => 'Unknown or Invalid Region',
  'XK' => 'Kosovo',
);

$series_json = "";

foreach ($series as $k => $v) {

    $series_json .= '
    {
        name: "'. $countries[$k] .'",
        data: [ ';

        foreach ($v as $subk => $subv) {
            $series_json .= '{ x: '. $subv["x"] .', y: '. $subv["y"] .' },';
        }

    $series_json .= ' ],
        color: palette.color()
    },
    ';

}    
?>
<!doctype html public "✰">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title dir="ltr">FSFE Supporter statistics</title>
    <meta name="viewport" content="width=device-width">

    <link type="text/css" rel="stylesheet" href="rickshaw.min.css">
    <script src="d3.min.js"></script>
    <script src="d3.layout.min.js"></script>
    <script src="rickshaw.min.js"></script>

    <style>
    body {
        font-family: Arial, Helvetica, sans-serif;
        color: #555;
        padding: 1em;
    }

    #chart_container {
        position: relative;
        display: inline-block;
        left: 14em;
    }
    #chart {
        display: inline-block;
        margin-left: 40px;
    }
    #y_axis {
        position: absolute;
        top: 0;
        bottom: 0;
        width: 40px;
    }
    #legend {
        display: inline-block;
        vertical-align: top;
        margin: 0 0 0 10px;
    }

    .statusbox {
        width: 12em;
        border: 1px solid #ccc; 
        background: #eee; 
        padding: 1em; 
        font-size: 15px; 
        position: absolute;
        left: 2em;
    }

    .statusbox h3 {
        font-size: 17px;
    }
    .statusbox p {
        margin: 0;
    }
    .statusbox strong {
        font-size: 80px; 
    }

    .statusbox em {
        font-size: 16px; 
        font-weight: bold; 
    }
    
    #lastlog {
        background: #ccc; 
        font-size: 10pt;
    }

    #lastlog th {
        text-align: left;
    }
    
    #lastlog td {
        background: #eee;
        padding: 6px;
    }
    </style>

</head>
<body>

<h1>Supporter count status 
<?php
if (isset($_GET['ref_url'])) { echo " for referrer URLs containing ". htmlspecialchars($_GET['ref_url']); }
if (isset($_GET['ref_id'])) { echo " for referrer fsfe.org/support?". htmlspecialchars($_GET['ref_id']); }
?>
<small><?php date("Y-m-d") ?></small></h1>

<div class="statusbox">
    <h3>Total supporters</h3>
    <p><strong><?php echo $total_confirmed; ?></strong></p>
    <p>with e-mail confirmed.</p>
    <p>Total with unconfirmed included is <em><?php echo $total; ?></em>.</p>
</div>

<div class="statusbox" style="top:26em;">
    <p>Three months ago there where <em><?php echo $total_confirmed_at_beginning; ?></em> supporters, so growth was <em><?php echo $growth; ?></em> supporters. If growth continues at the same pace, we'll have <em><?php echo $estimate; ?></em> supporters in a year from now!</p>
</div>

<div id="chart_container">
    <div id="y_axis"></div>
	<div id="chart"></div>
	<div id="legend"></div>
</div>

<script>
var palette = new Rickshaw.Color.Palette();

var seriesData = [ <?php echo $series_json; ?> ];

Rickshaw.Series.zeroFill(seriesData);

var graph = new Rickshaw.Graph( {
        element: document.querySelector("#chart"),
        width: 700,
        height: 700,
        renderer: 'bar',
        series: seriesData
} );

var x_axis = new Rickshaw.Graph.Axis.Time( { graph: graph } );

var y_axis = new Rickshaw.Graph.Axis.Y( {
        graph: graph,
        orientation: 'left',
        tickFormat: Rickshaw.Fixtures.Number.formatKMBT,
        element: document.getElementById('y_axis'),
} );

var legend = new Rickshaw.Graph.Legend( {
        element: document.querySelector('#legend'),
        graph: graph
} );

var hoverDetail = new Rickshaw.Graph.HoverDetail( {
	graph: graph,
    yFormatter: function(y) { return Math.floor(y) + " supporters" }
} );

/* 
// does not work, result area becomes white!
// assume issue is missing jquery libs and extra css stuff

var shelving = new Rickshaw.Graph.Behavior.Series.Toggle({
    graph: graph,
    legend: legend
});
*/

graph.render();

// reverse list to match legend sorting
seriesData.reverse()

legendlist = document.querySelectorAll('#legend li');

// iterate all and add count in legend
for (i = 0; i < seriesData.length; i++) {
    sum = document.createElement("span");
    sum.innerHTML = ": " + seriesData[i].data.slice(-1)[0].y;
    legendlist[i].appendChild(sum);
}

</script>


<h3>Latest 20 sign ups</h3>
<table id="lastlog">
<tr>
    <th>Date</th>
    <th>Country</th>
    <th>Referrer url</th>
    <th>Referrer id (support?xxxx)</th>
    <th>E-mail confirmed</th>
</tr>
<?php
try {
    $sql = "SELECT * FROM t1 ";

    // enable stats for single referrers
    if (isset($_GET['ref_id'])) {
        $sql .= "WHERE ref_id = '". sqlite_escape_string($_GET['ref_id']) ."' ";
    }
    if (isset($_GET['ref_url'])) {
        $sql .= "WHERE ref_url LIKE '". sqlite_escape_string($_GET['ref_url']) ."%' ";
    }
    if (isset($_GET['country_code'])) {
        $sql .= "WHERE country_code = '". sqlite_escape_string($_GET['country_code']) ."' ";
    }
    $sql .= "ORDER BY time DESC LIMIT 0,20";

    $query = $db->prepare($sql);
    $query->execute();
}
catch(PDOException $e) {
    print "Database Error: \n";
    print_r($db->errorInfo());
}

while ($row = $query->fetch(PDO::FETCH_ASSOC)) {
    echo '<tr>
    <td>'. substr($row["time"], 0, 10) .'</td>
    <td><a href="?country_code='. $row["country_code"] .'">'. $row["country_code"] .'</a></td>
    <td><a href="?ref_url='. $row["ref_url"] .'">'. $row["ref_url"] .'</a></td>
    <td><a href="?ref_id='. $row["ref_id"] .'">'. $row["ref_id"] .'</a></td>
    <td>'. substr($row["confirmed"], 0, 10) .'</td>
    </tr>';
}
?>
</table>




<?php
// close the database connection
$db = NULL;
?>
  <br>
  <timestamp>$Date$ $Author$</timestamp>
  </body>
</html>
<!--
Local Variables: ***
mode: xml ***
End: ***
-->
