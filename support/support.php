<?php

//TODO: save value of ref_url and ref_id in support.xhtml, then save into database here
//ini_set( "display_errors","1" );
//ERROR_REPORTING( E_ALL) ;

if ($_POST['email'] == '' || $_POST['country_code'] == '') {
    die("Post data missing. This page should only be accessed via the sign up form.");
}

$params = array('time', 'firstname', 'lastname', 'email', 'country_code', 'secret', 'ref_url', 'ref_id');

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


// check if e-mail address already in database
try {
	// check data
	$query = $db->prepare("SELECT * FROM t1 where email='". sqlite_escape_string($_POST['email']) ."'");
	$query->execute();
}
catch(PDOException $e) {
    print "Database Error: \n";
    print_r($db->errorInfo());
}

if ($row = $query->fetch(PDO::FETCH_ASSOC)) {
    // e-mail already found, don't add a new row

    if ($row['firstname'] == '' || $row['lastname'] == ''){
        // if e-mail found but name missing, update row
	    $query = $db->prepare("UPDATE t1 SET
	        firstname = '". sqlite_escape_string($_POST['firstname']) ."',
	        lasname = '". sqlite_escape_string($_POST['lastname']) ."'
	        where email='". sqlite_escape_string($_POST['email']) ."'");
	    $query->execute();
    }
    
    $email_found = true; // track so that e-mail can be customized

} else {

    // if e-mail not found, add new row
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

}

// close the database connection
$db = NULL;



if ( isset($e) && $e ) {
    echo '<p>Sorry, there was an error. Please notify <a ref="mailto:webmaster@fsfe.org">webmaster@fsfe.org</a></p>
          <p><a href="javascript: history.go(-1)">Back to the support page</a></p>';
}
else {
    echo '<p>Thank you for showing your support to the FSFE!</p>
          <p>A confirmation message has been sent to your e-mail '. $_POST['email'] .'</p>
          <p><a href="http://fsfe.org/">Go to the FSFE main page</a></p>
          
          <script type="text/javascript">
	var pkBaseURL = (("https:" == document.location.protocol) ? "https://piwik.fsfe.org/" : "http://piwik.fsfe.org/");
	document.write(unescape("%3Cscript src=\'" + pkBaseURL + "piwik.js\' type=\'text/javascript\'%3E%3C/script%3E"));
	</script><script type="text/javascript">
	try {
	var piwikTracker = Piwik.getTracker(pkBaseURL + "piwik.php", 4);
	piwikTracker.trackPageView();
	piwikTracker.enableLinkTracking();
	} catch( err ) {}
	</script><noscript><p><img src="http://piwik.fsfe.org/piwik.php?idsite=4" style="border:0" alt=""></p></noscript>

          ';

    if ($email_found === True){
        // message if e-mail already existed in database
        // Rationale: this requires e-mail account access to see.
        // Don't show "already exists" messages in webpage form, since
        // that could leak database contents information and breach privacy.
        $message = '
        Thank you for showing your support to the FSFE!
        
        However, this e-mail address was already signed up earlier.

        Please see details by opening the page
        http://fsfe.org/support/confirm?'. $_POST['secret'] .'

        Thank you!
        ';
    } else { 
        // default message for new supporters
        $message = '
        Thank you for showing your support to the FSFE!

        Please confirm your e-mail address by opening the page
        http://fsfe.org/support/confirm?'. $_POST['secret'] .'

        Thank you!
        ';
    }    

    $to      = $_POST['email']; 
    // TODO: is this safe, should we ereg() input first to check correct form?
    $subject = 'Confirm sign up as supporter';
    $headers = 'From: office@fsfe.org' . "\r\n";
    mail($to, $subject, $message, $headers);
}

?>
