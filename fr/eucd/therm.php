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
 * $Id: therm.php,v 1.2 2002-12-21 15:09:34 rodolphe Exp $
 * $Source: /root/wrk/fsfe-web/savannah-rsync/fsfe/fr/eucd/therm.php,v $
 */

$thermlib = "thermometer.php";

if (file_exists ($thermlib))
{
  include($thermlib);

  $posten_file = "posten.txt";
  $totaal_file = "totaal.txt";


  /*
   * Read Values
   */

  if (file_exists ($posten_file))
    {
      if (file_exists ($totaal_file))
	{

	  /* lees posten uit file */
	  $fp = fopen($posten_file, 'r' );
	  
	  
	  if ($fp)
	    {
	      $post_donaties = fgets( $fp, 10 );
	      $post_sponsoring = fgets( $fp, 10 );
	      $post_intent = fgets( $fp, 10 );
	      fclose( $fp ); 
	    }
	  
	  /* lees posten uit file  */
	  $fp = fopen( $totaal_file, 'r' );
	  if ($fp)
	    {
	      $totaal_ontvangen = fgets( $fp, 10 );
	      $totaal_pending = fgets( $fp, 10 );
	      fclose( $fp ); 
	    }
	}
    }
  
  /* 
   * Graph thermometer
   */

  print moneyMeter($totaal_ontvangen+$post_donaties+$post_sponsoring, $totaal_pending, $post_intent);
}

?>
