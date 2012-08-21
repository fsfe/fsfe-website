<?php

ini_set( "display_errors","1" );
ERROR_REPORTING( E_ALL) ;

if ($_POST['email'] == '' || $_POST['country_code'] == '') {
    die("Post data missing. This page should only be accessed via the sign up form.");
}

$params = array('time', 'firstname', 'lastname', 'email', 'country_code', 'secret', 'ref_url', 'ref_id', 'lang');

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

// save as comment in case some day need to add new field
$query = $db->query("alter table t1 add column lang TEXT");


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

$row = $query->fetch(PDO::FETCH_ASSOC);

if ($row['email'] != '') {
    // e-mail already found, don't add a new row

    if ($row['firstname'] == '' || $row['lastname'] == ''){
        // if e-mail found but name missing, update row
        try {
	        $query = $db->prepare("UPDATE t1 SET
	            firstname = '". sqlite_escape_string($_POST['firstname']) ."',
	            lastname = '". sqlite_escape_string($_POST['lastname']) ."'
	            where email='". sqlite_escape_string($_POST['email']) ."'");
	        $query->execute();
        }
        catch(PDOException $e) {
	        print "Database Error: \n";
	        print_r($db->errorInfo());
        }
    }
    
    $secret_from_db = $row['secret'];
    $email_found = true; // track so that e-mail can be customized

} else {

    $email_found = false;
    
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
    require('template-thankyou.en.inc');
    echo '       
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

    if ($email_found == true){
        // message if e-mail already existed in database
        // Rationale: this requires e-mail account access to see.
        // Don't show "already exists" messages in webpage form, since
        // that could leak database contents information and breach privacy.
        require('template-email-exists.en.inc');
    } else { 
        // default message for new supporters
        require('template-email-confirm.en.inc');
    }    

    $to      = $_POST['email']; 
    // TODO: is this safe, should we ereg() input first to check correct form?
    $subject = 'Confirm sign up as supporter';
    $headers = 'From: "FSFE Support" <office@fsfe.org>' . "\r\n";
    mail($to, $subject, $message, $headers);
}

?>
