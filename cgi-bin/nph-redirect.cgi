#! /usr/bin/perl
use CGI;

if ($ENV{HTTP_REFERER} !~ /\.fsfeurope\.org/) {
 print "HTTP/1.0 403 Forbidden\n";
 print "Content-type: text/html\n\n";
 print "Permission denied for referer $ENV{HTTP_REFERER}.\n";
 exit 0;
}

my $q = new CGI;

print "HTTP/1.0 301 Moved\n";
print "Content-type: text/html\n";
print "Location: ".$q->param('address')."\n\n";
exit 0;
