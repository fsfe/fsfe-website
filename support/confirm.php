<?php
if (preg_match("/[a-z0-9]/i", $_SERVER["QUERY_STRING"])) {
    $secret = $_SERVER["QUERY_STRING"];
} else {
    die("This page must be called with a parameter");
}

try {
    //open the database
	$db = new PDO( 'sqlite:../../../db/support.sqlite' ); 
}
catch(PDOException $e) {
	print 'Error while connecting to Database: '.$e->getMessage();
}

try {
	// insert data
	$query = $db->prepare("SELECT * FROM t1 where secret='$secret' AND confirmed=''");
	$query->execute();
}
catch(PDOException $e) {
	print "Database Error: \n";
	print_r($db->errorInfo());
}

while ($row = $query->fetch(PDO::FETCH_ASSOC)) {
    // true if at least one row to return

    $found = True;
    
    try {
	    $query = $db->prepare("UPDATE t1 SET 
	        confirmed='". date('Y-m-d H:i:s') ."'
		    where secret='$secret'");
	    $query->execute();
    }
    catch(PDOException $e) {
	    print "Database Error: \n";
	    print_r($db->errorInfo());
    }
    
    echo "<h1>Hello ".$row['firstname']." ".$row['lastname']."</h1>
    <p>Your address ".$row['email']." was confirmed ".$row['confirmed'].".</p>
    <p>Thank you for your support to the FSFE!</p>";
}

if ($found === False) {
    echo "No address was confirmed. Please sign up again.";
}

// close the database connection
$db = NULL;

?>
