<?php

//TODO: change in production
//ini_set( "display_errors","1" );
//ERROR_REPORTING( E_ALL) ;

 

$params = array('time', 'firstname', 'lastname', 'email', 'country_code', 'secret');

// Save time in "YYYY-MM-DD HH:MM:SS"
$_POST['time'] = date('Y-m-d H:i:s');
$_POST['secret'] = md5("salt:ksflei54sif76u" . date('Y-m-d H:i:s') . $_POST['email']);
// salt guarantees uniquness for this database
// timestamp guarantees uniquess for each entry, even if e-mail is the same

try {
    //open the database
	$db = new PDO( 'sqlite:../../../db/support.sqlite' ); 
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
		$query->bindParam(":$param", htmlspecialchars(substr($_POST[$param],0,60)));
	$query->execute();
}
catch(PDOException $e) {
	print "Database Error: \n";
	print_r($db->errorInfo());
}

// close the database connection
$db = NULL;



if ( isset($e) && $e ) {
    echo '<p>Sorry, there was an error. Please notify webmaster@fsfe.org</p>
          <p><a href="javascript: history.go(-1)">Back to the support page</a></p>';
}
else {
    echo '<p>Thank you for showing your support to the FSFE!</p>
          <p><a href="/">Go to the FSFE main page</a></p>';

    $message = '
    Thank you for showing your support to the FSFE!

    Please confirm you e-mail address by opening the page
    http://fsfe.org/support/confirm?'. $_POST['secret'] .'

    Thank you!
    ';    
              
    $to      = $_POST['email']; 
    // TODO: is this safe, should we ereg() input first to check correct form?
    $subject = 'Confirm sign up as supporter';
    $headers = 'From: no-reply@fsfe.org' . "\r\n";
    mail($to, $subject, $message, $headers);
}

?>
