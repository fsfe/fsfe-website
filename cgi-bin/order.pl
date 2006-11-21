#!/usr/bin/perl

use CGI;
use POSIX qw(strftime);

my $query = new CGI;
my @param = $query->param;

my $date = strftime "%Y-%m-%d", localtime;
my $time = strftime "%s", localtime;
my $reference = "order." . $date . "." . substr $time, -5;

open(MAIL,"|/usr/lib/sendmail -t");
print MAIL "From: mueller\@fsfeurope.org\n";
print MAIL "To: mueller\@fsfeurope.org\n";
print MAIL "Subject: Web order\n\n";
print MAIL $reference . "\n\n";
foreach $name (@param) {
  foreach $value (@param($name)) {
    if ($value) {
      print MAIL $name . ": " . $value . "\n";
    }
  }
}
close(MAIL);

print "Location: /order/thankyou." . @param("language") . ".html\n\n";
