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
  $email = $_POST['mail'];
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

function send_mail ( $to, $from, $subject, $msg, $bcc = NULL, $att = NULL, $att_type = NULL, $att_name = NULL ) {
  $headers = "From: $from\n";
  if ( isset( $bcc )) { $headers .= "Bcc: $bcc" . "\n"; }
  $headers .= "X-OTRS-Queue: Shipping::Promo Material Orders\n";
  if ( isset( $_POST["donationID"])) {
    $headers .= "X-OTRS-DynamicField-OrderID: " . $_POST["donationID"] . "\n";
    $headers .= "X-OTRS-DynamicField-OrderAmount: " . $_POST["donate"] . "\n";
  }
  $headers .= "X-OTRS-DynamicField-OrderLanguage: " . $_POST["language"] . "\n";
  $headers .= "X-OTRS-DynamicField-OrderState: order\n";

  if ( $att ) {
    $separator = md5( time());
    $att_f = chunk_split( base64_encode( $att ));
    
    $headers .= "MIME-Version: 1.0\n"; 
    $headers .= "Content-Type: multipart/mixed; boundary=\"".$separator."\"\n"; 
    $headers .= "Content-Transfer-Encoding: 7bit\n";
    $headers .= "This is a MIME encoded message.\n";
     
    // message
    $message = "--".$separator."\n";
    $message .= "Content-Type: text/plain; charset=\"UTF-8\"\n";
    $message .= "Content-Transfer-Encoding: 8bit\n\n";
    $message .= $msg."\n\n";
     
    // attachment
    $message .= "--".$separator."\n";
    $message .= "Content-Type: $att_type; name=\"$att_name\"\n"; 
    $message .= "Content-Transfer-Encoding: base64\n";
    $message .= "Content-Disposition: attachment\n";
    $message .= $att_f."\n\n";

    // end of message
    $message .= "--".$separator."--";
  } else {
    $headers .= "Content-Type: text/plain; charset=UTF-8\n";
    $message = $msg;
  }
  
  return mail( $to, $subject, $message, $headers );
}

$lang = $_POST['language'];

# Sanity checks (*very* sloppy input validation)
if (empty($_POST['lastname'])  ||
    empty($_POST['mail'])     ||
    empty($_POST['street'])    ||
    empty($_POST['zip'])       ||
    empty($_POST['city'])      ||
    empty($_POST['country'])   ||
    empty($_POST['specifics']) ||
   !empty($_POST['address']) ) {

  header("Location: http://fsfe.org/contribute/spreadtheword-ordererror.$lang.html");
  exit();
}

# Without this, escapeshellarg() will eat non-ASCII characters.
setlocale(LC_CTYPE, "en_US.UTF-8");

$subject = "Promotion material order";
$msg = "Please send me promotional material:\n".
       "First Name: {$_POST['firstname']}\n".
       "Last Name:  {$_POST['lastname']}\n".
       "EMail:      {$_POST['mail']}\n".
       "\n".
       "Address:\n".
       "{$_POST['firstname']} " . "{$_POST['lastname']}\n";

if (!empty($_POST['org'])) {
  $msg .= "{$_POST['org']}\n";
}
$msg .= "{$_POST['street']}\n".
       "{$_POST['zip']} "."{$_POST['city']}\n".
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

# Generate letter to be sent along with the material
$odtfill = $_SERVER["DOCUMENT_ROOT"] . "/cgi-bin/odtfill";
$template = $_SERVER["DOCUMENT_ROOT"] . "/templates/promotionorder.odt";
$outfile = "/tmp/promotionorder.odt";
$name = $_POST['firstname'] . " " . $_POST['lastname'];
$address = "";
if (!empty($_POST['org'])) {
  $address .= $_POST['org'] . "\\n";
}
$address .= $_POST['street'] . "\\n" .
            $_POST['zip'] . " " . $_POST['city'] . "\\n" .
            $_POST['country'];
$name = escapeshellarg($name);
$address = escapeshellarg($address);
shell_exec("$odtfill $template $outfile Name=$name Address=$address");

$test = send_mail ("contact@fsfe.org", $_POST['firstname'] . " " . $_POST['lastname'] . " <" . $_POST['mail'] . ">", $subject, $msg, NULL, file_get_contents($outfile), "application/vnd.oasis.opendocument.text", "letter.odt");

if (isset($_POST['donate']) && ($_POST['donate'] > 0)) {
  relay_donation($_POST['donationID']);
} else {
  header("Location: http://fsfe.org/contribute/spreadtheword-orderthanks.$lang.html");
}

?>
