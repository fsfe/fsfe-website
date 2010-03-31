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
  "kirschner" => "Matthias Kirschner",
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
  "PA-MATERIAL" => "director",
  "PA-TRAVEL" => "director",
  "PA-GNUVOX" => "director",
  "FELLOWSHIP-MATERIAL" => "kirschner",
  "FELLOWSHIP-CONF" => "kirschner",
  "FELLOWSHIP-LOCAL" => "kirschner",
  "FELLOWSHIP-OFFICE" => "kirschner",
  "FTF-ZRH" => "groot",
  "FTF-TRAVEL" => "groot",
  "FTF-CONF" => "groot",
  "FTF-TRANS" => "groot",
  "FTF-ECONOMIC" => "groot",
  "POLICY-CAMPAIGNS" => "gerloff",
  "POLICY-TRAVEL" => "gerloff",
  "MERCHANDISE" => "director",
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
my $reference = "$who.$date." . substr $time, -3;

my $to1 = $responsible{$budget1};
my $to2 = "";
if ($budget2 ne "NONE") {
  $to2 = $responsible{$budget2};
}

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
print MAIL "Cc: director\@fsfeurope.org\n";
print MAIL "Subject: Expense Request\n";
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
print "Your request was sent. Thank you.";
