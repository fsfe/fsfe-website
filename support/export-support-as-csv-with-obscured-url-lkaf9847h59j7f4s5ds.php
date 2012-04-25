<?php
// This file is temporary - now I just need so see the db contents 
// to develop email confirmation function

$db = new PDO("sqlite:../../../db/support.sqlite");
$query = $db->query("select * from t1");

$outstream = fopen("php://output",'w'); 
header("Content-type: text/csv");  
header("Cache-Control: no-store, no-cache");  
header('Content-Disposition: attachment; filename="supporters.csv"');


$first_row = true;
while ($row = $query->fetch(PDO::FETCH_ASSOC))
{
  if ($first_row)
  {
    // I'm not sure how to get the field names using a PDO method but
    // we can use the first row's (or any row's) key values as these
    // are the field names.
    $first_row = false;
    $number_of_fields = count($row);
    $field_names = array_keys($row);
    $first_field_name = $field_names[0];
  }
  // do stuff here with the row
  fputcsv($outstream, $row, ',', '"');  
}

fclose($outstream);

?>
