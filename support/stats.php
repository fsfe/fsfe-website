<pre>
<?php
// report errors

error_reporting(E_ALL);
ini_set('display_errors', 'On');

/*
TODO:
- implement nicer stats with http://www.jqplot.com/ (used in Piwik) or http://code.shutterstock.com/rickshaw/ (d3.js based)
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

while ($row = $query->fetch(PDO::FETCH_ASSOC)) {
    // true if at least one row to return

    print_r($row);

}

// close the database connection
$db = NULL;

?>
</pre>
