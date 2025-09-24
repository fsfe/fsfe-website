<?php

/*
 * SPDX-FileCopyrightText: 2020 Free Software Foundation Europe <https://fsfe.org>
 * SPDX-License-Identifier: AGPL-3.0-or-later
 *
 ************************************************************************
 *
 *  This file receives input from /internal/pd.en.(x)html and calculates per
 *  diem charges for reimbursement claims. The amounts can be defined in
 *  the XHTML file. For the output of the data, it uses
 *  /internal/pd-result.en.(x)html as a template.
 *
 **********************************************************************
*/

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;
use PHPMailer\PHPMailer\SMTP;

require 'PHPMailer/Exception.php';
require 'PHPMailer/PHPMailer.php';
require 'PHPMailer/SMTP.php';

$html = ''; // create empty variable
$csv = array(array("Employee number", "Employee name", "Date", "Amount (EUR)", "Recipient name", "Activity Tag", "Activity Text", "Category ID", "Category Text", "Event", "Description", "Receipt number")); // create array for CSV
$csvfile = tmpfile();
$csvfile_path = stream_get_meta_data($csvfile)['uri'];
$reimb_total = 0;   // total reimbursement for early calculation

$who = isset($_POST["who"]) ? $_POST["who"] : false;
$activity = isset($_POST["activity"]) ? $_POST["activity"] : false;
$activity_tag = explode("||", $activity)[0];
$activity_text = explode("||", $activity)[1];
$category_id = "66640";
$category_text = "Per diem";
$event = isset($_POST["event"]) ? $_POST["event"] : false;
$extra = isset($_POST["extra"]) ? $_POST["extra"] : false;
$mailopt = isset($_POST["mailopt"]) ? $_POST["mailopt"] : false;
$defaults = isset($_POST["defaults"]) ? $_POST["defaults"] : false;
$dest = isset($_POST["dest"]) ? $_POST["dest"] : false;
$dest_other = isset($_POST["dest_other"]) ? $_POST["dest_other"] : false;
$use = isset($_POST["use"]) ? $_POST["use"] : false;
$date = isset($_POST["date"]) ? $_POST["date"] : false;
$break = isset($_POST["break"]) ? $_POST["break"] : false;
$lunch = isset($_POST["lunch"]) ? $_POST["lunch"] : false;
$dinner = isset($_POST["dinner"]) ? $_POST["dinner"] : false;

// Separate employee name parameters
$who_verbose = explode('||', $who)[0];
$who_empnumber = explode('||', $who)[2];
$who = explode('||', $who)[1];

// FUNCTIONS
function errexit($msg)
{
    exit("Error: " . $msg . "<br/><br/>To avoid losing your data, press the back button in your browser");
}
function replace_page($temp, $content)
{
    $vars = array(':RESULT:' => $content);
    return str_replace(array_keys($vars), $vars, $temp);
}
/* Snippet Begin:
 * SPDX-SnippetLicenseConcluded: CC-BY-SA-4.0
 * SPDX-SnippetCopyrightText: mgutt <https://stackoverflow.com/users/318765/mgutt>
*/
function filter_filename($filename, $beautify = true)
{
    // sanitize filename
    $filename = preg_replace(
        '~
    [<>:"/\\|?*]|            # file system reserved https://en.wikipedia.org/wiki/Filename#Reserved_characters_and_words
    [\x00-\x1F]|             # control characters http://msdn.microsoft.com/en-us/library/windows/desktop/aa365247%28v=vs.85%29.aspx
    [\x7F\xA0\xAD]|          # non-printing characters DEL, NO-BREAK SPACE, SOFT HYPHEN
    [#\[\]@!$&\'()+,;=]|     # URI reserved https://tools.ietf.org/html/rfc3986#section-2.2
    [{}^\~`]                 # URL unsafe characters https://www.ietf.org/rfc/rfc1738.txt
    ~x',
        '-',
        $filename
    );
    // avoids ".", ".." or ".hiddenFiles"
    $filename = ltrim($filename, '.-');
    // optional beautification
    if ($beautify) {
        $filename = beautify_filename($filename);
    }
    // maximize filename length to 255 bytes http://serverfault.com/a/9548/44086
    $ext = pathinfo($filename, PATHINFO_EXTENSION);
    $filename = mb_strcut(pathinfo($filename, PATHINFO_FILENAME), 0, 255 - ($ext ? strlen($ext) + 1 : 0), mb_detect_encoding($filename)) . ($ext ? '.' . $ext : '');
    return $filename;
}
function beautify_filename($filename)
{
    // reduce consecutive characters
    $filename = preg_replace(array(
      // "file   name.zip" becomes "file-name.zip"
      '/ +/',
      // "file___name.zip" becomes "file-name.zip"
      '/_+/',
      // "file---name.zip" becomes "file-name.zip"
      '/-+/'
    ), '-', $filename);
    $filename = preg_replace(array(
      // "file--.--.-.--name.zip" becomes "file.name.zip"
      '/-*\.-*/',
      // "file...name..zip" becomes "file.name.zip"
      '/\.{2,}/'
    ), '.', $filename);
    // lowercase for windows/unix interoperability http://support.microsoft.com/kb/100625
    $filename = mb_strtolower($filename, mb_detect_encoding($filename));
    // ".file-name.-" becomes "file-name"
    $filename = trim($filename, '.-');
    return $filename;
}
/* Snippet End */


// Take currency and meal rates for the default country. Other home countries are not supported.
$defaults = explode("/", $defaults);
$currency = " " . $defaults[0];            // currency
$rate_breakf = floatval($defaults[1]);    // breakfast rate
$rate_lunch = floatval($defaults[2]);    // lunch rate
$rate_dinner = floatval($defaults[3]);    // dinner rate

// eligible amount per day
if ($dest === 'other') {
    $dest = $dest_other;  // if other destination, just take this value
} else {
    $pattern = "/([0-9.]+)?\/([0-9.]+)?/";  // define pattern something like "/12/24/"
    $dest = preg_match($pattern, $dest, $match, PREG_OFFSET_CAPTURE); // actually search for it
    $dest = $match[0][0]; // matches are on 2nd level in an array
}

// dest -> epd (half/full amount)
$maxamount = explode('/', $dest);  // separate at "/"
$maxamount_trav = floatval($maxamount[0]);  // first half
$maxamount_full = floatval($maxamount[1]);  // second half

// Prepare output table
if ($mailopt === "onlyme") {
    $html .= "<p><strong>ATTENTION: The email has only been sent to you, not to the financial team!</strong></p>";
} elseif ($mailopt === "none") {
    $html .= "<p><strong>ATTENTION: You have configured to not send any email!</strong></p>";
}
$html .= "<p>This per diem statement is made by <strong>$who_verbose</strong>.</p>
<table class='table table-striped'>
  <tr>
    <th>Date</th>
    <th>Amount</th>
    <th>Recipient</th>
    <th>Activity Tag</th>
    <th>Activity Text</th>
    <th>Category Id</th>
    <th>Category Text</th>
    <th>Event</th>
    <th>Description</th>
  </tr>";

// Prepare email
$email = new PHPMailer();
$email->isSMTP();
$email->Host        = "mail.fsfe.org";
// Settings on server
$email->SMTPAuth    = false;
$email->Port    = 25;
// Settings for local debug
//$email->SMTPAuth   = true;
//$email->Port       = 587;
//$email->Username   = 'fsfe_user';
//$email->Password   = 'fsfe_pass';
//$email->SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS;
$email->SetFrom($who . "@fsfe.org", $who_verbose);
$email->CharSet = "UTF-8";
$email->Subject     = "=?UTF-8?B?" . base64_encode("per diem statement by $who_verbose for $activity_text") . "?=";
if ($mailopt === "normal") {
    $email->addAddress("finance@lists.fsfe.org");
}
$email->addAddress($who . "@fsfe.org");


foreach ($use as $d => $day) {  // calculate for each day
    // set "no" as value for day's variable if empty
    $use[$d] = $use[$d] ?? 'no';
    $date[$d] = $date[$d] ?? 'no';
    $break[$d] = $break[$d] ?? 'no';
    $lunch[$d] = $lunch[$d] ?? 'no';
    $dinner[$d] = $dinner[$d] ?? 'no';

    // increase $d by 1 if numeric, for $csv array number
    if (is_numeric($d)) {
        $key = $d + 1;
    } else {
        $key = $d;
    }

    if ($use[$d] === 'yes') { // only calculate if checkbox has been activated (day in use)
        if ($d === 'out' || $d === 'return') {  // set amount of € for travel or full day
            $reimb_day[$d] = $maxamount_trav;   // total max. reimburseable amount for this half day
        } else {
            $reimb_day[$d] = $maxamount_full;   // total max. reimburseable amount for this full day
        }

        // date
        if ($date[$d] === '') {
            $date[$d] = "Day " . $d;
        }
        // breakfast
        if ($break[$d] !== "yes") {
            // if meal paid by someone else: total amount for today =
            // MINUS total possible amount for a FULL day * rate for this meal
            // no matter whether today is a full or a half day
            $reimb_day[$d] = $reimb_day[$d] - $maxamount_full * $rate_breakf;
        }
        // lunch
        if ($lunch[$d] !== "yes") {
            $reimb_day[$d] = $reimb_day[$d] - $maxamount_full * $rate_lunch;
        }
        // dinner
        if ($dinner[$d] !== "yes") {
            $reimb_day[$d] = $reimb_day[$d] - $maxamount_full * $rate_dinner;
        }

        // Avoid negative amounts
        if ($reimb_day[$d] < 0) {
            $reimb_day[$d] = 0;
        }

        // add on top of total reimbursement
        $reimb_total = $reimb_total + $reimb_day[$d];

        // change number format of this day's amount to German (comma)
        $reimb_day[$d] = number_format($reimb_day[$d], 2, ',', '');

        // Remarks, explanation what has been self-paid
        $remarks[$d] = "";
        if ($break[$d] === "yes") {
            $remarks[$d] .= "breakfast+";
        }
        if ($lunch[$d] === "yes") {
            $remarks[$d] .= "lunch+";
        }
        if ($dinner[$d] === "yes") {
            $remarks[$d] .= "dinner";
        }
        if ($break[$d] != "yes" && $lunch[$d] != "yes" && $dinner[$d] != "yes") {
            $remarks[$d] = "nothing";
        }
        if ($break[$d] === "yes" && $lunch[$d] === "yes" && $dinner[$d] === "yes") {
            $remarks[$d] = "everything";
        }
        $remarks[$d] = preg_replace("/\+$/", "", $remarks[$d]);
        $remarks[$d] .= " self-paid";

        // HTML output for this day
        $html .= "
    <tr>
      <td>$date[$d]</td>
      <td>$reimb_day[$d]</td>
      <td>$who_verbose</td>
      <td>$activity_tag</td>
      <td>$activity_text</td>
      <td>$category_id</td>
      <td>$category_text</td>
      <td>$event</td>
      <td>$remarks[$d]</td>
    </tr>";

        // CSV for this receipt
        $csv[$key] = array($who_empnumber, $who_verbose, $date[$d], $reimb_day[$d], $who_verbose, $activity_tag, $activity_text, $category_id, $category_text, $event, $remarks[$d], "");

    } // if day is used
} // foreach

// Write and attach temporary CSV file
foreach ($csv as $fields) {
    fputcsv($csvfile, $fields, ';', '"', '"');
}
$email->addAttachment($csvfile_path, filter_filename($date[$d]."-"."pd" ."-". $who ."-". $activity_tag ."-". $event . ".csv"));

// Prepare email body
$email_body = "Hi,

This is a per diem statement by $who_verbose for
$activity_tag ($activity_text),
sent via <https://fsfe.org/internal/pd>.

Please find the expenses attached.";

// change number format of total amount to German (comma)
$reimb_total = number_format($reimb_total, 2, ',', '');

// Finalise output table
$html .= "<tr><td><strong>Total:</strong></td><td><strong>$reimb_total $currency</strong></td>";
$html .= "<td colspan='8'></td></tr>";
$html .= "</table>";
if ($extra) {
    $html .= "<p>Extra remarks: <br />$extra</p>";

    $email_body .= "

The sender added the following comment:

$extra";
}

// Send email, and delete attachments
$email->Body = $email_body;
if ($mailopt === "normal" || $mailopt === "onlyme") {
    $email->send();
    $html .= $email->ErrorInfo;
}
fclose($csvfile);

// --- PRINT OUTPUT IN TEMPLATE FILE ---

$template = file_get_contents('../internal/pd-result.en.html', true);

echo replace_page($template, $html);
