<?php

//TODO: change in production
ini_set( "display_errors","1" );
ERROR_REPORTING( E_ALL) ;

 

$params = array('time', 'firstname', 'lastname', 'email', 'country_code');

// Save time in "YYYY-MM-DD HH:MM:SS"
$_POST['time'] = date('Y-m-d H:i:s');

try {
        //open the database
	$db = new PDO( 'sqlite:../../db/support.sqlite' ); 
}
catch(PDOException $e) {
	print 'Error while connecting to Database: '.$e->getMessage();
}

try {
	// insert data
	$query = $db->prepare("INSERT INTO t1
		( " . implode(', ', $params) . " )
		VALUES ( :" . implode(', :', $params) . " )");
	foreach ( $params as $param )
		$query->bindParam(":$param", $_POST[$param]);
	$query->execute();
}
catch(PDOException $e) {
	print "Database Error: \n";
	print_r($db->errorInfo());
}

// close the database connection
$db = NULL;



//TODO: replace with standard FSFE website way of displaying feedback
if ( isset($e) && $e ) {
    //TODO: fix link to support page
    echo '<p>Error!</p>
          <p><a href="support.html">Back to the support page</a></p>';
}
else {
    //TODO: fix link to support page
    echo '<p>Thank you!</p>
          <p><a href="support.html">Back to the support page</a></p>';
}

?>
