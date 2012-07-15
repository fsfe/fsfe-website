<?php
// report errors

error_reporting(E_ALL);
ini_set('display_errors', 'On');

/*
TODO:
- implement nicer stats with http://www.jqplot.com/ (used in Piwik) or http://code.shutterstock.com/rickshaw/ (d3.js based)
- refactor to use standard FSFE header and footer
*/

try {
    // open the database
	$db = new PDO( 'sqlite:../../../db/support.sqlite' ); 
}
catch(PDOException $e) {
	print 'Error while connecting to Database: '.$e->getMessage();
}


function ts_days_ago($days) {
    $days_ago = mktime(0, 0, 0, date("m"), date("d")-$days, date("Y"));
    return date("Y-m-d", $days_ago) . " 00:00:00";
}

function epoc_days_ago($days) {
    return mktime(0, 0, 0, date("m"), date("d")-$days, date("Y"));
}

$series = array();

for ($i = 0; $i < 14; $i++) {

    try {
	    // check data
	    $query = $db->prepare("SELECT *, COUNT(*) AS supporters FROM t1 WHERE time <= Datetime('". ts_days_ago($i) ."') GROUP BY country_code ORDER BY supporters DESC");
	    $query->execute();
    }
    catch(PDOException $e) {
	    print "Database Error: \n";
	    print_r($db->errorInfo());
    }

    if ($i == 0) { $total = 0; }

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

        if ($i == 0) { $total += $row["supporters"]; }
        
    }

}

$series_json = "";

foreach ($series as $k => $v) {

    $series_json .= '
    {
        name: "'. $k .'",
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
    #chart_container {
            position: relative;
            display: inline-block;
            font-family: Arial, Helvetica, sans-serif;
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

    #statusbox {
        width: 10em;
        border: 1px solid #ccc; 
        background: #eee; 
        padding: 1em; 
        font-size: 11pt; 
        font-family: Sans-serif;
        color: #555;
        position: absolute;
        right: 24px;
        top: 24px;
    }

    #statusbox strong {
        font-size: 60pt; 
    }
    </style>

</head>
<body>

<h1>Supporter count status <small><?php date("Y-m-d") ?></small></h1>

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
        width: 550,
        height: 250,
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
	graph: graph
} );

graph.render();

</script>

<br>
f
<br>

<div id="statusbox">

    <h3>Total supporters</h3>
    <p><strong><?php echo $total; ?></strong></p>

    <h3>Last 10 sign ups</h3>
    <p>
    <?php
    try {
	    // check data
	    $query = $db->prepare("SELECT * FROM t1 ORDER BY time DESC LIMIT 0,10");
	    $query->execute();
    }
    catch(PDOException $e) {
	    print "Database Error: \n";
	    print_r($db->errorInfo());
    }

    while ($row = $query->fetch(PDO::FETCH_ASSOC)) {
        // true if at least one row to return

        echo $row["time"] .'<br>';
    }
    ?>
    </p>

</div>




<?php
// close the database connection
$db = NULL;
?>
  </body>
  <timestamp>$Date: 2012-04-22 12:37:59 +0300 (su, 22 huhti 2012) $ $Author: otto $</timestamp>
</html>
<!--
Local Variables: ***
mode: xml ***
End: ***
-->
