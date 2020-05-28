<?php

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;
use PHPMailer\PHPMailer\SMTP;

require 'PHPMailer/Exception.php';
require 'PHPMailer/PHPMailer.php';
require 'PHPMailer/SMTP.php';

$html = ''; // create empty variable
$csv = array(array("Employee name", "Date", "Amount (EUR)", "Recipient name", "ER number", "Catchphrase", "Receipt name", "Remarks")); // create array for CSV
$csvfile = tmpfile();
$csvfile_path = stream_get_meta_data($csvfile)['uri'];

$who = isset($_POST["who"]) ? $_POST["who"] : false;
$type = isset($_POST["type"]) ? $_POST["type"] : false;
$rc_month = isset($_POST["rc_month"]) ? $_POST["rc_month"] : false;
$rc_year = isset($_POST["rc_year"]) ? $_POST["rc_year"] : false;
$cc_month = isset($_POST["cc_month"]) ? $_POST["cc_month"] : false;
$cc_year = isset($_POST["cc_year"]) ? $_POST["cc_year"] : false;
$entry = isset($_POST["entry"]) ? $_POST["entry"] : false; // will become $date in loop
$amount = isset($_POST["amount"]) ? $_POST["amount"] : false;
$recipient = isset($_POST["recipient"]) ? $_POST["recipient"] : false;
$er = isset($_POST["er"]) ? $_POST["er"] : false;
$catch = isset($_POST["catch"]) ? $_POST["catch"] : false;
$receipt = isset($_POST["receipt"]) ? $_POST["receipt"] : false;
$remarks = isset($_POST["remarks"]) ? $_POST["remarks"] : false;
$extra = isset($_POST["extra"]) ? $_POST["extra"] : false;

// create empty arrays for uploaded file
$receipt_dest = [];


// FUNCTIONS
function td($input) {
  return "<td>$input</td>";
}

// Sanity checks
if ($type == "rc") {
  if ( ! $rc_month || ! $rc_year ) {
    exit("You must provide month and year of the RC");
  }
  $type_verbose = "Reimbursement Claim";
  $type_date = "$rc_year-$rc_month";
} else if ($type == "cc") {
  if ( ! $cc_month || ! $cc_year ) {
    exit("You must provide quarter and year of the CC statement");
  }
  $type_verbose = "Credit Card Statement";
  $type_date = "$cc_year-$cc_month";
} else {
  exit("You must provide a reimbursement type");
}

// Prepare output table
$html .= "<p>This <strong>$type_verbose</strong> is made by <strong>$who</strong>.</p>
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
$email->SetFrom($who . "@fsfe.org", "$who");
$email->Subject     = "$type_verbose for $type_date by $who";
$email->addAddress($who . "@fsfe.org");

foreach ($entry as $key => $date) {  // calculate for each entry
  $receipt_tmp = $_FILES["receipt"]["tmp_name"][$key];
  $receipt_error = $_FILES["receipt"]["error"][$key];
  $receipt_name = basename($_FILES["receipt"]["name"][$key]);
  $receipt_size = $_FILES["receipt"]["size"][$key];
  $receipt_no = $key + 1;

  if (! $receipt_tmp) {
    exit("Something with $receipt_name went wrong, it has not been uploaded.");
  }

  if ($receipt_size > 2097152) {
    exit("File size of $receipt_name must not be larger than 2MB");
  }

  $receipt_mime = mime_content_type($receipt_tmp);
  if(! in_array($receipt_mime, array('image/jpeg', 'image/png', 'application/pdf'))) {
    exit("Only PDF, JPG and PNG allowed. $receipt_name has $receipt_mime");
  }

  $receipt_ext = pathinfo($receipt_name)['extension'];
  $receipt_rename = $type ."-". $type_date ."-". $who ."-receipt". $receipt_no ."-". $er[$key] .".". "$receipt_ext";
  $receipt_dest[$key] = "/tmp/" . $receipt_rename;

  if ($receipt_error == UPLOAD_ERR_OK) {
    if ( ! move_uploaded_file($receipt_tmp, $receipt_dest[$key]) ) {
      exit("Could not move uploaded file '".$receipt_tmp."' to '".$receipt_dest."'<br/>\n");
    }
  } else {
    exit("Upload error. [".$receipt_error."] on file '".$receipt_name."'<br/>\n");
  }

  // HTML output
  $html .= "
  <tr>
    <td>$date</td>
    <td>$amount[$key]</td>
    <td>$recipient[$key]</td>
    <td>$er[$key]</td>
    <td>$catch[$key]</td>
    <td>$receipt_rename</td>
    <td>$remarks[$key]</td>
  </tr>";

  // CSV
  $csv[$receipt_no] = array($who, $date, $amount[$key], $recipient[$key], $er[$key], $catch[$key], $receipt_rename, $remarks[$key]);

  // Email

  $email->addAttachment($receipt_dest[$key], basename($receipt_dest[$key]));
} // foreach

// Write and attach temporary CSV file
foreach ($csv as $fields) {
  fputcsv($csvfile, $fields, ',', '"', '"');
}
$email->addAttachment($csvfile_path, $type ."-". $type_date ."-". $who . ".csv");

// Prepare email body
$email_body = "Hi,

This is a $type_verbose for $type_date by $who,
sent via <https://fsfe.org/internal/rc>.

Please find the expenses and their receipts attached.";

// Finalise output table
$html .= "</table>";
if ($extra) {
  $html .= "<p>Extra remarks: <br />$extra</p>";

  $email_body .= "
  
The sender added the following comment:

$extra";
}

// Send email, and delete attachments
$email->Body = $email_body;
$email->send();
$html .= $email->ErrorInfo;
foreach ($receipt_dest as $receipt) {
  unlink($receipt);
}
fclose($csvfile);

// --- PRINT OUTPUT IN TEMPLATE FILE ---

function replace_page($temp, $content){
    $vars = array(':RESULT:'=>$content);
    return str_replace(array_keys($vars), $vars, $temp);
}

$template = file_get_contents($_SERVER['REQUEST_SCHEME'] ."://". $_SERVER['HTTP_HOST'] . '/internal/rc-result.en.html', true);

echo replace_page($template, $html);

?>
