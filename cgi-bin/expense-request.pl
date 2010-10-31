#!/usr/bin/perl

use CGI;
use POSIX qw(strftime);

# -----------------------------------------------------------------------------
# List of full names
# -----------------------------------------------------------------------------

my %names = (
  "coughlan" => "Shane Coughlan",
  "gerloff" => "Karsten Gerloff",
  "gollowitzer" => "Martin Gollowitzer",
  "greve" => "Georg Greve",
  "groot" => "Adriaan de Groot",
  "grote" => "Torsten Grote",
  "harmuth" => "Stefan Harmuth",
  "holz" => "Christian Holz",
  "jensch" => "Thomas Jensch",
  "kersten" => "Rainer Kersten",
  "kekalainen" => "Otto Kekalainen",
  "kirschner" => "Matthias Kirschner",
  "klein" => "Julia Klein",
  "machon" => "Pablo Machón",
  "mierlus" => "Alina Mierlus",
  "morant" => "Benjamin Morant",
  "mueller" => "Reinhard Müller",
  "oberg" => "Jonas Öberg",
  "ohnewein" => "Patrick Ohnewein",
  "reiter" => "Bernhard Reiter",
  "roy" => "Hugo Roy",
  "sandklef" => "Henrik Sandklef",
  "weiden" => "Fernanda Weiden",
);

# -----------------------------------------------------------------------------
# List of people responsible for the projects
# -----------------------------------------------------------------------------

my %responsible = (
  "ADMIN-DUS" => "director",
  "ADMIN-TECH" => "director",
  "ADMIN-GA" => "director",
  "ADMIN-COORDINATION" => "director",
  "PA-PERSONELL" => "kirschner",
  "PA-OFFICE" => "kirschner",
  "PA-TRAVEL" => "kirschner",
  "PA-MATERIAL" => "kirschner",
  "PA-CAMPAIGNS" => "kirschner",
  "PA-GNUVOX" => "kirschner",
  "FELLOWSHIP-PERSONELL" => "kirschner",
  "FELLOWSHIP-OFFICE" => "kirschner",
  "FELLOWSHIP-MATERIAL" => "kirschner",
  "FELLOWSHIP-CONF" => "kirschner",
  "FELLOWSHIP-LOCAL" => "kirschner",
  "FTF-PERSONELL" => "coughlan",
  "FTF-OFFICE" => "coughlan",
  "FTF-TRAVEL" => "coughlan",
  "FTF-CONF" => "coughlan",
  "FTF-TRANS" => "coughlan",
  "FTF-ECONOMIC" => "coughlan",
  "POLICY-PERSONELL" => "gerloff",
  "POLICY-OFFICE" => "gerloff",
  "POLICY-CAMPAIGNS" => "gerloff",
  "POLICY-TRAVEL" => "gerloff",
  "MERCHANDISE" => "director",
);

my %account = (
  "ADMIN-DUS" => "6xxx",
  "ADMIN-TECH" => "6xxx",
  "ADMIN-GA" => "6710",
  "ADMIN-COORDINATION" => "6xxx",
  "PA-PERSONELL" => "2511",
  "PA-OFFICE" => "2512",
  "PA-TRAVEL" => "2513",
  "PA-MATERIAL" => "2514",
  "PA-CAMPAIGNS" => "2515",
  "PA-GNUVOX" => "2516",
  "FELLOWSHIP-PERSONELL" => "2521",
  "FELLOWSHIP-OFFICE" => "2522",
  "FELLOWSHIP-MATERIAL" => "2524",
  "FELLOWSHIP-CONF" => "2525",
  "FELLOWSHIP-LOCAL" => "2526",
  "FTF-PERSONELL" => "2531",
  "FTF-OFFICE" => "2532",
  "FTF-TRAVEL" => "2533",
  "FTF-CONF" => "2535",
  "FTF-TRANS" => "2536",
  "FTF-ECONOMIC" => "2537",
  "POLICY-PERSONELL" => "2541",
  "POLICY-OFFICE" => "2542",
  "POLICY-TRAVEL" => "2543",
  "POLICY-CAMPAIGNS" => "2545",
  "MERCHANDISE" => "8154",
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
my $reference = "er.$account1";
if ($budget2 ne "NONE") {
  $reference .= "/$account2";
}
$reference .= ".$date." . substr $time, -3;

my $to1 = $responsible{$budget1};
my $to2 = "";
if ($budget2 ne "NONE") {
  $to2 = $responsible{$budget2};
}

my $subject = "Expense Request $reference ($budget1";
if ($budget2 ne "NONE") {
  $subject .= "/$budget2";
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
  print MAIL "BUDGET: $budget1 $percent1\% $budget2 $percent2\%\n\n";
} else {
  print MAIL "BUDGET: $budget1\n\n";
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
print "Your request was sent. Thank you.<br /><br />";
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
