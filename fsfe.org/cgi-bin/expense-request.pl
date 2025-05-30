#!/usr/bin/perl
# -----------------------------------------------------------------------------
# Script for handling expense requests
# -----------------------------------------------------------------------------
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
# -----------------------------------------------------------------------------

use CGI;
use POSIX qw(strftime);

# -----------------------------------------------------------------------------
# List of full names
# -----------------------------------------------------------------------------

my %names = (
  "alex.sander" => "Alexander Sander",
  "anaghz" => "Ana Galán",
  "bonnie" => "Bonnie Mehring",
  "carmenbianca" => "Carmen Bianca Bakker",
  "dario" => "Dario Presutti",
  "eal" => "Erik Albers",
  "fi" => "Francesca Indorato",
  "floriansnow" => "Florian Snow",
  "gabriel.ku" => "Gabriel Ku Wei Bin",
  "hf" => "Henning Fehr",
  "jn" => "Johannes Näder",
  "linus" => "Linus Sehn",
  "lucas.lasota" => "Lucas Lasota",
  "marta" => "Marta Andreoli",
  "mk" => "Matthias Kirschner",
  "reinhard" => "Reinhard Müller",
  "sofiaritz" => "Sofía Aritz",
  "tobiasd" => "Tobias Diekershoff",
);

# -----------------------------------------------------------------------------
# List of people responsible for the projects
# -----------------------------------------------------------------------------

my %responsible = (
  "PA-EVENTS" => "council",
  "PA-MATERIAL" => "council",
  "PA-CAMPAIGNS" => "council",
  "PA-PODCAST" => "council",
  "LEGAL-EVENTS" => "council",
  "LEGAL-LLW" => "council",
  "POLICY-EVENTS" => "council",
  "POLICY-CAMPAIGNS" => "council",
  "POLICY-OTHER" => "council",
  "NGI0-DISCOVERY" => "council",
  "NGI0-PET" => "council",
  "NGI0-COMMON" => "council",
  "ZOOOM-MEETINGS" => "council",
  "ZOOOM-OTHER" => "council",
  "MERCHANDISE-PURCHASE" => "council",
  "MERCHANDISE-OTHER" => "council",
  "PAID-PERSONELL" => "council",
  "PAID-OTHER" => "council",
  "INTERNAL-COORD" => "council",
  "INTERNAL-GA" => "council",
  "INTERNAL-TECH" => "council",
  "INTERNAL-FUNDRAISING" => "council",
  "PERSONELL-INTERN" => "council",
  "PERSONELL-BFD" => "council",
  "PERSONELL-KIRSCHNER" => "council",
  "PERSONELL-KU" => "council",
  "PERSONELL-INDORATO" => "council",
  "PERSONELL-LASOTA" => "council",
  "PERSONELL-CEBALLOS" => "council",
  "PERSONELL-MEHRING" => "council",
  "PERSONELL-SNOW" => "council",
  "PERSONELL-GALAN" => "council",
  "PERSONELL-NAEDER" => "council",
  "PERSONELL-DIEKERSHOFF" => "council",
  "PERSONELL-PRESUTTI" => "council",
  "PERSONELL-MAISURADZE" => "council",
  "PERSONELL-PALEPU" => "council",
  "PERSONELL-FEHR" => "council",
  "PERSONELL-GORLAS" => "council",
  "OFFICE-BERLIN" => "council",
);

my %account = (
  "PA-EVENTS" => "2513",
  "PA-MATERIAL" => "2514",
  "PA-CAMPAIGNS" => "2515",
  "PA-PODCAST" => "2516",
  "LEGAL-EVENTS" => "2533",
  "LEGAL-LLW" => "6800",
  "POLICY-EVENTS" => "2543",
  "POLICY-CAMPAIGNS" => "2545",
  "POLICY-OTHER" => "2540",
  "NGI0-DISCOVERY" => "2560",
  "NGI0-PET" => "2570",
  "NGI0-COMMON" => "2580",
  "ZOOOM-MEETINGS" => "2593",
  "ZOOOM-OTHER" => "2590",
  "MERCHANDISE-PURCHASE" => "8154",
  "MERCHANDISE-OTHER" => "8159",
  "PAID-PERSONELL" => "8710",
  "PAID-OTHER" => "8711",
  "INTERNAL-COORD" => "2504",
  "INTERNAL-GA" => "2505",
  "INTERNAL-TECH" => "2506",
  "INTERNAL-FUNDRAISING" => "2509",
  "PERSONELL-INTERN" => "81000",
  "PERSONELL-BFD" => "81001",
  "PERSONELL-KIRSCHNER" => "81012",
  "PERSONELL-KU" => "81058",
  "PERSONELL-INDORATO" => "81060",
  "PERSONELL-LASOTA" => "81061",
  "PERSONELL-CEBALLOS" => "81068",
  "PERSONELL-MEHRING" => "81085",
  "PERSONELL-SNOW" => "81076",
  "PERSONELL-GALAN" => "81079",
  "PERSONELL-NAEDER" => "81081",
  "PERSONELL-DIEKERSHOFF" => "81082",
  "PERSONELL-PRESUTTI" => "81083",
  "PERSONELL-MAISURADZE" => "81084",
  "PERSONELL-PALEPU" => "81086",
  "PERSONELL-FEHR" => "81087",
  "PERSONELL-GORLAS" => "81089",
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

my $replyto = "finance\@fsfe.org, $to\@fsfe.org, $who\@fsfe.org, er-archive\@lists.fsfe.org";

open(MAIL, "|/usr/lib/sendmail -t -f $who\@fsfe.org");
print MAIL "From: $who\@fsfe.org\n";
print MAIL "Reply-To: $replyto\n";
print MAIL "Mail-Followup-To: $replyto\n";
print MAIL "To: $to\@fsfe.org\n";
print MAIL "CC: er-archive\@lists.fsfe.org, $who\@fsfe.org\n";
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

print "Content-type: text/html; charset=utf-8\n\n";
print "Your request $reference was sent. Thank you.<br/><br/>";
print "WHO: $names{$who}<br/>\n\n";
print "WHAT: $what<br/>\n\n";
print "WHEN: $when<br/>\n\n";
print "WHY: $why<br/>\n\n";
print "ESTIMATE: $estimate<br/>\n\n";
print "BUDGET: $budget<br/>\n\n";
print "REFUND CONTACT: $refund<br/>\n\n";
