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
 * $Id: therm.php,v 1.1 2002-12-21 14:58:54 rodolphe Exp $
 * $Source: /root/wrk/fsfe-web/savannah-rsync/fsfe/fr/eucd/therm.php,v $
 */

if (file_exists ("thermometer.php"))
{
  include("thermometer.php");
  print moneyMeter($totaal_ontvangen+$post_donaties+$post_sponsoring, $totaal_pending, $post_intent,"posten.txt", "totaal.txt");
}

?>
