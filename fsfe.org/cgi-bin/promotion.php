<?php

function eval_xml_template($template, $data)
{
    $dir = dirname(__FILE__).'/../templates';
    $result = file_get_contents("{$dir}/{$template}");
    foreach ($data as $key => $value) {
        $result = preg_replace("/<tpl name=\"{$key}\"><\\/tpl>/", $value, $result);
    }

    return preg_replace('/<tpl name="[^"]*"><\/tpl>/', '', $result);
}
function eval_template($template, $data)
{
    extract($data);
    $dir = realpath(dirname(__FILE__).'/../templates');
    ob_start();

    include "{$dir}/{$template}";
    $result = ob_get_contents();
    ob_end_clean();

    return $result;
}
function gen_alnum($digits)
{
    $alphabet = '0123456789abcdefghijklmnopqrstuvwxyz';
    $ret = '';
    for ($digits; $digits > 0; --$digits) {
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

    $PSPID = '40F00871';
    $TP = 'payment-without-bank.html';
    $acceptURL = "https://fsfe.org/donate/thankyou.{$lang}.html";
    $cancelURL = "https://fsfe.org/donate/cancel.{$lang}.html";

    $salt = 'Only4TestingPurposes';
    $shasum = strtoupper(sha1(
        "ACCEPTURL={$acceptURL}{$salt}"
        ."AMOUNT={$amount100}{$salt}"
        ."CANCELURL={$cancelURL}{$salt}"
        // "CN=$name$salt".
        // "COM=Donation$salt".
        ."CURRENCY=EUR{$salt}"
        ."EMAIL={$email}{$salt}"
        ."LANGUAGE={$language}{$salt}"
        ."ORDERID={$orderID}{$salt}"
        ."PMLISTTYPE=2{$salt}"
        ."PSPID={$PSPID}{$salt}"
        ."TP={$TP}{$salt}"
    ));

    echo eval_xml_template('concardis_relay.en.html', [
        'PSPID' => '<input type="hidden" name="PSPID"      value="'.$PSPID.'">',
        'orderID' => '<input type="hidden" name="orderID"    value="'.$orderID.'">',
        'amount' => '<input type="hidden" name="amount"     value="'.$amount100.'">',
        // 'currency'   => '<input type="hidden" name="currency"   value="EUR">',
        'language' => '<input type="hidden" name="language"   value="'.$language.'">',
        // 'CN'         => '<input type="hidden" name="CN"         value="'.$name.'">',
        'EMAIL' => '<input type="hidden" name="EMAIL"      value="'.$email.'">',
        'TP' => '<input type="hidden" name="TP"         value="'.$TP.'">',
        // 'PMListType' => '<input type="hidden" name="PMListType" value="2">',
        'accepturl' => '<input type="hidden" name="accepturl"  value="'.$acceptURL.'">',
        'cancelurl' => '<input type="hidden" name="cancelurl"  value="'.$cancelURL.'">',
        'SHASign' => '<input type="hidden" name="SHASign"    value="'.$shasum.'">',
    ]);
}

/**
 * Calls the "mail-signup" script with the data.
 *
 * Sends the script into the background to
 * handle the request asynchronously.
 *
 * @see mail-signup.php
 */
function mail_signup(array $data)
{
    $cmd = sprintf(
        'php %s %s > /dev/null &',
        __DIR__.'/mail-signup.php',
        escapeshellarg(json_encode($data))
    );
    exec($cmd);
}

$lang = $_POST['language'];

// Sanity checks (*very* sloppy input validation)
if (
    empty($_POST['lastname'])
    || empty($_POST['mail'])
    || stripos($_POST['mail'], 'example')
    || stripos($_POST['mail'], '@@')
    || empty($_POST['street'])
    || empty($_POST['zip'])
    || empty($_POST['city'])
    || empty($_POST['country'])
    || empty($_POST['packagetype'])
    || !empty($_POST['address'])
) {
    header("Location: https://fsfe.org/contribute/spreadtheword-ordererror.{$lang}.html");

    exit;
}

// Without this, escapeshellarg() will eat non-ASCII characters.
setlocale(LC_CTYPE, 'en_US.UTF-8');

// $_POST["country"] has values like "DE|Germany", so split this string
$countrycode = explode('|', $_POST['country'])[0];
$countryname = explode('|', $_POST['country'])[1];

$subject = 'Promotion material order';
$msg_to_staff = "Please send me promotional material:\n"
  ."First Name: {$_POST['firstname']}\n"
  ."Last Name:  {$_POST['lastname']}\n"
  ."EMail:      {$_POST['mail']}\n"
  ."\n"
  ."Address:\n"
  ."{$_POST['firstname']} {$_POST['lastname']}\n";

if (!empty($_POST['org'])) {
    $msg_to_staff .= "{$_POST['org']}\n";
}
$msg_to_staff .= "{$_POST['street']}\n"
  ."{$_POST['zip']} {$_POST['city']}\n"
  ."{$countryname}\n"
  ."\n"
  ."Specifics of the Order:\n";
// Default or custom package?
if ('basic_sticker' == $_POST['packagetype']) {
    $msg_to_staff .= "My Laptop: Basic Set of Stickers.\n";
} elseif ('basicpostcard' == $_POST['packagetype']) {
    $msg_to_staff .= "Postcards and Stickers.\n";
} elseif ('basicsticker' == $_POST['packagetype']) {
    $msg_to_staff .= "Small package with stickers.\n";
} elseif ('morestickers' == $_POST['packagetype']) {
    $msg_to_staff .= "Stickers for me and my friend: Twice the amount of our most popular stickers.\n";
} elseif ('standard' == $_POST['packagetype']) {
    $msg_to_staff .= "Standard Package.\n";
} else {
    $msg_to_staff .= "Custom package:\n"
      ."{$_POST['specifics']}\n";
}
$languages = implode(',', $_POST['languages']);
$msg_to_staff .= "\n"
  ."Preferred language(s) (if available):\n"
  ."{$languages}\n"
  ."\n"
  ."The material is going to be used for:\n"
  ."{$_POST['usage']}\n"
  ."\n"
  ."Comments:\n"
  ."{$_POST['comment']}\n";

$_POST['donationID'] = '';
if (isset($_POST['donate']) && ($_POST['donate'] > 0)) {
    $_POST['donationID'] = 'DAFSPCK'.gen_alnum(5);
    $subject .= ': '.$_POST['donationID'];
    $msg_to_staff .= "\n\nThe orderer choose to make a Donation of {$_POST['donate']} Euro.\n"
      ."Please do not assume that this donation has been made until you receive\n"
      ."confirmation from Concardis for the order: {$_POST['donationID']}";
}

// Generate letter to be sent along with the material
$odtfill = $_SERVER['DOCUMENT_ROOT'].'/cgi-bin/odtfill';
$template = $_SERVER['DOCUMENT_ROOT'].'/templates/promotionorder.odt';
$outfile = '/tmp/promotionorder.odt';
$name = $_POST['firstname'].' '.$_POST['lastname'];
$address = '';
if (!empty($_POST['org'])) {
    $address .= $_POST['org'].'\n';
}
$address .= $_POST['street'].'\n'
  .$_POST['zip'].' '.$_POST['city'].'\n'
  .$countryname;
$cmd = sprintf(
    '%s %s %s %s %s %s',
    $odtfill,
    $template,
    $outfile,
    'Name='.escapeshellarg($name),
    'Address='.escapeshellarg($address),
    'Name='.escapeshellarg($name)
);
shell_exec($cmd);

// Make subscriptions to newsletter/community mails
$subcd = isset($_POST['subcd']) ? $_POST['subcd'] : false;
$subnl = isset($_POST['subnl']) ? $_POST['subnl'] : false;
if ('y' == $subcd or 'y' == $subnl) {
    $signupdata = [
        'name' => $_POST['firstname'].' '.$_POST['lastname'],
        'email1' => $_POST['mail'],
        'address' => $_POST['street'],
        'zip' => $_POST['zip'],
        'city' => $_POST['city'],
        'langugage' => $_POST['language'],
        'country' => $countrycode,
    ];
    if ('y' == $subcd) {
        $signupdata['wants_info'] = '1';
    }
    if ('y' == $subnl) {
        $signupdata['wants_newsletter_info'] = '1';
    }
    mail_signup($signupdata);
}

$data = [
    'name' => $_POST['firstname'].' '.$_POST['lastname'],
    'donationID' => $_POST['donationID'],
    'donate' => $_POST['donate'],
    'lang' => $lang,
];
$msg_to_customer = eval_template('promoorder/promoorder.php', $data);

/**
 * Create a new ticket in the FreeScout system.
 */
$url = 'https://helpdesk.fsfe.org/api/conversations';
$apikey = getenv('FREESCOUT_API_KEY');
$jsondata = [
    'type' => 'email',
    'mailboxId' => 7,         // This is the Merchandise Mailbox
    'subject' => $subject,
    'customer' => [
        'email' => $_POST['mail'],
    ],
    'threads' => [
        [
            'text' => $msg_to_staff,
            'type' => 'customer',
            'customer' => [
                'email' => $_POST['mail'],
                'firstName' => $_POST['firstname'],
                'lastName' => $_POST['lastname'],
            ],
            'attachments' => [
                [
                    'fileName' => 'letter.odt',
                    'mimeType' => 'application/vnd.oasis.opendocument.text',
                    'data' => base64_encode(file_get_contents($outfile)),
                ],
            ],
        ],
        [
            'text' => $msg_to_customer,
            'type' => 'message',
            'user' => 6530,
        ],
    ],
    'imported' => false,
    'assignTo' => 6584,
    'status' => 'active',
    'customFields' => [
        [
            'id' => 4,              // Order ID Custom Field
            'value' => $_POST['donationID'] ?? '',    // Donation ID
        ],
    ],
];
$jsonDataEncoded = json_encode($jsondata);

$curl = curl_init();
curl_setopt_array($curl, [
    CURLOPT_RETURNTRANSFER => 1,
    CURLOPT_URL => $url,
    CURLOPT_POST => 1,
    CURLOPT_CUSTOMREQUEST => 'POST',
    CURLOPT_POSTFIELDS => $jsonDataEncoded,
    CURLOPT_HTTPHEADER => [
        'Content-Type: application/json',
        'Content-Length: '.strlen($jsonDataEncoded),
        'X-FreeScout-API-Key: '.$apikey,
    ],
    CURLOPT_USERAGENT => 'FSFE promotion.php',
]);
$response = curl_exec($curl);
curl_close($curl);
// Only process donations starting from 10 euro.
if (isset($_POST['donate']) && ((int) $_POST['donate']) >= 5) {
    relay_donation($_POST['donationID']);
} else {
    // DEBUG: Comment out next line to be able to see errors and printed info
    header("Location: https://fsfe.org/contribute/spreadtheword-orderthanks.{$lang}.html");
}
