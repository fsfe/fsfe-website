<?php
function send_email ($name, $email, $experience, $material, $eventdescription, $city, $country, $startdate, $people, $language, $package, $address, $notes, $personalinfo) {
    $url = 'https://helpdesk.fsfe.org/api/conversations';
    $apikey = getenv('FREESCOUT_API_KEY');
    $subject = "Booth request from " . $name . " - " . $city;
    
    // Email to the person who filled the form
    $mailcustomer = "<html><body><p>Dear " . $name . ",</p>";
    $mailcustomer .= "<p>thank you for your booth request for the event in " . $city . ". We will review your request and get back to you as soon as possible.</p>";
    $mailcustomer .= "<p>Best,<br/>The FSFE Team</p></body></html>";
    
    // Internal note with all the submitted details
    $mailbody = "<html><body><p>Hello,</p><p>" . $name . " has submitted a new booth request.</p>";
    $mailbody .= "<p>Please check the following details:<br/>";
    $mailbody .= "Email: " . $email . "<br/>";
    $mailbody .= "Organised a booth before: " . $experience . "<br/>";
    $mailbody .= "Material requested: " . $material . "<br/>";
    $mailbody .= "Event description: " . $eventdescription . "<br/>";
    $mailbody .= "City: " . $city . "<br/>";
    $mailbody .= "Country: " . $country . "<br/>";
    $mailbody .= "Start date: " . $startdate . "<br/>";
    $mailbody .= "Expected attendance: " . $people . "<br/>";
    $mailbody .= "Preferred language(s): " . $language . "<br/>";
    $mailbody .= "Package size: " . $package . "<br/>";
    $mailbody .= "Shipping address: " . $address . "<br/>";
    $mailbody .= "Additional notes: " . $notes . "<br/>";
    $mailbody .= "Personal background: " . $personalinfo . "</p>";
    $jsondata = [
        'type' => 'email',
        'mailboxId' => 7, 
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
        CURLOPT_USERAGENT => 'FSFE registerbooth.php',
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
  if (
        empty($_POST["name"]) ||
        empty($_POST["email"]) ||
        empty($_POST["experience"]) ||
        empty($_POST["material"]) ||
        empty($_POST["eventdescription"]) ||
        empty($_POST["city"]) ||
        empty($_POST["country"]) ||
        empty($_POST["startdate"]) ||
        empty($_POST["people"]) ||
        empty($_POST["language"]) ||
        empty($_POST["package"]) ||
        empty($_POST["address"])
    ) {
    die("The supplied data is incorrect. Please use the back button of the browser to return to the form.");
  }
  $lang = substr($_POST['language'], 0, 2);
  $email_response = send_email(
    htmlspecialchars($_POST["name"]),
        htmlspecialchars($_POST["email"]),
        htmlspecialchars($_POST["experience"]),
        htmlspecialchars($_POST["material"]),
        htmlspecialchars($_POST["eventdescription"]),
        htmlspecialchars($_POST["city"]),
        htmlspecialchars($_POST["country"]),
        htmlspecialchars($_POST["startdate"]),
        htmlspecialchars($_POST["people"]),
        htmlspecialchars($_POST["language"]),
        htmlspecialchars($_POST["package"]),
        htmlspecialchars($_POST["address"]),
        htmlspecialchars($_POST["notes"] ?? ''),
        htmlspecialchars($_POST["personalinfo"] ?? '')
  );
  header("Location: https://fsfe.org/events/tools/boothregistration.html");
} else {
    die("An error occured.");
}
