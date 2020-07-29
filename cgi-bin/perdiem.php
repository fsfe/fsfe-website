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
$csv = array(array("Employee name", "Date", "Amount (EUR)", "Recipient name", "ER number", "Catchphrase", "Receipt number", "Remarks")); // create array for CSV
$csvfile = tmpfile();
$csvfile_path = stream_get_meta_data($csvfile)['uri'];
$r_total = 0;   // total reimbursement for early calculation

$who = isset($_POST["who"]) ? $_POST["who"] : false;
$er = isset($_POST["er"]) ? $_POST["er"] : false;
$catch = isset($_POST["catch"]) ? $_POST["catch"] : false;
$extra = isset($_POST["extra"]) ? $_POST["extra"] : false;
$mailopt = isset($_POST["mailopt"]) ? $_POST["mailopt"] : false;
$home = isset($_POST["home"]) ? $_POST["home"] : false;
$home_other = isset($_POST["home_other"]) ? $_POST["home_other"] : false;
$dest = isset($_POST["dest"]) ? $_POST["dest"] : false;
$dest_other = isset($_POST["dest_other"]) ? $_POST["dest_other"] : false;
$use = isset($_POST["use"]) ? $_POST["use"] : false;
$date = isset($_POST["date"]) ? $_POST["date"] : false;
$break = isset($_POST["break"]) ? $_POST["break"] : false;
$lunch = isset($_POST["lunch"]) ? $_POST["lunch"] : false;
$dinner = isset($_POST["dinner"]) ? $_POST["dinner"] : false;

// Separate employee name parameters
$who_verbose = explode('|', $who)[0];
$who = explode('|', $who)[1];

// FUNCTIONS
function errexit($msg) {
  exit("Error: " . $msg . "<br/><br/>To avoid losing your data, press the back button in your browser");
}
function replace_page($temp, $content){
    $vars = array(':RESULT:'=>$content);
    return str_replace(array_keys($vars), $vars, $temp);
}
/* Snippet Begin:
 * SPDX-SnippetLicenseConcluded: CC-BY-SA-4.0
 * SPDX-SnippetCopyrightText: mgutt <https://stackoverflow.com/users/318765/mgutt>
*/
function filter_filename($filename, $beautify=true) {
  // sanitize filename
  $filename = preg_replace(
    '~
    [<>:"/\\|?*]|            # file system reserved https://en.wikipedia.org/wiki/Filename#Reserved_characters_and_words
    [\x00-\x1F]|             # control characters http://msdn.microsoft.com/en-us/library/windows/desktop/aa365247%28v=vs.85%29.aspx
    [\x7F\xA0\xAD]|          # non-printing characters DEL, NO-BREAK SPACE, SOFT HYPHEN
    [#\[\]@!$&\'()+,;=]|     # URI reserved https://tools.ietf.org/html/rfc3986#section-2.2
    [{}^\~`]                 # URL unsafe characters https://www.ietf.org/rfc/rfc1738.txt
    ~x',
    '-', $filename);
  // avoids ".", ".." or ".hiddenFiles"
  $filename = ltrim($filename, '.-');
  // optional beautification
  if ($beautify) $filename = beautify_filename($filename);
  // maximize filename length to 255 bytes http://serverfault.com/a/9548/44086
  $ext = pathinfo($filename, PATHINFO_EXTENSION);
  $filename = mb_strcut(pathinfo($filename, PATHINFO_FILENAME), 0, 255 - ($ext ? strlen($ext) + 1 : 0), mb_detect_encoding($filename)) . ($ext ? '.' . $ext : '');
  return $filename;
}
function beautify_filename($filename) {
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


// detect home country and set accodingly: currency, rates
if ($home === 'de') {
  $cur = " €";  // currency
  $c_b = 0.2;   // breakfast rate
  $c_l = 0.4;   // lunch rate
  $c_d = 0.4;   // dinner rate
  $c_flat = 0;  // flat rate (money which employee gets even if all meals are paid)
} elseif ($home === 'se' ) {
  $cur = " SEK";
  $c_b = 0.15;
  $c_l = 0.35;
  $c_d = 0.35;
  $c_flat = 0.15;
} elseif ($home === 'other') {
  $home_other = explode("/", $home_other);
  $cur = " " . $home_other[0];
  $c_b = $home_other[1];
  $c_l = $home_other[2];
  $c_d = $home_other[3];
  $c_flat = $home_other[4];
}

// eligible amount per day
if ($dest === 'other') {
  $dest = $dest_other;  // if other destination, just take this value
} else {
  $pattern = "/" . $home . "=([0-9.]+)?\/([0-9.]+)?/";  // define pattern something like "/de=12/24/"
  $dest = preg_match($pattern, $dest, $match, PREG_OFFSET_CAPTURE); // actually search for it
  $dest = $match[0][0]; // matches are on 2nd level inn an array
  $dest = explode('=', $dest);  // now separate at the "="
  $dest = $dest[1];   // take the second half of it "12/24"
}

// dest -> epd (half/full amount)
$epd = explode('/', $dest);  // separate at "/"
$epd_trav = $epd[0];  // first half
$epd_full = $epd[1];  // second half

// Prepare output table
if ($mailopt === "onlyme") {
  $html .= "<p><strong>ATTENTION: The email has only been sent to you, not to the financial team!</strong></p>";
} else if ($mailopt === "none") {
  $html .= "<p><strong>ATTENTION: You have configured to not send any email!</strong></p>";
}
$html .= "<p>This per diem statement is made by <strong>$who_verbose</strong>.</p>
<table class='table table-striped'>
  <tr>
    <th>Date</th>
    <th>Amount</th>
    <th>Recipient</th>
    <th>ER number</th>
    <th>Catchphrase</th>
    <th>Receipt Name</th>
    <th>Remarks</th>
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
$email->Subject     = "per diem statement by $who_verbose for $catch";
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

  // set variables
  $r_day[$d] = 0;   // reimbursement for this day

  if ($use[$d] === 'yes') { // only calculate if checkbox has been activated (day in use)
    if ($d === 'out' || $d === 'return') {  // set amount of € for travel or full day
      $eur = $epd_trav;   // total reimburseable amount for this half day
    } else {
      $eur = $epd_full;   // total reimburseable amount for this full day
    }

    // date
    if ($date[$d] === '' ) {
      $date[$d] = "Day " . $d;
    } else {
      $date[$d] = date("d.m.Y", strtotime($date[$d]));
    }
    // breakfast ($r_b)
    if ($break[$d] === "yes") {
      $r_b = $eur * $c_b;
      $r_day[$d] = $r_day[$d] + $r_b;
    }
    // lunch ($r_l)
    if ($lunch[$d] === "yes") {
      $r_l = $eur * $c_l;
      $r_day[$d] = $r_day[$d] + $r_l;
    }
    // breakfast ($r_d)
    if ($dinner[$d] === "yes") {
      $r_d = $eur * $c_d;
      $r_day[$d] = $r_day[$d] + $r_d;
    }
    // flat rate
    $r_flat = $eur * $c_flat;
    $r_day[$d] = $r_day[$d] + $r_flat;

    // add on top of total reimbursement
    $r_total = $r_total + $r_day[$d];

    // change number format of this day's amount to German (comma)
    $r_day[$d] = number_format($r_day[$d], 2, ',', '');

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
      <td>$r_day[$d]</td>
      <td></td>
      <td>$er</td>
      <td>$catch</td>
      <td>per diem</td>
      <td>$remarks[$d]</td>
    </tr>";

    // CSV for this receipt
    $csv[$key] = array($who_verbose, $date[$d], $r_day[$d], "", $er, $catch, "per diem", $remarks[$d]);

  } // if day is used
} // foreach

// Write and attach temporary CSV file
foreach ($csv as $fields) {
  fputcsv($csvfile, $fields, ';', '"', '"');
}
$email->addAttachment($csvfile_path, filter_filename("perdiem" ."-". $who ."-". $er ."-". $catch . ".csv"));

// Prepare email body
$email_body = "Hi,

This is a per diem statement by $who_verbose for
$catch (ER: $er),
sent via <https://fsfe.org/internal/pd>.

Please find the expenses attached.";

// change number format of total amount to German (comma)
$r_total = number_format($r_total, 2, ',', '');

// Finalise output table
$html .= "<tr><td><strong>Total:</strong></td><td><strong>$r_total $cur</strong></td>";
$html .= "<td colspan='5'></td></tr>";
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

$template = file_get_contents($_SERVER['REQUEST_SCHEME'] ."://". $_SERVER['HTTP_HOST'] . '/internal/pd-result.en.html', true);

echo replace_page($template, $html);

?>
