<?php
/*
Copyright (C) 2012 Otto Kekäläinen <otto@fsfe.org> for Free Software Foundation Europe

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the 
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

// This file is temporary - now I just need so see the db contents 
// to develop email confirmation function

die("This file is for debugging only.");

$db = new PDO("sqlite:../../../db/support.sqlite");

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
