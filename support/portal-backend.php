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
	$query = $db->prepare("SELECT 
	confirmed,
    country_code,
    email,
    firstname,
    lastname,
    lang,
    zip,
    city
	FROM t1 where secret='". sqlite_escape_string($secret) ."'");
	$query->execute();
}
catch(PDOException $e) {
	print "Database Error: \n";
	print_r($db->errorInfo());
}

$row = $query->fetch(PDO::FETCH_ASSOC);

if ($row['email'] != '') {

    // if portal has never been opened before,
    // mark the e-mail address confirmed 
    // as the secret string has only been delivered via e-mail
    if ($row['confirmed'] == ''){
        $timestamp = date('Y-m-d H:i:s');
        $row['confirmed'] = $timestamp;
        try {
	        $query = $db->prepare("UPDATE t1 SET 
	            confirmed='$timestamp'
		        where secret='$secret'");
	        $query->execute();
        }
        catch(PDOException $e) {
	        print "Database Error: \n";
	        print_r($db->errorInfo());
        }
    }
    
    // send JSON off to JS code waiting to recieve it at the portal page
    echo json_encode($row);
    
} else {

    echo '{"error":"There was an error in confirming the e-mail address. Please sign up again. If the problem presists, please send feedback at <a href=\'http://fsfe.org/contact/\'>fsfe.org/contact</a>."}';

}

// close the database connection
$db = NULL;

?>
