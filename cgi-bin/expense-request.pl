#!/usr/bin/perl

use CGI;
use POSIX qw(strftime);

# -----------------------------------------------------------------------------
# List of full names
# -----------------------------------------------------------------------------

my %names = (
  "coughlan" => "Shane Coughlan",
  "greve" => "Georg Greve",
  "harmuth" => "Stefan Harmuth",
  "kersten" => "Rainer Kersten",
  "kirschner" => "Matthias Kirschner",
  "machon" => "Pablo Machón",
  "mueller" => "Reinhard Müller",
  "oberg" => "Jonas Öberg",
  "ohnewein" => "Patrick Ohnewein",
  "oriordan" => "Ciarán O'Riordan",
  "radulovic" => "Emil Radulovic",
  "reiter" => "Bernhard Reiter",
  "sandklef" => "Henrik Sandklef",
  "irina" => "Irina Dzhambazova"
  "irina" => "Irina Dzhambazova"
  "morant" => "Benjamin Morant"
);

# -----------------------------------------------------------------------------
# List of people responsible for the projects
# -----------------------------------------------------------------------------

my %responsible = (
  "EULEG" => "eec",
  "FELLOWSHIP" => "kirschner",
  "FTF" => "coughlan",
  "POLICY" => "greve",
  "SELF" => "oberg",
  "STACS" => "oberg",
  "AT" => "mueller",
  "DE" => "reiter",
  "ES" => "machon",
  "IT" => "ohnewein",
  "SE" => "oberg",
  "EVENTS" => "eec",
  "GA" => "eec",
  "INFRASTRUCT" => "eec",
  "MERCHANDISE" => "eec",
  "OFFICE" => "mueller",
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
my $budget = $query->param("budget");
my $refund = $query->param("refund");

my $date = strftime "%Y-%m-%d", localtime;
my $time = strftime "%s", localtime;
my $reference = "$who.$date." . substr $time, -3;

my $to = $responsible{$budget};
if ($to eq $who) {
  $to = "eec";
}

# -----------------------------------------------------------------------------
# Generate mail to responsible person
# -----------------------------------------------------------------------------

my $boundary = "NextPart$reference";

my $replyto = "dus\@office.fsfeurope.org, $who\@fsfeurope.org, $to\@fsfeurope.org";
if ($to ne "eec") {
  $replyto .= ", eec\@fsfeurope.org";
}

open(MAIL, "|/usr/lib/sendmail -t -f $to\@fsfeurope.org $who\@fsfeurope.org");
print MAIL "From: $who\@fsfeurope.org\n";
print MAIL "Reply-To: $replyto\n";
print MAIL "Mail-Followup-To: $replyto\n";
print MAIL "To: $to\@fsfeurope.org\n";
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
print MAIL "BUDGET: $budget\n\n";
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
