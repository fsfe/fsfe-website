#!/usr/bin/perl
#
# This script is used to accept registrations for the STACS project
# event "Capacity Building on Free Software" on the 2nd of november 2007.
# It is called from /project/stacs/cbfs/
# 
use CGI;
use POSIX qw(strftime);

my $query = new CGI;

# Spam bots will be tempted to fill in this actually invisible field
if ($query->param("link")) {
  die "Invalid order, possibly spam.";
}

my $date = strftime "%Y-%m-%d", localtime;
my $time = strftime "%s", localtime;
my $reference = "london.$date." . substr $time, -5;

# -----------------------------------------------------------------------------
# Calculate amount and generate mail to office
# -----------------------------------------------------------------------------

open(MAIL, "|/usr/lib/sendmail -t -f oberg\@fsfeurope.org");
print MAIL "From: web\@fsfeurope.org\n";
print MAIL "To: oberg\@fsfeurope.org\n";
print MAIL "Cc: jonas\@coyote.org\n";
print MAIL "Subject: London Registration\n";
print MAIL "Content-type: text/plain; charset=UTF-8\n";
print MAIL "Content-Transfer-Encoding: 8bit\n\n";
print MAIL "$reference\n\n";
foreach $name ($query->param) {
  $value = $query->param($name);
  if (not $name =~ /^_/ and $value) {
    print MAIL "$name: $value\n";
  }
}
close MAIL;

# -----------------------------------------------------------------------------
# Lead user to "thankyou" page
# -----------------------------------------------------------------------------

print "Content-type: text/html\n\n";
open TEMPLATE, "/home/www/html/global/projects/stacs/tmpl-london." . $query->param("language") . ".html";
while (<TEMPLATE>) {
  s/:REFERENCE:/$reference/g;
  print;
}
