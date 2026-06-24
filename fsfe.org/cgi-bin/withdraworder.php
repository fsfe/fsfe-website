<?php
function send_email ($name, $address, $zip, $city, $country, $email, $orderid, $lang) {
    $url = 'https://helpdesk.fsfe.org/api/conversations';
    $apikey = getenv('FREESCOUT_API_KEY');
    $subject = "Withdraw from order " . $orderid;
    $mailcustomer = "<html><body><p>Dear " . $name . ",</p>";
    $mailcustomer .= "<p>we received your request to withdraw from the order " . $orderid . " we will process it as soon as possible.</p>";
    $mailcustomer .= "<p>Best,<br/>The Merchendise Team of the FSFE</p></body></html>";
    $mailbody = "<html><body><p>Hello,</p><p>" . $name . " is withdrawing the order " . $orderid . ".</p>";
    $mailbody .= "<p>Please check that the following details of the order match:<br/>";
    $mailbody .= "Address: " . $address . "<br/>";
    $mailbody .= "ZIP code: " . $zip . "<br/>";
    $mailbody .= "City: " . $city . "<br/>";
    $mailbody .= "Country: " . $country . ".</p>";
    $jsondata = [
        'type' => 'email',
        'mailboxId' => 7, // This is the Merchendise Inbox
        'subject' => $subject,
        'customer' => [
            'email' => $email,
            'firstName' => $name,
        ],
        'threads' => [
            [
                'text' => $mailcustomer,
                'type' => 'message',
                'user' => 6530,
            ],
            [
                'text' => $mailbody,
                'type' => 'note',
                'user' => 6584,
            ],
        ],
        'imported' => false,
        'assignTo' => 6584,
        'status' => 'active',
        'customFields' => [
            [
                'id' => 4,              // Order ID Custom Field
                'value' => $orderid ?? '',    // Donation ID
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
        CURLOPT_USERAGENT => 'FSFE withdraworder.php',
    ]);
    $response = curl_exec($curl);
    curl_close($curl);

    return $response;
}
if ($_SERVER["REQUEST_METHOD"] == "POST") {
  // sanity check URL is not set
  if (!empty($_POST["url"])) {
    die("The supplied data is incorrect. Please use the back button of the browser to return to the form.");
  }
  // sanity check all the needed fields are set
  if ( empty($_POST["name"]) || empty($_POST["address"]) || empty($_POST["zip"]) || empty($_POST["city"]) || empty($_POST["country"]) || empty($_POST["email"]) || empty($_POST["orderid"]) ) {
    die("The supplied data is incorrect. Please use the back button of the browser to return to the form.");
  }
  $lang = substr($_POST['language'], 0, 2);
  $email_response = send_email(
    htmlspecialchars($_POST["name"]),
    htmlspecialchars($_POST["address"]),
    htmlspecialchars($_POST["zip"]),
    htmlspecialchars($_POST["city"]),
    htmlspecialchars($_POST["country"]),
    htmlspecialchars($_POST["email"]),
    htmlspecialchars($_POST["orderid"]),
    $lang
  );
  header("Location: https://fsfe.org/order/withdrawedfromorder.{$lang}.html");

} else {
    die("An error occured.");
}