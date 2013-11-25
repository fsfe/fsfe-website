#!/usr/bin/perl
#
# Script for handling expense requests
# Copyright (C) Free Software Foundation Europe e.V.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>


use CGI;
use POSIX qw(strftime);

# -----------------------------------------------------------------------------
# List of full names
# -----------------------------------------------------------------------------

my %names = (
  "albers" => "Erik Albers",
  "gerloff" => "Karsten Gerloff",
  "harmuth" => "Stefan Harmuth",
  "kersten" => "Rainer Kersten",
  "kirschner" => "Matthias Kirschner",
  "kekalainen" => "Otto Kekäläinen", 
  "morris" => "Anna Morris",
  "mueller" => "Reinhard Müller",
  "roy" => "Hugo Roy",
  "sandklef" => "Henrik Sandklef",
  "suklje" => "Matija Šuklje",
  "tuke" => "Sam Tuke",
);

# -----------------------------------------------------------------------------
# List of people responsible for the projects
# -----------------------------------------------------------------------------

my %responsible = (
  "ADMIN-PERSONELL" => "gerloff",
  "ADMIN-OFFICE" => "gerloff",
  "ADMIN-TRAVEL" => "gerloff",
  "ADMIN-COORDINATION" => "gerloff",
  "ADMIN-GA" => "gerloff",
  "ADMIN-TECH" => "gerloff",
  "ADMIN-FUNDRAISING" => "gerloff",
  "PA-PERSONELL" => "kirschner",
  "PA-OFFICE" => "kirschner",
  "PA-TRAVEL" => "kirschner",
  "PA-MATERIAL" => "kirschner",
  "PA-CAMPAIGNS" => "kirschner",
  "FELLOWSHIP-PERSONELL" => "kirschner",
  "FELLOWSHIP-MATERIAL" => "kirschner",
  "FELLOWSHIP-CONF" => "kirschner",
  "FELLOWSHIP-LOCAL" => "kirschner",
  "LEGAL-PERSONELL" => "suklje",
  "LEGAL-OFFICE" => "suklje",
  "LEGAL-TRAVEL" => "suklje",
  "LEGAL-CONF" => "suklje",
  "LEGAL-COMPLIANCE" => "suklje",
  "POLICY-PERSONELL" => "gerloff",
  "POLICY-OFFICE" => "gerloff",
  "POLICY-TRAVEL" => "gerloff",
  "MERCHANDISE-PURCHASE" => "gerloff",
  "MERCHANDISE-SHIPPING" => "gerloff",
);

my %account = (
  "ADMIN-PERSONELL" => "2501",
  "ADMIN-OFFICE" => "2502",
  "ADMIN-TRAVEL" => "2503",
  "ADMIN-COORDINATION" => "2504",
  "ADMIN-GA" => "2505",
  "ADMIN-TECH" => "2506",
  "ADMIN-FUNDRAISING" => "2507",
  "PA-PERSONELL" => "2511",
  "PA-OFFICE" => "2512",
  "PA-TRAVEL" => "2513",
  "PA-MATERIAL" => "2514",
  "PA-CAMPAIGNS" => "2515",
  "FELLOWSHIP-PERSONELL" => "2521",
  "FELLOWSHIP-MATERIAL" => "2524",
  "FELLOWSHIP-CONF" => "2525",
  "FELLOWSHIP-LOCAL" => "2526",
  "LEGAL-PERSONELL" => "2531",
  "LEGAL-OFFICE" => "2532",
  "LEGAL-TRAVEL" => "2533",
  "LEGAL-CONF" => "2535",
  "LEGAL-COMPLIANCE" => "2536",
  "POLICY-PERSONELL" => "2541",
  "POLICY-OFFICE" => "2542",
  "POLICY-TRAVEL" => "2543",
  "MERCHANDISE-PURCHASE" => "8154",
  "MERCHANDISE-SHIPPING" => "8159",
);

# -----------------------------------------------------------------------------
# Get parameters
# -----------------------------------------------------------------------------

my $query = new CGI;

my $who = $query->param("who");
my $what = $query->param("what");
my $when = $query->param("when");
my $why = $query->param("why");
my $estimate = $query->param("estimate");
my $budget1 = $query->param("budget1");
my $percent1 = $query->param("percent1");
my $budget2 = $query->param("budget2");
my $percent2 = $query->param("percent2");
my $refund = $query->param("refund");

my $date = strftime "%Y-%m-%d", localtime;
my $time = strftime "%s", localtime;
my $account1 = $account{$budget1};
my $account2 = "";
if ($budget2 ne "NONE") {
  $account2 = $account{$budget2};
}
my $reference = "er.$date." . substr $time, -3;
$reference .= ".$account1";
if ($budget2 ne "NONE") {
  $reference .= "+$account2";
}

my $to1 = $responsible{$budget1};
my $to2 = "";
if ($budget2 ne "NONE") {
  $to2 = $responsible{$budget2};
}

my $subject = "Expense Request $reference ($budget1";
if ($budget2 ne "NONE") {
  $subject .= "+$budget2";
}
$subject .= ")";

# -----------------------------------------------------------------------------
# Generate mail to responsible person
# -----------------------------------------------------------------------------

my $boundary = "NextPart$reference";

my $replyto = "dus\@office.fsfeurope.org, $who\@fsfeurope.org, $to1\@fsfeurope.org";
if ($budget2 ne "NONE") {
  $replyto .= ", $to2\@fsfeurope.org";
}
$replyto .= ", council\@fsfeurope.org";

open(MAIL, "|/usr/lib/sendmail -t -f $who\@fsfeurope.org");
print MAIL "From: $who\@fsfeurope.org\n";
print MAIL "Reply-To: $replyto\n";
print MAIL "Mail-Followup-To: $replyto\n";
if ($budget2 ne "NONE") {
  print MAIL "To: $to1\@fsfeurope.org, $to2\@fsfeurope.org\n";
} else {
  print MAIL "To: $to1\@fsfeurope.org\n";
}
print MAIL "CC: $who\@fsfeurope.org\n";
print MAIL "Subject: $subject\n";
print MAIL "Mime-Version: 1.0\n";
print MAIL "Content-Type: multipart/mixed; boundary=$boundary\n";
print MAIL "Content-Transfer-Encoding: 8bit\n\n\n";

print MAIL "--$boundary\n";
print MAIL "Content-Type: text/plain; charset=utf-8\n";
print MAIL "Content-Transfer-Encoding: 8bit\n\n";

print MAIL "This expense request was sent via web interface\n\n";

print MAIL "--$boundary\n";
print MAIL "Content-Type: text/plain; charset=utf-8\n";
print MAIL "Content-Disposition: attachment; filename=$reference.txt\n";
print MAIL "Content-Description: Expense Request\n";
print MAIL "Content-Transfer-Encoding: 8bit\n\n";

print MAIL "WHO: $names{$who}\n\n";
print MAIL "WHAT: $what\n\n";
print MAIL "WHEN: $when\n\n";
print MAIL "WHY: $why\n\n";
print MAIL "ESTIMATE: $estimate\n\n";
if ($budget2 ne "NONE") {
  print MAIL "BUDGET: $budget1 ($account1) $percent1\% $budget2 ($account2) $percent2\%\n\n";
} else {
  print MAIL "BUDGET: $budget1 ($account1)\n\n";
}
print MAIL "REFUND CONTACT: $refund\n\n";
print MAIL "AUTHORISED:\n\n";
print MAIL "BY:\n\n";

print MAIL "--$boundary--\n";
                      
close MAIL;

# -----------------------------------------------------------------------------
# Inform user that everything was ok
# -----------------------------------------------------------------------------

print "Content-type: text/html\n\n";
print "Your request $reference was sent. Thank you.<br /><br />";
print "WHO: $names{$who}<br />\n\n";
print "WHAT: $what<br />\n\n";
print "WHEN: $when<br />\n\n";
print "WHY: $why<br />\n\n";
print "ESTIMATE: $estimate<br />\n\n";
if ($budget2 ne "NONE") {
  print "BUDGET: $budget1 $percent1\% $budget2 $percent2\%<br />\n\n";
} else {
  print "BUDGET: $budget1<br />\n\n";
}
print "REFUND CONTACT: $refund<br />\n\n";
