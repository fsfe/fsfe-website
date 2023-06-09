<?php

function eval_xml_template($template, $data)
{
  $dir = dirname(__FILE__) . '/../templates';
  $result = file_get_contents("$dir/$template");
  foreach ($data as $key => $value)
    $result = preg_replace("/<tpl name=\"$key\"><\/tpl>/", $value, $result);
  $result = preg_replace("/<tpl name=\"[^\"]*\"><\/tpl>/", '', $result);
  return $result;
}

function gen_alnum($digits)
{
  $alphabet = '0123456789abcdefghijklmnopqrstuvwxyz';
  $ret = '';
  for ($digits; $digits > 0; $digits--) {
    $ret .= substr($alphabet, rand(0, 35), 1);
  }
  return $ret;
}

function relay_donation($orderID)
{
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
    "ACCEPTURL=$acceptURL$salt" .
      "AMOUNT=$amount100$salt" .
      "CANCELURL=$cancelURL$salt" .
      //"CN=$name$salt".
      //"COM=Donation$salt".
      "CURRENCY=EUR$salt" .
      "EMAIL=$email$salt" .
      "LANGUAGE=$language$salt" .
      "ORDERID=$orderID$salt" .
      "PMLISTTYPE=2$salt" .
      "PSPID=$PSPID$salt" .
      "TP=$TP$salt"
  ));

  echo eval_xml_template('concardis_relay.en.html', array(
    'PSPID'      => '<input type="hidden" name="PSPID"      value="' . $PSPID . '">',
    'orderID'    => '<input type="hidden" name="orderID"    value="' . $orderID . '">',
    'amount'     => '<input type="hidden" name="amount"     value="' . $amount100 . '">',
    //'currency'   => '<input type="hidden" name="currency"   value="EUR">',
    'language'   => '<input type="hidden" name="language"   value="' . $language . '">',
    //'CN'         => '<input type="hidden" name="CN"         value="'.$name.'">',
    'EMAIL'      => '<input type="hidden" name="EMAIL"      value="' . $email . '">',
    'TP'         => '<input type="hidden" name="TP"         value="' . $TP . '">',
    //'PMListType' => '<input type="hidden" name="PMListType" value="2">',
    'accepturl'  => '<input type="hidden" name="accepturl"  value="' . $acceptURL . '">',
    'cancelurl'  => '<input type="hidden" name="cancelurl"  value="' . $cancelURL . '">',
    'SHASign'    => '<input type="hidden" name="SHASign"    value="' . $shasum . '">'
  ));
}

/**
 * Calls the "mail-signup" script with the data.
 * 
 * Sends the script into the background to
 * handle the request asynchronously.
 * 
 * @param array $data
 * @see mail-signup.php
 */
function mail_signup(array $data)
{
  $cmd = sprintf(
    'php %s %s > /dev/null &',
    __DIR__ . '/mail-signup.php',
    escapeshellarg(json_encode($data))
  );
  exec($cmd);
}

$lang = $_POST['language'];

# Sanity checks (*very* sloppy input validation)
if (
  empty($_POST['lastname'])    ||
  empty($_POST['mail'])        ||
  empty($_POST['street'])      ||
  empty($_POST['zip'])         ||
  empty($_POST['city'])        ||
  empty($_POST['country'])     ||
  empty($_POST['packagetype']) ||
  !empty($_POST['address'])
) {

  header("Location: https://fsfe.org/contribute/spreadtheword-ordererror.$lang.html");
  exit();
}

# Without this, escapeshellarg() will eat non-ASCII characters.
setlocale(LC_CTYPE, "en_US.UTF-8");

# $_POST["country"] has values like "DE|Germany", so split this string
$countrycode = explode('|', $_POST["country"])[0];
$countryname = explode('|', $_POST["country"])[1];

if ($_POST['packagetype'] == 'default') {
  $subject = "Standard promotion material order";
} else {
  $subject = "Custom promotion material order";
}
$msg_to_staff = "Please send me promotional material:\n" .
  "First Name: {$_POST['firstname']}\n" .
  "Last Name:  {$_POST['lastname']}\n" .
  "EMail:      {$_POST['mail']}\n" .
  "\n" .
  "Address:\n" .
  "{$_POST['firstname']} " . "{$_POST['lastname']}\n";

if (!empty($_POST['org'])) {
  $msg_to_staff .= "{$_POST['org']}\n";
}
$msg_to_staff .= "{$_POST['street']}\n" .
  "{$_POST['zip']} " . "{$_POST['city']}\n" .
  "{$countryname}\n" .
  "\n" .
  "Specifics of the Order:\n";
# Default or custom package?
if ($_POST['packagetype'] == 'default') {
  $msg_to_staff .= "Default package: Something from everything listed here, depending on size, language selection and availability.\n";
} else {
  $msg_to_staff .= "Custom package:\n" .
    "{$_POST['specifics']}\n";
}
$languages = implode(',', $_POST['languages']);
$msg_to_staff .= "\n" .
  "Preferred language(s) (if available):\n" .
  "{$languages}\n" .
  "\n" .
  "The material is going to be used for:\n" .
  "{$_POST['usage']}\n" .
  "\n" .
  "Comments:\n" .
  "{$_POST['comment']}\n";

$msg_to_donor = "";
if (isset($_POST['donate']) && ($_POST['donate'] > 0)) {
  $_POST['donationID'] = "DAFSPCK" . gen_alnum(5);
  $subject .= " " . $_POST['donationID'];
  $msg_to_staff .= "\n\nThe orderer choose to make a Donation of {$_POST['donate']} Euro.\n" .
    "Please do not assume that this donation has been made until you receive\n" .
    "confirmation from Concardis for the order: {$_POST['donationID']}";
  $msg_to_donor = "<p>If you have yet to pay your order, you may now do so by following" . 
    "this link: <a href=https://fsfe.org/order/payonline.$lang/".$_POST['donationID'].">" . 
    "https://fsfe.org/order/payonline.$lang/".$_POST['donationID']."</a></p>" .
    "<p>In case you prefer to pay by bank transfer, please use the following data:</p>" .
    "<p>Recipient: Free Software Foundation Europe e.V.<br>" .
    "Address: Schoenhauser Allee 6/7, 10119 Berlin, Germany<br>" .
    "IBAN: DE47 4306 0967 2059 7908 01<br>" .
    "Bank: GLS Gemeinschaftsbank eG, 44774 Bochum, Germany<br>" .
    "BIC: GENODEM1GLS<br>" .
    "Payment reference: ".$_POST['donationID']."<br>" .
    "Payment amount: ".$_POST['donate']." Euro</p>";
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
  $countryname;
$cmd = sprintf(
  '%s %s %s %s %s %s',
  $odtfill,
  $template,
  $outfile,
  'Name=' . escapeshellarg($name),
  'Address=' . escapeshellarg($address),
  'Name=' . escapeshellarg($name)
);
shell_exec($cmd);

# Make subscriptions to newsletter/community mails
$subcd = isset($_POST['subcd']) ? $_POST['subcd'] : false;
$subnl = isset($_POST['subnl']) ? $_POST['subnl'] : false;
if ($subcd == "y" or $subnl == "y") {
  $signupdata = array(
    'name' => $_POST['firstname'] . " " . $_POST['lastname'],
    'email1' => $_POST['mail'],
    'address' => $_POST['street'],
    'zip' => $_POST['zip'],
    'city' => $_POST['city'],
    'langugage' => $_POST['language'],
    'country' => $countrycode
  );
  if ($subcd == "y") {
    $signupdata['wants_info'] = '1';
  }
  if ($subnl == "y") {
    $signupdata['wants_newsletter_info'] = '1';
  }
  mail_signup($signupdata);
}

$msg_to_customer = <<<EOT
<html>
<body>
  <p>Dear $name,</p>
  <p>
    thank you for your recent request of promotional material from the FSFE!
    We've received your request and will normally be sending this to you
    within a few days. We will let you know once we've packed your order
    and sent it. Please note that we usually send the material without a
    tracking number.
  </p>
  $msg_to_donor
  <p>
    In about two weeks after we send your material, we will contact you to
    make sure it was received properly. We will also contact you later on to
    get some feedback from you about the material and how it's been used. If
    you have any questions in the mean time, please feel free to reply to
    this message.
  </p>
  <p>
    Thanks for helping us spread the word, and we hope you will have fun and
    find the material useful! If you share pictures online of the material
    having arrived or where it's been used, let us know by dropping a link
    to us here or on social networks (@fsfe).
  </p>
  <p>
    Best regards,
  </p>
</body>
</html> 
EOT;

/**
 * Create a new ticket in the FreeScout system
 */
$url = "https://helpdesk.fsfe.org/api/conversations";
$apikey = getenv('FREESCOUT_API_KEY');
$jsondata = [
  "type"      => "email",
  "mailboxId" => 7,         # This is the Merchandise Mailbox
  "subject"   => $subject,
  "customer"  => [
    "email" => $_POST['mail']
  ],
  "threads" => [
    [
      "text"     => $msg_to_staff,
      "type"     => "customer",
      "customer" => [
        "email" => $_POST['mail'],
        "firstName" => $_POST['firstname'],
        "lastName" => $_POST['lastname'],
      ],
      "attachments" => [
        [
          "fileName" => "letter.odt",
          "mimeType" => "application/vnd.oasis.opendocument.text",
          "data"     => base64_encode(file_get_contents($outfile))
        ]
      ]
    ],
    [
      "text"     => $msg_to_customer,
      "type"     => "message",
      "user"     => 6530,
    ]
  ],
  "imported"     => false,
  "status"       => "active",
  "customFields" => [
    [
      "id"    => 4,              # Order ID Custom Field
      "value" => $_POST['donationID'] ?? ""    # Donation ID
    ]
  ]
];
$jsonDataEncoded = json_encode($jsondata);

$curl = curl_init();
curl_setopt_array($curl, [
  CURLOPT_RETURNTRANSFER => 1,
  CURLOPT_URL => $url,
  CURLOPT_POST => 1,
  CURLOPT_CUSTOMREQUEST => "POST",
  CURLOPT_POSTFIELDS => $jsonDataEncoded,
  CURLOPT_HTTPHEADER => [
    "Content-Type: application/json",
    "Content-Length: " . strlen($jsonDataEncoded),
    "X-FreeScout-API-Key: " . $apikey
  ],
  CURLOPT_USERAGENT => 'FSFE promotion.php'
]);
$response = curl_exec($curl);
curl_close($curl);
/**
 * Only process donations starting from 10 euro.
 */
if (isset($_POST['donate']) && ((int) $_POST['donate']) >= 5) {
  relay_donation($_POST['donationID']);
} else {
  // DEBUG: Comment out next line to be able to see errors and printed info
  header("Location: https://fsfe.org/contribute/spreadtheword-orderthanks.$lang.html");
}
