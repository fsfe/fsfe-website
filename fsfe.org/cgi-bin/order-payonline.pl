#!/usr/bin/perl

use CGI;
use Digest::SHA qw(sha1_hex);

binmode(STDOUT, ":utf8");

# -----------------------------------------------------------------------------
# Get parameters
# -----------------------------------------------------------------------------

my $query = new CGI;

my $reference = $query->param("reference");
my $language = $query->param("language");
$reference =~ s/\W//g;          # Only numbers and characters to aviod cross site scripting
$language =~ s/\W//g;

my $lang = substr($language, 0, 2);
my $amount = substr($reference, 9, 3);
my $amount_f = sprintf("%.2f", $amount);

# -----------------------------------------------------------------------------
# Lead user to payment page
# -----------------------------------------------------------------------------

print "Content-type: text/html\n\n";
open TEMPLATE,'<:raw:encoding(utf-8)',
  $ENV{"DOCUMENT_ROOT"} . "/order/tmpl-thankyou." . $lang . ".html";
while (<TEMPLATE>) {
    s/:AMOUNT:/$amount_f/g;
    s/:EMAIL/$email/g;
    s/:REFERENCE:/$reference/g;
    print;
}
close TEMPLATE;
