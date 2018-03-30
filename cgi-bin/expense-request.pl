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
  "eal" => "Erik Albers",
  "mk" => "Matthias Kirschner",
  "repentinus" => "Heiki Lohmus",
  "polina" => "Polina Malaja",
  "max.mehl" => "Max Mehl",
  "reinhard" => "Reinhard Müller",
  "jonas" => "Jonas Öberg",
  "usli" => "Ulrike Sliwinski",
);

# -----------------------------------------------------------------------------
# List of people responsible for the projects
# -----------------------------------------------------------------------------

my %responsible = (
  "PA-EVENTS" => "council",
  "PA-MATERIAL" => "council",
  "PA-CAMPAIGNS" => "council",
  "LEGAL-EVENTS" => "council",
  "LEGAL-ORG" => "council",
  "POLICY-EVENTS" => "council",
  "POLICY-CAMPAIGNS" => "council",
  "FOSS4SME-EVENTS" => "council",
  "FOSS4SME-OTHER" => "council",
  "REUSE-EVENTS" => "council",
  "REUSE-MATERIAL" => "council",
  "REUSE-OTHER" => "council",
  "MERCHANDISE-PURCHASE" => "usli",
  "MERCHANDISE-OTHER" => "usli",
  "INTERNAL-COORD" => "council",
  "INTERNAL-GA" => "council",
  "INTERNAL-TECH" => "council",
  "INTERNAL-FUNDRAISING" => "council",
  "PERSONELL-INTERN" => "council",
  "PERSONELL-KIRSCHNER" => "council",
  "PERSONELL-ALBERS" => "council",
  "PERSONELL-SLIWINSKI" => "council",
  "PERSONELL-MALAJA" => "council",
  "PERSONELL-MEHL" => "council",
  "OFFICE-BERLIN" => "usli",
);

my %account = (
  "PA-EVENTS" => "2513",
  "PA-MATERIAL" => "2514",
  "PA-CAMPAIGNS" => "2515",
  "LEGAL-EVENTS" => "2533",
  "LEGAL-ORG" => "2535",
  "POLICY-EVENTS" => "2543",
  "POLICY-CAMPAIGNS" => "2545",
  "FOSS4SME-EVENTS" => "2553",
  "FOSS4SME-OTHER" => "2550",
  "REUSE-EVENTS" => "6113",
  "REUSE-MATERIAL" => "6114",
  "REUSE-OTHER" => "6110",
  "MERCHANDISE-PURCHASE" => "8154",
  "MERCHANDISE-OTHER" => "8159",
  "INTERNAL-COORD" => "2504",
  "INTERNAL-GA" => "2505",
  "INTERNAL-TECH" => "2506",
  "INTERNAL-FUNDRAISING" => "2509",
  "PERSONELL-INTERN" => "81000",
  "PERSONELL-KIRSCHNER" => "81012",
  "PERSONELL-ALBERS" => "81021",
  "PERSONELL-SLIWINSKI" => "81036",
  "PERSONELL-MALAJA" => "81040",
  "PERSONELL-MEHL" => "81052",
  "OFFICE-BERLIN" => "82001",
);

# -----------------------------------------------------------------------------
# Get parameters
# -----------------------------------------------------------------------------

my $query = new CGI;

my $catch_phrase = $query->param("catch_phrase");
my $who = $query->param("who");
my $what = $query->param("what");
my $when = $query->param("when");
my $why = $query->param("why");
my $estimate = $query->param("estimate");
my $budget = $query->param("budget");
my $refund = $query->param("refund");

my $date = strftime("%Y-%m-%d", localtime);
my $time = strftime("%s", localtime);
my $account = $account{$budget};
my $reference = "er.$date." . substr($time, -3) . ".$account";

my $to = $responsible{$budget};
my $subject = "Expense Request $reference $catch_phrase ($budget)";

# -----------------------------------------------------------------------------
# Generate mail to responsible person
# -----------------------------------------------------------------------------

my $boundary = "NextPart$reference";

my $replyto = "finance\@fsfe.org, $to\@fsfe.org, $who\@fsfe.org";

open(MAIL, "|/usr/lib/sendmail -t -f $who\@fsfe.org");
print MAIL "From: $who\@fsfe.org\n";
print MAIL "Reply-To: $replyto\n";
print MAIL "Mail-Followup-To: $replyto\n";
print MAIL "To: $to\@fsfe.org\n";
print MAIL "CC: $who\@fsfe.org\n";
print MAIL "BCC: auto-er\@fsfeurope.org\n";
print MAIL "Subject: $subject\n";
print MAIL "Mime-Version: 1.0\n";
print MAIL "Content-Type: multipart/mixed; boundary=$boundary\n";
print MAIL "Content-Transfer-Encoding: 8bit\n\n\n";

print MAIL "--$boundary\n";
print MAIL "Content-Type: text/plain; charset=utf-8\n";
print MAIL "Content-Transfer-Encoding: 8bit\n\n";

print MAIL "WHO: $names{$who}\n\n";
print MAIL "WHAT: $what\n\n";
print MAIL "WHEN: $when\n\n";
print MAIL "WHY: $why\n\n";
print MAIL "ESTIMATE: $estimate\n\n";
print MAIL "BUDGET: $budget ($account)\n\n";
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
print "BUDGET: $budget<br />\n\n";
print "REFUND CONTACT: $refund<br />\n\n";
