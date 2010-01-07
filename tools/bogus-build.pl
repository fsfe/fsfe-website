#! /usr/bin/env perl
#
# bogus-build.pl - a tool for building web pages locally from the
#                  Free Software Foundation Europe sources
#
# Copyright 2010 Free Software Foundation Europe <team@fsfeurope.org>
#     Author: Adriaan de Groot <groot@fsfeurope.org>
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  
# 02110-1301, USA.
#


print<<EOF;
<?xml version="1.0" encoding="iso-8859-1" ?>

<buildinfo original="en" filename="$filename" language="en" outdated="no">
  <trlist>            <!-- All translations that this page exists in -->
    <tr id="en">English</tr>
  </trlist>
  <menuset>           <!-- The menu items for the right hand bar -->
     <menu id="menu/about">/about/about.html</menu>
  </menuset>
  <textset>           <!-- The static text set for this language -->
     <text id="menu/about">About</text>
  </textset>
  <webset root="http://www.fsfeurope.org">
  </webset>

  <document language="en">
EOF

while(<>) {
	last if /<html>/;
}
while(<>) {
	last if /<\/html>/;
	print;
}

print<<EOF;
  </document>
</buildinfo>
EOF


