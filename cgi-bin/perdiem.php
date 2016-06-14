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
  $cur = " €";
  $c_b = 0.2;
  $c_l = 0.4;
  $c_d = 0.4;
} elseif ($home === 'se' ) {
  $cur = " SEK";
  $c_b = 0.15;
  $c_l = 0.35;
  $c_d = 0.35;
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

$output .= "<p>Travel day(s): " . $epd_trav . $cur . " per day <br />";
$output .= "Full day(s): " . $epd_full . $cur . " per day <br />";
$output .= "Own country: " . $home . " <br />";
$output .= "Percentage rate for breakfast/lunch/dinner: " . $c_b . "/" . $c_l . "/" . $c_d . " <br /></p>";

$output .= '<table class="table table-striped">
  <tr>
    <th>Date</th>
    <th>Breakfast</th>
    <th>Lunch</th>
    <th>Dinner</th>
    <th>Your Reimbursement</th>
  </tr>';

$days = array('out', 1, 2, 3, 4, 5, 6, 7, 'return');

// set variables
$r_total = 0;   // total reimbursement

foreach ($days as &$day) {  // calculate for each day
  $use = $_POST['use'][$day];
  $date = $_POST['date'][$day];
  $break = $_POST['break'][$day];
  $lunch = $_POST['lunch'][$day];
  $dinner = $_POST['dinner'][$day];
  
  // set variables
  $r_day = 0;
  
  
  if ($use === 'yes') { // only calculate if checkbox has been activated (day in use)
    if ($day === 'out' || $day === 'return') {  // set amount of € for travel or full day
      $eur = $epd_trav;
      $desc = " (travel)";
    } else {
      $eur = $epd_full;
      $desc = " (full)";
    }
    // open row
    $output .= "<tr>";
    
    // date
    if ($date === '' ) {
      $date = "Day " . $day;
    }
    $output .= "<td>" . $date . $desc . "</td>";
    
    // breakfast ($r_b)
    if ($break === "yes") {
      $r_b = $eur * $c_b;
      $r_day = $r_day + $r_b;
      $output .= "<td>yes (" . $r_b . $cur . ")</td>";
    } else {
      $output .= "<td>no</td>";
    }
    
    // lunch ($r_l)
    if ($lunch === "yes") {
      $r_l = $eur * $c_l;
      $r_day = $r_day + $r_l;
      $output .= "<td>yes (" . $r_l . $cur . ")</td>";
    } else {
      $output .= "<td>no</td>";
    }
    
    // breakfast ($r_d)
    if ($dinner === "yes") {
      $r_d = $eur * $c_d;
      $r_day = $r_day + $r_d;
      $output .= "<td>yes (" . $r_d . $cur . ")</td>";
    } else {
      $output .= "<td>no</td>";
    }
    
    // reimbursement for the single day
    $output .= "<td>" . $r_day . $cur . "</td>";
    $r_total = $r_total + $r_day;
    
    // close row (day)
    $output .= "</tr>";
  
  } // if day is used
}

$output .= "<tr><td></td><td></td><td></td><td></td>";
$output .= "<td><strong>Total per diem: " . $r_total . $cur . "</strong></td></tr></table>";

//------------------------------------

function replace_page($temp, $content){
    $vars = array(':RESULT:'=>$content);
    return str_replace(array_keys($vars), $vars, $temp);
}

$template = file_get_contents('http://fsfe.org/internal/pd-result.en.html', true);

echo replace_page($template, $output);

?>
