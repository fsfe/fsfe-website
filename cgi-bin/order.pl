#!/usr/bin/perl

use CGI;

$query = new CGI;

open(MAIL,"|/usr/lib/sendmail -t");
print MAIL "From: mueller\@fsfeurope.org\n";
print MAIL "To: mueller\@fsfeurope.org\n";
print MAIL "Subject: Web order\n\n";
foreach $name ($query->param) {
  foreach $value ($query->param($name)) {
    if ($value) {
      print MAIL $name.": ".$value."\n";
    }
  }
}
close(MAIL);

print "Location: /order/thankyou.en.html\n\n";
