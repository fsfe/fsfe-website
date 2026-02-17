<?php

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
$countrycode = explode('|', htmlspecialchars($_POST['country']))[0];
$countryname = explode('|', htmlspecialchars($_POST['country']))[1];

$subject = 'Promotion material order';
$msg_to_staff = "Please send me promotional material:\n"
  ."First Name: ".htmlspecialchars($_POST['firstname'])."\n"
  ."Last Name:  ".htmlspecialchars($_POST['lastname'])."\n"
  ."EMail:      ".htmlspecialchars($_POST['mail'])."\n"
  ."\n"
  ."Address:\n"
  . htmlspecialchars($_POST['firstname'])." ".htmlspecialchars($_POST['lastname'])."\n";

if (!empty($_POST['org'])) {
    $msg_to_staff .= htmlspecialchars($_POST['org'])."\n";
}
$msg_to_staff .= htmlspecialchars($_POST['street'])."\n"
  . htmlspecialchars($_POST['zip'])." ".htmlspecialchars($_POST['city'])."\n"
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
      .htmlspecialchars($_POST['specifics'])."\n";
}
$languages = implode(',', $_POST['languages']);
$msg_to_staff .= "\n"
  ."Preferred language(s) (if available):\n"
  ."{$languages}\n"
  ."\n"
  ."The material is going to be used for:\n"
  .htmlspecialchars($_POST['usage'])."\n";

// Generate letter to be sent along with the material
$odtfill = $_SERVER['DOCUMENT_ROOT'].'/cgi-bin/odtfill.sh';
$template = $_SERVER['DOCUMENT_ROOT'].'/templates/promotionorder.odt';
$outfile = '/tmp/promotionorder.odt';
$name = htmlspecialchars($_POST['firstname']).' '.htmlspecialchars($_POST['lastname']);
$address = '';
if (!empty($_POST['org'])) {
    $address .= htmlspecialchars($_POST['org']).'\n';
}
$address .= htmlspecialchars($_POST['street']).'\n'
  .htmlspecialchars($_POST['zip']).' '.htmlspecialchars($_POST['city']).'\n'
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
// This also gets the DONREF for the donation from the API
$subcd = isset($_POST['subcd']) ? $_POST['subcd'] : false;
$subnl = isset($_POST['subnl']) ? $_POST['subnl'] : false;
$donate = isset($_POST['donate']) ? intval($_POST['donate']) > 0 : false;
if ('y' == $subcd or 'y' == $subnl or $donate) {
    $signupdata = [
        'name' => htmlspecialchars($_POST['firstname']).' '.htmlspecialchars($_POST['lastname']),
        'email1' => htmlspecialchars($_POST['mail']),
        'address' => htmlspecialchars($_POST['street']),
        'zip' => htmlspecialchars($_POST['zip']),
        'city' => htmlspecialchars($_POST['city']),
        'langugage' => htmlspecialchars($_POST['language']),
        'country' => $countrycode,
    ];
    if ('y' == $subcd) {
        $signupdata['wants_info'] = '1';
    }
    if ('y' == $subnl) {
        $signupdata['wants_newsletter_info'] = '1';
    }
    $context = stream_context_create(
        [
            'http' => [
                'method' => 'POST',
                'header' => 'Content-type: application/x-www-form-urlencoded',
                'user_agent' => 'FSFE mail-signup.php',
                'content' => http_build_query($signupdata),
                'timeout' => 10,
            ],
        ]
    );
    // DEBUG: set a local URL here to catch the requests
    $cd_res = file_get_contents('https://my.fsfe.org/subscribe-api', false, $context);
    $json_cd_res = json_decode($cd_res, true);
    if (is_null($json_cd_res) or !isset($json_cd_res['donref'])) {
        header("Location: https://fsfe.org/contribute/spreadtheword-ordererror.{$lang}.html");
        exit;
    }
}

if (isset($json_cd_res) && ($_POST['donate'] > 0)) {
    $_POST['donationID'] = $json_cd_res['donref'].'Z1';
    $subject .= ': '.$_POST['donationID'];
    $msg_to_staff .= "\n\nThe orderer choose to make a Donation of ".htmlspecialchars($_POST['donate'])." Euro.\n"
      ."Please do not assume that this donation has been made until you receive\n"
      ."confirmation from stripe for the order: {$_POST['donationID']}";
}

$data = [
    'name' => htmlspecialchars($_POST['firstname']).' '.htmlspecialchars($_POST['lastname']),
    'donationID' => isset($_POST['donationID']) ? $_POST['donationID'] : '',
    'donate' => htmlspecialchars($_POST['donate']),
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
        'email' => htmlspecialchars($_POST['mail']),
    ],
    'threads' => [
        [
            'text' => $msg_to_staff,
            'type' => 'customer',
            'customer' => [
                'email' => htmlspecialchars($_POST['mail']),
                'firstName' => htmlspecialchars($_POST['firstname']),
                'lastName' => htmlspecialchars($_POST['lastname']),
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
if (isset($_POST['donate']) && ((int) $_POST['donate']) >= 10) {
    $replace = array(':AMOUNT:', ':EMAIL:', ':REFERENCE:');
    $with = array($_POST['donate'], $_POST['mail'], $_POST['donationID']);
    $contents = file_get_contents($_SERVER['DOCUMENT_ROOT']."/contribute/spreadtheword-tmpl-payment." . $lang . ".html");
    echo str_replace($replace, $with, $contents);
} else {
    // DEBUG: Comment out next line to be able to see errors and printed info
    header("Location: https://fsfe.org/contribute/spreadtheword-orderthanks.{$lang}.html");
}
