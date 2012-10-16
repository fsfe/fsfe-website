<?php
/*
ini_set( "display_errors","1" );
ERROR_REPORTING( E_ALL) ;
*/

// allow XMLHttpRequest from any domain
header("Access-Control-Allow-Origin: *");
header('Content-Type: text/plain; charset="utf-8"');

if ($_POST['email'] == '' || $_POST['country_code'] == '') {
    die("Required post data missing (e-mail and country). This page should only be accessed via the sign up form.");
    /* If JavaScript is enabled in the form, this should never happen. 
       If JS is not enabled, the user can press back, fill the missing fields and repost.
       If JS not enabled, the row will be missing language and referrer data, but we can live with that. */
}

if ($_POST['support_robotfield'] == '') {
    mail("otto@fsfe.org", 'debug supporter form', "robot stopped");
    die("Thanks"); // ..for admitting that you are a robot!
}

$msg = "supporter form debug\n\n SERVER:\n";
foreach ($arr as $key => $value) {
    $msg .= "Key: $key; Value: $value<br />\n";
}
$msg .= "\n\n POST:\n";
foreach ($arr as $key => $value) {
    $msg .= "Key: $key; Value: $value<br />\n";
}

mail("otto@fsfe.org", $msg);
    
// TODO: add eregi testing of values that e-mail field is email

$lang = $_POST['lang'];

$params = array('time', 'firstname', 'lastname', 'email', 'country_code', 'secret', 'ref_url', 'ref_id', 'lang');

// save time in "YYYY-MM-DD HH:MM:SS"
$_POST['time'] = date('Y-m-d H:i:s');
$_POST['secret'] = md5("salt:ksflei54sif76u" . date('Y-m-d H:i:s') . $_POST['email']);
$secret = $_POST['secret'];
// salt guarantees uniquness for this database
// timestamp guarantees uniquess for each entry, even if e-mail is the same

try {
    // open the database
	$db = new PDO( 'sqlite:../../../db/support.sqlite' ); 
}
catch(PDOException $e) {
	print 'Error while connecting to Database: '.$e->getMessage();
}

// save as comment in case some day need to add new field
//$query = $db->query("alter table t1 add column lang TEXT");


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

if ($row['email']) {
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
    echo '<p>Sorry, there was an error. Please notify <a ref="mailto:webmaster@fsfe.org">webmaster@fsfe.org</a></p>';
}
else {
    if (file_exists('template-thankyou.'. $lang .'.inc')) {
        require('template-thankyou.'. $lang .'.inc');
    } else {    
        require('template-thankyou.en.inc');
    }
    // removed Piwik script from here, instead trigger manual goal in submission JS code
    
    if ($email_found == true){
        // message if e-mail already existed in database
        // Rationale: this requires e-mail account access to see.
        // Don't show "already exists" messages in webpage form, since
        // that could leak database contents information and breach privacy.
        if (file_exists('template-email-exists.'. $lang .'.inc')) {
            require('template-email-exists.'. $lang .'.inc');
        } else {    
            require('template-email-exists.en.inc');
        }
    } else { 
        // default message for new supporters
        if (file_exists('template-email-confirm.'. $lang .'.inc')) {
            require('template-email-confirm.'. $lang .'.inc');
        } else {    
            require('template-email-confirm.en.inc');
        }
    }

    $to      = $_POST['email']; 
    // TODO: is this safe, should we ereg() input first to check correct form?
    $headers = 'Content-Type: text/plain; charset="utf-8"' . "\r\n";
    $headers .= 'MIME-Version: 1.0' . "\r\n";
    $headers .= 'Content-Transfer-Encoding: 8bit' . "\r\n";
    $headers .= 'From: "FSFE" <office@fsfe.org>' . "\r\n";
    mail($to, '=?UTF-8?B?'.base64_encode($subject).'?=', $message, $headers);
}

?>
