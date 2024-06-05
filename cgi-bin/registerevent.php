<?php
/* Copyright (C) 2012, Tobias Bengfort <tobias.bengfort@gmx.net> & Marius Jammes for FSFE e.V.

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>. */

function eval_xml_template($template, $data)
{
    $dir = realpath(dirname(__FILE__) . "/../templates");
    $result = file_get_contents("$dir/$template");
    foreach ($data as $key => $value) {
        $result = preg_replace("/<tpl name=\"$key\"><\/tpl>/", $value, $result);
    }
    $result = preg_replace("/<tpl name=\"[^\"]*\"><\/tpl>/", "", $result);
    return $result;
}
// $pr_url is only used when sending the notification emails, not when rendering the success/failure pages on the webpage.
function eval_template($template, $data, $pr_url = "")
{
    $extra_message =
        $pr_url == ""
            ? "Pr url undefined due to error in process of adding file and creating PR. Please add file to website manually and investigate/request investigation of source of issue."
            : "";
    extract($data);
    $dir = realpath(dirname(__FILE__) . "/../templates");
    ob_start();
    include "$dir/$template";
    $result = ob_get_contents();
    ob_end_clean();
    return $result;
}

function get_mime_type($path)
{
    if (function_exists("finfo_open")) {
        $finfo = finfo_open(FILEINFO_MIME_TYPE);
        $mime = finfo_file($finfo, $path);
        finfo_close($finfo);
        return $mime;
    } else {
        return mime_content_type($path);
    }
}

function eval_date($date)
{
    $dt = date_parse($date);
    return !$dt["errors"] &&
        $dt["year"] &&
        preg_match(
            "#^(19|20)\d\d[- /.](0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[01])$#",
            $date
        ) === 1;
}

function parse_submission()
{
    // do some prior location computation
    $countrycode = explode("|", $_POST["country"])[0];
    $countryname = explode("|", $_POST["country"])[1];

    if (isset($_POST["online"]) && $_POST["online"] === "yes") {
        $location = "online";
    } else {
        $location =
            htmlspecialchars($_POST["city"]) .
            ", " .
            htmlspecialchars($countryname);
    }

    $data = [
        "name" => isset($_POST["name"]) ? $_POST["name"] : "",
        "email" => isset($_POST["email"]) ? $_POST["email"] : "",
        "title" => isset($_POST["title"]) ? $_POST["title"] : "",
        "groupname" => isset($_POST["groupname"]) ? $_POST["groupname"] : "",
        "groupurl" => isset($_POST["groupurl"]) ? $_POST["groupurl"] : "",
        "startdate" => isset($_POST["startdate"]) ? $_POST["startdate"] : "",
        "enddate" => isset($_POST["enddate"]) ? $_POST["enddate"] : "",
        "description" => isset($_POST["description"])
            ? $_POST["description"]
            : "",
        "url" => isset($_POST["url"]) ? $_POST["url"] : "",
        "online" => isset($_POST["online"]) ? $_POST["online"] : "",
        "location" => $location,
        "countryname" => $countryname,
        "countrycode" => $countrycode,
        "tags" => isset($_POST["tags"]) ? $_POST["tags"] : "",
        "lang" => isset($_POST["lang"]) ? $_POST["lang"] : "",
    ];

    $event = eval_template("registerevent/event.php", $data);

    $subject = "Event registration: " . $_POST["title"];
    return [
        "data" => $data,
        "event" => $event,
        "subject" => $subject,
    ];
}

function calculate_information($data)
{
    $year = substr($data["startdate"], 0, 4);
    $apikey = getenv("GITEA_API_KEY");
    $filename = "";
    $file_url = "";
    $branchname = "";
    $pr_url = "";
    $eventhash = substr(
        hash("sha256", $data["email"] . $data["startdate"] . $data["enddate"]),
        0,
        16
    );
    $event_start_date = str_replace("-", "", $data["startdate"]);
    $newbranch = null;
    $success = true;

    $url =
        "https://git.fsfe.org/api/v1/repos/FSFE/fsfe-website/pulls?state=open";
    $curl = curl_init();
    curl_setopt_array($curl, [
        CURLOPT_RETURNTRANSFER => 1,
        CURLOPT_URL => $url,
        CURLOPT_CUSTOMREQUEST => "GET",
        CURLOPT_HTTPHEADER => [
            "Content-Type: application/json",
            "Authorization: token " . $apikey,
        ],
        CURLOPT_USERAGENT => "FSFE registerevent.php",
    ]);
    $response = curl_exec($curl);
    curl_close($curl);
    $decoded_response = json_decode($response);
    // Convert each array value from stdClass to arrays.
    foreach ($decoded_response as &$value) {
        $value = json_decode(json_encode($value), true);
    }
    unset($value);
    for ($i = 0; $i < count($decoded_response); $i++) {
        $response_head_label = $decoded_response[$i]["head"]["label"];

        // If title of branch does not match the pattern of an autogenerted title, skip it
        if (
            !isset($response_head_label) ||
            strlen($response_head_label) != 41
        ) {
            goto end;
        }
        // If events have the same hash and date, assume that they are the same.
        $response_head_eventhash = substr(
            $decoded_response[$i]["head"]["label"],
            -strlen($eventhash)
        );
        $response_head_date = substr($decoded_response[$i]["head"]["label"], 10, 8);
        $response_head_digit = substr($decoded_response[$i]["head"]["label"], 19, 2);

        if (
            $response_head_eventhash == $eventhash &&
            $response_head_date == $event_start_date
        ) {
            $newbranch = false;
            $pr_url = $decoded_response[$i]["url"];
            $filename =
                "event-" .
                $event_start_date .
                "-" .
                $response_head_digit .
                "." .
                $data["lang"] .
                ".xml";
            $file_url = "https://git.fsfe.org/api/v1/repos/FSFE/fsfe-website/contents/events/{$year}/{$filename}";
            $branchname = $response_head_label;
            break;
        }
        end:
        if (($i == count($decoded_response)) || ($i == (count($decoded_response) - 1))) {
            $newbranch = true;
        }
    }
    if ($newbranch) {
        // Check if file already exists, and increment untitl it does not.
        for ($count = 1; $count <= 30; $count++) {
            $digit = str_pad($count, 2, "0", STR_PAD_LEFT);
            $filename =
                "event-" .
                $event_start_date .
                "-" .
                $digit .
                "." .
                $data["lang"] .
                ".xml";
            $file_url = "https://git.fsfe.org/api/v1/repos/FSFE/fsfe-website/contents/events/{$year}/{$filename}";
            $curl = curl_init();
            curl_setopt_array($curl, [
                CURLOPT_RETURNTRANSFER => 1,
                CURLOPT_URL => $file_url,
                CURLOPT_CUSTOMREQUEST => "GET",
                CURLOPT_HTTPHEADER => ["Authorization: token " . $apikey],
                CURLOPT_USERAGENT => "FSFE registerevent.php",
            ]);
            $response = curl_exec($curl);
            $file_http_info = curl_getinfo($curl);
            curl_close($curl);
            // Assume that if we get a file missing response that there is no file available,not that the server is down or something
            if ((int) $file_http_info["http_code"] == 404) {
                break;
            }
            if ($count == 30) {
                $success = false;
            }
        }
        // Check if branch already exists, and increment until it does not
        for ($count = 1; $count <= 30; $count = $count + 1) {
            $digit = str_pad($count, 2, "0", STR_PAD_LEFT);
            $branchname =
                "ADD-" .
                substr($filename, 0, 17) .
                "-" .
                $digit .
                "-" .
                $eventhash;
            $branch_url = "https://git.fsfe.org/api/v1/repos/FSFE/fsfe-website/branches/{$branchname}";
            $curl = curl_init();
            curl_setopt_array($curl, [
                CURLOPT_RETURNTRANSFER => 1,
                CURLOPT_URL => $branch_url,
                CURLOPT_CUSTOMREQUEST => "GET",
                CURLOPT_HTTPHEADER => ["Authorization: token " . $apikey],
                CURLOPT_USERAGENT => "FSFE registerevent.php",
            ]);
            $response = curl_exec($curl);
            $branch_http_info = curl_getinfo($curl);
            curl_close($curl);
            // Assume that if we get a file missing response that there is no file available,not that the server is down or something
            if ((int) $branch_http_info["http_code"] == 404) {
                break;
            }
            if ($count == 30) {
                $success = false;
            }
        }
    }
    return [
        "year" => $year,
        "filename" => $filename,
        "file_url" => $file_url,
        "branchname" => $branchname,
        "newbranch" => $newbranch,
        "success" => $success,
        "pr_url" => $pr_url,
    ];
}

function add_event_file($data, $event, $calculated_information)
{
    $apikey = getenv("GITEA_API_KEY");
    $jsondata =
        [
            "author" => [
                "email" => "syshackers@fsfe.org",
                "name" => "fsfe-website/cgi-bin/registerevent.php",
            ],
            "committer" => [
                "email" => "syshackers@fsfe.org",
                "name" => "fsfe-website/cgi-bin/registerevent.php",
            ],
            // Encode file in base64, as required by the api.
            "content" => base64_encode($event),
            "message" => "Commit generated by fsfe-website/cgi-bin/registerevent, to add event /events/{$calculated_information["year"]}/{$calculated_information["filename"]}",
            "signoff" => true,
        ] +
        ($calculated_information["newbranch"]
            ? [
                "branch" => "master",
                "new_branch" => $calculated_information["branchname"],
            ]
            : ["branch" => $calculated_information["branchname"]]);
    $jsonDataEncoded = json_encode($jsondata);

    $curl = curl_init();
    curl_setopt_array($curl, [
        CURLOPT_RETURNTRANSFER => 1,
        CURLOPT_URL => $calculated_information["file_url"],
        CURLOPT_POST => 1,
        CURLOPT_CUSTOMREQUEST => "POST",
        CURLOPT_POSTFIELDS => $jsonDataEncoded,
        CURLOPT_HTTPHEADER => [
            "Content-Type: application/json",
            "Content-Length: " . strlen($jsonDataEncoded),
            "Authorization: token " . $apikey,
        ],
        CURLOPT_USERAGENT => "FSFE registerevent.php",
    ]);
    $response = curl_exec($curl);
    $info = curl_getinfo($curl);
    curl_close($curl);
    return [$response, $info];
}

function create_pr($data, $calculated_information)
{
    $url = "https://git.fsfe.org/api/v1/repos/FSFE/fsfe-website/pulls";
    $apikey = getenv("GITEA_API_KEY");
    $jsondata = [
        "assignees" => ["delliott"],
        "base" => "master",
        "body" => "This pr has been automatically generated by registerevent.php to merge {$calculated_information["branchname"]}.",
        "head" => $calculated_information["branchname"],
        "title" => "WIP: {$calculated_information["branchname"]}",
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
            "Authorization: token " . $apikey,
        ],
        CURLOPT_USERAGENT => "FSFE registerevent.php",
    ]);
    $response = curl_exec($curl);
    $info = curl_getinfo($curl);
    curl_close($curl);
    return [$response, $info];
}

/**
 * Create a new ticket in the FreeScout system
 */
function send_event_email(
    $data,
    $subject,
    $event,
    $calculated_information,
    $pr_url
) {
    $url = "https://helpdesk.fsfe.org/api/conversations";
    $apikey = getenv("FREESCOUT_API_KEY");
    $jsondata = [
        "type" => "email",
        "mailboxId" => 5, # This is the General Helpdesk
        "subject" => $subject,
        "customer" => [
            "email" => $_POST["email"],
            "firstName" => $_POST["name"],
        ],
        "threads" => [
            [
                "text" => eval_template(
                    "registerevent/mailstaff.php",
                    $data,
                    $pr_url
                ),
                "type" => "customer",
                "customer" => [
                    "email" => $_POST["email"],
                    "firstName" => $_POST["name"],
                ],
                "attachments" => [
                    [
                        "fileName" => $calculated_information["filename"],
                        "mimeType" => "application/xml",
                        "data" => base64_encode($event),
                    ],
                ],
            ],
            [
                "text" => eval_template(
                    "registerevent/mail.php",
                    $data,
                    $pr_url
                ),
                "type" => "message",
                "user" => 6530,
                "attachments" => [
                    [
                        "fileName" => $calculated_information["filename"],
                        "mimeType" => "application/xml",
                        "data" => base64_encode($event),
                    ],
                ],
            ],
        ],
        "imported" => false,
        "status" => "active",
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
            "X-FreeScout-API-Key: " . $apikey,
        ],
        CURLOPT_USERAGENT => "FSFE registerevent.php",
    ]);
    $response = curl_exec($curl);
    curl_close($curl);
    return $response;
}

if (
    isset($_POST["register_event"]) and
    empty($_POST["spam"]) and
    eval_date($_POST["startdate"]) and
    $_POST["startdate"] > "2023-01-01" and
    eval_date($_POST["enddate"]) || empty($_POST["enddate"]) and
    !stripos($_POST["email"], "example.com")
) {
    $parsed_information = parse_submission();
    $pr_url = "";

    // If any step errors we just go straight to sending the email
    $calculated_information = calculate_information(
        $parsed_information["data"]
    );
    $pr_url = $calculated_information["pr_url"];

    // If we failed to calculate information, skip trying to make branch and stuff.
    if (!$calculated_information["success"]) {
        goto sendemail;
    }

    [$file_response, $file_info] = add_event_file(
        $parsed_information["data"],
        $parsed_information["event"],
        $calculated_information
    );
    // If making a newbranch failed, or the branch and pr already existed, as determined in calculated_information, then skip trying to make a new pr.
    if (
        (int) $file_info["http_code"] != 201 ||
        $calculated_information["newbranch"] == false
    ) {
        goto sendemail;
    }

    [$pr_response, $pr_info] = create_pr(
        $parsed_information["data"],
        $calculated_information
    );
    if ((int) $pr_info["http_code"] != 201) {
        goto sendemail;
    }

    $decoded_pr_response = json_decode($pr_response, true);
    $pr_url = $decoded_pr_response["url"];

    sendemail:
    $emailResponse = send_event_email(
        $parsed_information["data"],
        $parsed_information["subject"],
        $parsed_information["event"],
        $calculated_information,
        $pr_url
    );

    echo eval_xml_template("registerevent/success.en.html", [
        "notice" => "", // TODO display some error code here
    ]);
} else {
    echo eval_xml_template("registerevent/error.en.html", [
        "notice" => "", // TODO display the error here
    ]);
}
