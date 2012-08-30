<?php
// report errors
/*
error_reporting(E_ALL);
ini_set('display_errors', 'On');
*/

if (preg_match("/[a-z0-9]/i", $_SERVER["QUERY_STRING"])) {
    // keep old way to be backwards compatible
    $secret = $_SERVER["QUERY_STRING"];
} else {
    die("This page must be called with a parameter");
}

try {
    // open the database
	$db = new PDO( 'sqlite:../../../db/support.sqlite' ); 
}
catch(PDOException $e) {
	print 'Error while connecting to Database: '.$e->getMessage();
}

try {
	// check data
	$query = $db->prepare("SELECT * FROM t1 where secret='". sqlite_escape_string($secret) ."'");
	$query->execute();
}
catch(PDOException $e) {
	print "Database Error: \n";
	print_r($db->errorInfo());
}

$row = $query->fetch(PDO::FETCH_ASSOC);

if ($row['email'] != '') {
    echo json_encode($row);
} else {
    echo "Error: supporter profile not found.";
}

// close the database connection
$db = NULL;

?>
