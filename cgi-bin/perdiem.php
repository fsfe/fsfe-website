<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<title>VKP calculator</title>
</head>
<body>

<?php

$epd = $_POST['country']; // Euro per day
$epd = explode('/', $epd);
$epd_trav = $epd[0];
$epd_full = $epd[1];

echo "<p>Travel day(s): " . $epd_trav . " EUR per day <br />";
echo "Full day(s): " . $epd_full . " EUR per day</p>";

?>

<table class="table table-striped">
  <tr>
    <th>Date</th>
    <th>Breakfast paid</th>
    <th>Lunch paid</th>
    <th>Dinner paid</th>
    <th>Your Reimbursement</th>
  </tr>

<?php

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
    echo "<tr>";
    
    // date
    echo "<td>" . $date . $desc . "</td>";
    
    // breakfast ($r_b)
    if ($break === "yes") {
      $r_b = $eur * 0.2;
      $r_day = $r_day + $r_b;
      echo "<td>yes (" . $r_b . " €)</td>";
    } else {
      echo "<td>no</td>";
    }
    
    // lunch ($r_l)
    if ($lunch === "yes") {
      $r_l = $eur * 0.4;
      $r_day = $r_day + $r_l;
      echo "<td>yes (" . $r_l . " €)</td>";
    } else {
      echo "<td>no</td>";
    }
    
    // breakfast ($r_d)
    if ($dinner === "yes") {
      $r_d = $eur * 0.4;
      $r_day = $r_day + $r_d;
      echo "<td>yes (" . $r_d . " €)</td>";
    } else {
      echo "<td>no</td>";
    }
    
    // reimbursement for the single day
    echo "<td>" . $r_day . " €</td>";
    $r_total = $r_total + $r_day;
    
    // close row (day)
    echo "</tr>";
  
  } // if day is used
}

echo "<tr><td></td><td></td><td></td><td></td>";
echo "<td><strong>Total VKP: " . $r_total . " €</strong></td></tr>";

?>


</table>

</body>
</html>
