<table border="1" style="text-align: left;">
<tr><th>Country code</th><th>Supporters</th><th>Latest at</th></tr>

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

try {
	// check data
	$query = $db->prepare("SELECT *, COUNT(*) AS supporters FROM t1 GROUP BY country_code ORDER BY supporters DESC");
	$query->execute();
}
catch(PDOException $e) {
	print "Database Error: \n";
	print_r($db->errorInfo());
}

$total = 0;

while ($row = $query->fetch(PDO::FETCH_ASSOC)) {
    // true if at least one row to return

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
    $total += $row["supporters"];
    echo '<tr><td>'.$row["country_code"] .'</td><td>'. $row["supporters"] .'</td><td>'. $row["time"] .'</td></tr>';
    
}

?>
</table>

<p><strong>Supporters in total: <?php echo $total; ?></strong></p>

<p>Last 10 joined at:
<ul>
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

    echo '<li>'. $row["time"] .'</li>';
}
?>
</ul>
</p>

<?php
// close the database connection
$db = NULL;
?>

