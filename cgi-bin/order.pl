#!/usr/bin/perl

use CGI;
use POSIX qw(strftime);

my $query = new CGI;

my $date = strftime "%Y-%m-%d", localtime;
my $time = strftime "%s", localtime;
my $reference = "order." . $date . "." . substr $time, -5;

open(MAIL, "|/usr/lib/sendmail -t -f mueller\@fsfeurope.org");
print MAIL "From: mueller\@fsfeurope.org\n";
print MAIL "To: mueller\@fsfeurope.org\n";
print MAIL "Subject: Web order\n\n";
print MAIL $reference . "\n\n";
foreach $name ($query->param) {
  $value = $query->param($name);
  if (not $name =~ /^_/ and $value) {
    print MAIL $name . ": " . $value . "\n";
  }
}
close(MAIL);

print "Location: /order/thankyou." . $query->param("language") . ".html\n\n";
