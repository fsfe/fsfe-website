<?php
/*
Copyright (C) 2012 Otto Kekäläinen <otto@fsfe.org> for Free Software Foundation Europe

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the 
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

header("Content-Type: text/plain")
?>
Sending reminders to supporters who's e-mail is still unconfirmed:
<?
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

// get all unconfirmed rows
try {
	$query = $db->prepare("SELECT * FROM t1 WHERE confirmed is NULL 
	    AND time > '".date('Y-m-d', time()-60*60*24*30)." 00:00:00'"); // restrict to rows younger than a month
	$query->execute();
}
catch(PDOException $e) {
    print "Database Error: \n";
    print_r($db->errorInfo());
}


while ($row = $query->fetch(PDO::FETCH_ASSOC)) {
    echo "\n".$row['email'].
    " signed up ".$row['time'].
    ", confirmed: ".$row['confirmed']."\n".
    "    reminder 1: ".$row['reminder1'].
    " 2: ".$row['reminder2'].
    " 3: ".$row['reminder3']."\n";
    
    $two_days_ago = date('Y-m-d', time()-60*60*24*2)." 00:00:00";
    
    // send only one reminder
    // don't send reminders more frequent than every third day
    if ($row['reminder1'] == '' && $row['time'] < $two_days_ago) {
        send_reminder("1", $row);
    } elseif ($row['reminder2'] == '' && $row['reminder1'] != '' && $row['reminder1'] < $two_days_ago) {
        send_reminder("2", $row);
    } elseif ($row['reminder3'] == '' && $row['reminder2'] != '' && $row['reminder2'] < $two_days_ago) {
        send_reminder("3", $row);
    } // else do nothing
}


// close the database connection
$db = NULL;


function send_reminder($reminder_number, $row) {
    GLOBAL $db, $timestamp;
    $secret = $row['secret'];

    // don't send reminders to yahoo.com addresses
    if (preg_match("/yahoo.com/i", $row['email'])) {
        echo "  => Don't send reminder to Yahoo.com address.";
        return false;
    }    

    if (file_exists('template-email-confirm.'. $row['lang'] .'.inc')) {
        require('template-email-confirm.'. $row['lang'] .'.inc');
    } else {    
        require('template-email-confirm.en.inc');
    }
    
    $to      = $row['email']; 
    $headers = 'From: "FSFE" <office@fsfe.org>' . "\r\n";
    mail($to, $subject, $message, $headers);

    echo "    => Sent reminder number ".$reminder_number." to ".$row['email']."\n";
    
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
