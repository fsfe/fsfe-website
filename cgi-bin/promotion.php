<?php

function eval_xml_template($template, $data) {
  $dir = dirname(__FILE__) . '/../templates';
  $result = file_get_contents("$dir/$template");
  foreach ($data as $key => $value)
    $result = preg_replace("/<tpl name=\"$key\"><\/tpl>/", $value, $result);
  $result = preg_replace("/<tpl name=\"[^\"]*\"><\/tpl>/", '', $result);
  return $result;
}

function gen_alnum($digits){
  $alphabet = '0123456789abcdefghijklmnopqrstuvwxyz';
  $ret = '';
  for ($digits; $digits > 0; $digits--) {
    $ret .= substr($alphabet, rand(0,35), 1);
  }
  return $ret;
}

function relay_donation($orderID) {
  $name = $_POST['name'];
  $email = $_POST['email'];
  $amount100 = $_POST['donate'] * 100;
  $language = $_POST['language'];
  $lang = substr($language, 0, 2);

  $PSPID = "40F00871";
  $TP = "https://fsfe.org/donate/tmpl-concardis.$lang.html";
  $acceptURL = "https://fsfe.org/donate/thankyou.$lang.html";
  $cancelURL = "https://fsfe.org/donate/cancel.$lang.html";

  $salt = "Only4TestingPurposes";
  $shasum = strtoupper(sha1(
        "ACCEPTURL=$acceptURL$salt".
        "AMOUNT=$amount100$salt".
        "CANCELURL=$cancelURL$salt".
        //"CN=$name$salt".
        //"COM=Donation$salt".
        "CURRENCY=EUR$salt".
        "EMAIL=$email$salt".
        "LANGUAGE=$language$salt".
        "ORDERID=$orderID$salt".
        "PMLISTTYPE=2$salt".
        "PSPID=$PSPID$salt".
        "TP=$TP$salt"
        ));

  echo eval_xml_template('concardis_relay.en.html', array(
    'PSPID'      => '<input type="hidden" name="PSPID"      value="'.$PSPID.'">',
    'orderID'    => '<input type="hidden" name="orderID"    value="'.$orderID.'">',
    'amount'     => '<input type="hidden" name="amount"     value="'.$amount100.'">',
    //'currency'   => '<input type="hidden" name="currency"   value="EUR">',
    'language'   => '<input type="hidden" name="language"   value="'.$language.'">',
    //'CN'         => '<input type="hidden" name="CN"         value="'.$name.'">',
    'EMAIL'      => '<input type="hidden" name="EMAIL"      value="'.$email.'">',
    'TP'         => '<input type="hidden" name="TP"         value="'.$TP.'">',
    //'PMListType' => '<input type="hidden" name="PMListType" value="2">',
    'accepturl'  => '<input type="hidden" name="accepturl"  value="'.$acceptURL.'">',
    'cancelurl'  => '<input type="hidden" name="cancelurl"  value="'.$cancelURL.'">',
    'SHASign'    => '<input type="hidden" name="SHASign"    value="'.$shasum.'">'
  ));
}

function send_mail ( $to, $from, $subject, $message, $bcc = NULL, $att = NULL, $att_type = NULL, $att_name = NULL ) {
  $headers = "From: $from\r\n";
  if ( isset( $bcc )) { $headers .= "Bcc: $bcc" . "\r\n"; }
  
  $message = nl2br( $message );
  
  if ( $att ) {
    $eol = PHP_EOL;
    $separator = md5( time());
    $att_f = chunk_split( base64_encode( $att ));
    
    $headers .= "MIME-Version: 1.0".$eol; 
    $headers .= "Content-Type: multipart/mixed; boundary=\"".$separator."\"".$eol.$eol; 
    $headers .= "Content-Transfer-Encoding: 7bit".$eol;
    $headers .= "This is a MIME encoded message.".$eol.$eol;
     
    // message
    $headers .= "--".$separator.$eol;
    $headers .= "Content-Type: text/plain; charset=\"UTF-8\"".$eol;
    $headers .= "Content-Transfer-Encoding: 8bit".$eol.$eol;
    $headers .= $message.$eol.$eol;
     
    // attachment
    $headers .= "--".$separator.$eol;
    
    $headers .= "Content-Type: $att_type; name=\"$att_name\"".$eol; 
    $headers .= "Content-Transfer-Encoding: base64".$eol;
    $headers .= "Content-Disposition: attachment".$eol.$eol;
    $headers .= $att_f.$eol.$eol;
    $headers .= "--".$separator."--";
  } else {
    $headers .= "Content-Type: text/plain; charset=UTF-8\r\n";
  }
  
  return mail( $to, $subject, $message, $headers );
}

$lang = $_POST['language'];

# Sanity checks (*very* sloppy input validation)
if (empty($_POST['lastname'])  ||
    empty($_POST['email'])     ||
    empty($_POST['street'])    ||
    empty($_POST['city'])      ||
    empty($_POST['country'])   ||
    empty($_POST['specifics']) ||
   !empty($_POST['url']) ) {

  header("Location: http://fsfe.org/order/orderpromo-error.$lang.html");
  exit();
}

$reference = "order.".date("%Y-%m-%d").".".(date("%U") % 100000);
$subject = "[promo order] $reference {$_POST['firstname']} {$_POST['lastname']}";
$msg = "Hey, someone ordered promotional material:\n".
       "First Name: {$_POST['firstname']}\n".
       "Last Name:  {$_POST['lastname']}\n".
       "EMail:      {$_POST['email']}\n".
       "\n".
       "Address:\n".
       "{$_POST['street']}\n".
       "{$_POST['city']}\n".
       "{$_POST['country']}\n".
       "\n".
       "Specifics of the Order:\n".
       "{$_POST['specifics']}\n".
       "\n".
       "The material is going to be used for:\n".
       "{$_POST['usage']}\n".
       "\n".
       "Comments:\n".
       "{$_POST['comment']}\n".
       "\n".
       "Preferred language was: {$_POST['language']}\n";

if (isset($_POST['donate']) && ($_POST['donate'] > 0)) {
  $_POST['donationID'] = "DAFSPCK".gen_alnum(5);
  $msg .= "\n\nThe orderer choose to make a Donation of {$_POST['donate']} Euro.\n".
          "Please do not assume that this donation has been made until you receive\n".
          "confirmation from Concardis for the order: {$_POST['donationID']}";
}

$test = send_mail ( "assist@fsfe.org", $_POST['email'], $subject, $msg );

if (isset($_POST['donate']) && ($_POST['donate'] > 0)) {
  relay_donation($_POST['donationID']);
} else {
  header("Location: http://fsfe.org/order/orderpromo-thanks.$lang.html");
}

?>
