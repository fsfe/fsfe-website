<pre>
Sending reminders to supporters whos e-mail is still unconfirmed...
<?php
/*
ini_set( "display_errors","1" );
ERROR_REPORTING( E_ALL) ;
*/

$timestamp = date('Y-m-d H:i:s');

try {
    //open the database
	$db = new PDO( 'sqlite:../../../db/support.sqlite' ); 
}
catch(PDOException $e) {
	print 'Error while connecting to Database: '.$e->getMessage();
}

$query = $db->query("alter table t1 add column reminder1 DATETIME");
$query = $db->query("alter table t1 add column reminder2 DATETIME");
$query = $db->query("alter table t1 add column reminder3 DATETIME");


// get all unconfirmed rows
try {
	$query = $db->prepare("SELECT * FROM t1 where confirmed='' 
	    AND time >= '".date('Y-m-d', time()-60*60*24*2)."'"); // restrict to rows younger than last two days
	$query->execute();
}
catch(PDOException $e) {
    print "Database Error: \n";
    print_r($db->errorInfo());
}

while ($row = $query->fetch(PDO::FETCH_ASSOC)) {
    echo "
    ".print_r($row); // debug info
    
    if ($row['reminder1'] == '') {
        send_reminder("1", $row);
    } elseif ($row['reminder2'] == '') {
        send_reminder("2", $row);
    } elseif ($row['reminder3'] == '') {
        send_reminder("3", $row);
    }
}


// close the database connection
$db = NULL;


function send_reminder($reminder_number, $row) {
    GLOBAL $db, $timestamp;

    if (file_exists('template-email-confirm.'. $row['lang'] .'.inc')) {
        require('template-email-confirm.'. $row['lang'] .'.inc');
    } else {    
        require('template-email-confirm.en.inc');
    }
    
    $to      = $row['email']; 
    $headers = 'From: "FSFE" <office@fsfe.org>' . "\r\n";
    mail($to, $subject, $message, $headers);

    echo "Sent reminder number ".$reminder_number." to ".$row['email']."\n";
    
    try {
        $query = $db->prepare("UPDATE t1 SET
            reminder".$reminder_number." = '". $timestamp ."'
            where secret='". $row['secret'] ."'");
        $query->execute();
    }
    catch(PDOException $e) {
        print "Database Error: \n";
        print_r($db->errorInfo());
        return false;
    }
    
    return true;
}

?>
</pre>
