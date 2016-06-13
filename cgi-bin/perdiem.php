<?php

$output = '';

$epd = $_POST['country']; // Euro per day
if ($epd === 'other') {
  $epd = $_POST['country_other'];
}
$epd = explode('/', $epd);
$epd_trav = $epd[0];
$epd_full = $epd[1];

$output .= "<p>Travel day(s): " . $epd_trav . " EUR per day <br />";
$output .= "Full day(s): " . $epd_full . " EUR per day</p>";

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
      $r_b = $eur * 0.2;
      $r_day = $r_day + $r_b;
      $output .= "<td>yes (" . $r_b . " €)</td>";
    } else {
      $output .= "<td>no</td>";
    }
    
    // lunch ($r_l)
    if ($lunch === "yes") {
      $r_l = $eur * 0.4;
      $r_day = $r_day + $r_l;
      $output .= "<td>yes (" . $r_l . " €)</td>";
    } else {
      $output .= "<td>no</td>";
    }
    
    // breakfast ($r_d)
    if ($dinner === "yes") {
      $r_d = $eur * 0.4;
      $r_day = $r_day + $r_d;
      $output .= "<td>yes (" . $r_d . " €)</td>";
    } else {
      $output .= "<td>no</td>";
    }
    
    // reimbursement for the single day
    $output .= "<td>" . $r_day . " €</td>";
    $r_total = $r_total + $r_day;
    
    // close row (day)
    $output .= "</tr>";
  
  } // if day is used
}

$output .= "<tr><td></td><td></td><td></td><td></td>";
$output .= "<td><strong>Total per diem: " . $r_total . " €</strong></td></tr></table>";

//------------------------------------

function replace_page($temp, $content){
    $vars = array(':RESULT:'=>$content);
    return str_replace(array_keys($vars), $vars, $temp);
}

$template = file_get_contents('http://fsfe.org/internal/pd-result.en.html', true);

echo replace_page($template, $output);

?>
