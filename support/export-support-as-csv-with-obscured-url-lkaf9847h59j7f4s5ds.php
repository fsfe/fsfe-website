<?php
// This file is temporary - now I just need so see the db contents 
// to develop email confirmation function

//die("This file is for debugging only.");

$db = new PDO("sqlite:../../../db/support.sqlite");

$query = $db->query("delete from t1 where id='2'");
$query = $db->query("delete from t1 where id='3'");
$query = $db->query("delete from t1 where id='4'");
$query = $db->query("delete from t1 where id='5'");
$query = $db->query("delete from t1 where id='6'");
$query = $db->query("delete from t1 where id='7'");
$query = $db->query("delete from t1 where id='9'");
$query = $db->query("delete from t1 where id='10'");
$query = $db->query("delete from t1 where id='13'");
$query = $db->query("delete from t1 where id='15'");
$query = $db->query("delete from t1 where id='16'");
$query = $db->query("delete from t1 where id='17'");
$query = $db->query("delete from t1 where id='18'");
$query = $db->query("delete from t1 where id='19'");
$query = $db->query("delete from t1 where id='25'");
$query = $db->query("delete from t1 where id='74'");
$query = $db->query("delete from t1 where id='82'");
$query = $db->query("delete from t1 where id='84'");
$query = $db->query("delete from t1 where id='85'");
$query = $db->query("delete from t1 where id='86'");
$query = $db->query("delete from t1 where id='87'");
$query = $db->query("delete from t1 where id='88'");
$query = $db->query("delete from t1 where id='89'");
$query = $db->query("delete from t1 where id='90'");
$query = $db->query("delete from t1 where id='91'");
$query = $db->query("delete from t1 where id='136'");
$query = $db->query("delete from t1 where id='137'");
$query = $db->query("delete from t1 where id='138'");
$query = $db->query("delete from t1 where id='139'");
$query = $db->query("delete from t1 where id='162'");
$query = $db->query("delete from t1 where id='163'");
$query = $db->query("delete from t1 where id='175'");
$query = $db->query("delete from t1 where id='182'");
$query = $db->query("delete from t1 where id='183'");
$query = $db->query("delete from t1 where id='184'");
$query = $db->query("delete from t1 where id='185'");

//$query = $db->query("alter table t1 drop column signed");
// not possible to drop columns in LiteSQL

$query = $db->query("select * from t1");

header("Content-type: text/csv");  
header("Cache-Control: no-store, no-cache");  
header('Content-Disposition: attachment; filename="supporters.csv"');

$outstream = fopen("php://output",'w'); 

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
    fputcsv($outstream, $field_names, ',', '"');  
  }
  // do stuff here with the row
  fputcsv($outstream, $row, ',', '"');  
}

fclose($outstream);

// close the database connection
$db = NULL;

?>
