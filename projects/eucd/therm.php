<?php
/* Copyright (C) 2002 Rodolphe Quiedeville <rodolphe@quiedeville.org>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *
 * $Id: therm.php,v 1.1 2003-02-01 10:01:45 jonas Exp $
 * $Source: /root/wrk/fsfe-web/savannah-rsync/fsfe/projects/eucd/therm.php,v $
 */

$thermlib = "thermometer.php";

if (file_exists ($thermlib))
{
  include($thermlib);

  $dons_file = "/var/run/dolibarr.don.eucd";

  /*
   * Read Values
   */

  if (file_exists ($dons_file))
    {

      $fp = fopen($dons_file, 'r' );
	  
	  
      if ($fp)
	{
	  $promesses = fgets( $fp, 10 );
	  $intent = fgets( $fp, 10 );
	  $payes = fgets( $fp, 10 );
	  fclose( $fp ); 
	}
	  
    }
  
  /* 
   * Graph thermometer
   */

  print moneyMeter($payes, $intent, $promesses);
}

?>
