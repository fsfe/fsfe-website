<?php
if (preg_match("/[a-z0-9]/i", $_SERVER["QUERY_STRING"])) {
    $secret = $_SERVER["QUERY_STRING"];
    echo "<p>Checking code $secret..</p>";
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
//	$query = $db->prepare("SELECT * FROM t1 where secret='$secret' AND confirmed=''");
	$query = $db->prepare("SELECT * FROM t1 where secret='$secret'");
	$query->execute();
}
catch(PDOException $e) {
	print "Database Error: \n";
	print_r($db->errorInfo());
}

echo "alive 1..";

while ($row = $query->fetch(PDO::FETCH_ASSOC)) {
    // true if at least one row to return

    $found = True;

echo "alive 2..";
    
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
    
echo "alive 3..";

    echo "<h1>Hello ".$row['firstname']." ".$row['lastname']."</h1>
    <p>Your address ".$row['email']." was confirmed ".$row['confirmed'].".</p>
    <p>Thank you for your support to the FSFE!</p>";
}

echo "alive 4..";

if ($found == False) {
    echo "No address was confirmed. Please sign up again.";
}

echo "alive 5..";

// close the database connection
$db = NULL;

?>
