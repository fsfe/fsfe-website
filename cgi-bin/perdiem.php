<?php
/***********************************************************************
*  Copyright (C) 2016 Max Mehl <max.mehl [at] fsfe [dot] org> for FSFE e.V.
************************************************************************
*  
*  This program is free software: you can redistribute it and/or modify 
*  it under the terms of the GNU Affero General Public License as 
*  published by the Free Software Foundation, either version 3 of the 
*  License, or (at your option) any later version.
*  
*  This program is distributed in the hope that it will be useful, 
*  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
*  GNU Affero General Public License for more details.
*  
*  You should have received a copy of the GNU Affero General Public 
*  License along with this program.  If not, see 
*  <http://www.gnu.org/licenses/>.
*  
************************************************************************
*  
*  This file receives input from /internal/pd.en.(x)html and calculates per 
*  diem charges for reimbursement claims. The amounts can be defined in 
*  the XHTML file. For the output of the data, it uses 
*  /internal/pd-result.en.(x)html as a template.
*  
***********************************************************************/

$output = ''; // create empty variable

// detect home country and set accodingly: currency, rates
$home = $_POST['home'];
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
}


// amount per day
$epd = $_POST['dest'];
if ($epd === 'other') {
  $epd = $_POST['dest_other'];  // if other destination, just take this value
} else {
  $pattern = "/" . $home . "=([0-9.]+)?\/([0-9.]+)?/";  // define pattern something like "/de=12/24/"
  $epd = preg_match($pattern, $epd, $match, PREG_OFFSET_CAPTURE); // actually search for it
  $epd = $match[0][0]; // matches are on 2nd level inn an array
  $epd = explode('=', $epd);  // now separate at the "="
  $epd = $epd[1];   // take the second half of it "12/24"
}

$epd = explode('/', $epd);  // separate at "/"
$epd_trav = $epd[0];  // first half
$epd_full = $epd[1];  // second hald

$output .= "<h2>Detailled overview of per diems</h2>";
$output .= "<p>Travel day(s): " . $epd_trav . $cur . " per day <br />";
$output .= "Full day(s): " . $epd_full . $cur . " per day <br />";
$output .= "Own country: " . $home . " <br />";
$output .= "Percentage rate for breakfast/lunch/dinner: " . $c_b . "/" . $c_l . "/" . $c_d . " <br />";
$output .= "Flat rate (percentage which employee gets even if all meals are paid): " . $c_flat . " <br /></p>";

$output .= '<table class="table table-striped">
  <tr>
    <th>Date</th>
    <th>Breakfast</th>
    <th>Lunch</th>
    <th>Dinner</th>
    <th>Flat reimbursement</th>
    <th>Your total reimbursement</th>
  </tr>';

$days = array('out', 1, 2, 3, 4, 5, 6, 7, 'return'); // define day range

// set variables
$r_total = 0;   // total reimbursement

foreach ($days as &$d) {  // calculate for each day
  $use[$d] = $_POST['use'][$d];
  $date[$d] = $_POST['date'][$d];
  $break[$d] = $_POST['break'][$d];
  $lunch[$d] = $_POST['lunch'][$d];
  $dinner[$d] = $_POST['dinner'][$d];
  
  // set variables
  $r_day[$d] = 0;   // reimbursement for this day
  
  
  if ($use[$d] === 'yes') { // only calculate if checkbox has been activated (day in use)
    if ($d === 'out' || $d === 'return') {  // set amount of € for travel or full day
      $eur = $epd_trav;   // total reimburseable amount for this day
      $desc = " (travel)";
    } else {
      $eur = $epd_full;   // total reimburseable amount for this day
      $desc = " (full)";
    }
    // open row
    $output .= "<tr>";
    
    // date
    if ($date[$d] === '' ) {
      $date[$d] = "Day " . $d;
    }
    $output .= "<td>" . $date[$d] . $desc . "</td>";
    
    // breakfast ($r_b)
    if ($break[$d] === "yes") {
      $r_b = $eur * $c_b;
      $r_day[$d] = $r_day[$d] + $r_b;
      $output .= "<td>yes (" . $r_b . $cur . ")</td>";
    } else {
      $output .= "<td>no</td>";
    }
    
    // lunch ($r_l)
    if ($lunch[$d] === "yes") {
      $r_l = $eur * $c_l;
      $r_day[$d] = $r_day[$d] + $r_l;
      $output .= "<td>yes (" . $r_l . $cur . ")</td>";
    } else {
      $output .= "<td>no</td>";
    }
    
    // breakfast ($r_d)
    if ($dinner[$d] === "yes") {
      $r_d = $eur * $c_d;
      $r_day[$d] = $r_day[$d] + $r_d;
      $output .= "<td>yes (" . $r_d . $cur . ")</td>";
    } else {
      $output .= "<td>no</td>";
    }
    
    // flat rate
    $r_flat = $eur * $c_flat;
    $r_day[$d] = $r_day[$d] + $r_flat;
    $output .= "<td>" . $r_flat . $cur . "</td>";
    
    // reimbursement for the single day
    $output .= "<td>" . $r_day[$d] . $cur . "</td>";
    $r_total = $r_total + $r_day[$d];
    
    // close row (day)
    $output .= "</tr>";
  
  } // if day is used
} // foreach

$output .= "<tr><td></td><td></td><td></td><td></td><td></td>";
$output .= "<td><strong>Total per diem: " . $r_total . $cur . "</strong></td></tr></table>";

/* ------------------------------------
* --- PRINT FOR COPY IN SPREADSHEET ---
* -----------------------------------*/
$output .= "<hr />";
$output .= "<h2>Spreadsheet copy&amp;paste</h2>";
$output .= "<p>The following section can be copied to your Reimbursement Claim spreadsheet. Please mark and copy the content of the table (except the headings), and paste it in your spreadsheet application.<br /><em>Hint: In LibreOffice, press Ctrl+Shift+V in order to paste it as unformatted text instead of HTML code. This avoids conflicting formatting.</em></p>";


$output .= '<table class="table">';
$output .= '<tr><th>Employee name</th><th>Date</th><th>Amount (EUR)</th><th>Recipient Name</th><th>ER number</th><th>Catchphrase</th><th>Receipt / per diem</th><th>Remarks</th></tr>';
foreach ($days as &$d) {  // calculate for each day
  if ($use[$d] === 'yes') {
    $rc_name = $_POST['rc_name'];
    $rc_er = $_POST['rc_er'];
    $rc_catch = $_POST['rc_catch'];
    
    if ($rc_name === '') { $rc_name = "YOUR-NAME"; }
    if ($rc_er === '') { $rc_er = "ER-NUMBER"; }
    if ($rc_catch === '') { $rc_catch = "CATCHPHRASE"; }
    
    $output .= "<tr>";
    
    $output .= "<td>" . $rc_name . "</td>";
    $output .= "<td>" . $date[$d] . "</td>";
    
    $r_day[$d] = preg_replace("/\./", ",", $r_day[$d]);   // replace . by , in amount to make it compatible with the used spreadsheet template
    $output .= "<td>" . $r_day[$d] . "</td>";
    
    $output .= "<td></td>";
    $output .= "<td>" . $rc_er . "</td>";
    $output .= "<td>" . $rc_catch . "</td>";
    $output .= "<td>per diem</td>";
    
    if ($break[$d] === "yes") {
      $remark[$d] = "breakfast+";
    }
    if ($lunch[$d] === "yes") {
      $remark[$d] .= "lunch+";
    }
    if ($dinner[$d] === "yes") {
      $remark[$d] .= "dinner";
    }
    if ($break[$d] != "yes" && $lunch[$d] != "yes" && $dinner[$d] != "yes") {
      $remark[$d] = "nothing";
    }
    if ($break[$d] === "yes" && $lunch[$d] === "yes" && $dinner[$d] === "yes") {
      $remark[$d] = "everything";
    }
    $remark[$d] = preg_replace("/\+$/", "", $remark[$d]);
    $remark[$d] .= " self-paid";
    
    $output .= "<td>" . $remark[$d] . "</td>";
    
    $output .= "</tr>";
  }

}

$output .= '</table>';


// --- PRINT OUTPUT IN TEMPLATE FILE ---

function replace_page($temp, $content){
    $vars = array(':RESULT:'=>$content);
    return str_replace(array_keys($vars), $vars, $temp);
}

$template = file_get_contents('http://fsfe.org/internal/pd-result.en.html', true);

echo replace_page($template, $output);

?>
