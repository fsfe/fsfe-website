#!/usr/bin/perl

use CGI;
use POSIX qw(strftime);


# -----------------------------------------------------------------------------
# Get parameters
# -----------------------------------------------------------------------------

my $query = new CGI;


my $name = $query->param("name");
my $function = $query->param("function");
my $function2 = $query->param("function2");
my $radioaddress = $query->param("address");
my $otheraddress = $query->param("other_address");
my $phone = $query->param("phone");
my $mobile = $query->param("mobile");
my $fax = $query->param("fax");
my $email = $query->param("email");
my $jabber = $query->param("jabber");
my $fp = $query->param("fingerprint");
my $amount = $query->param("amount");
my $er = $query->param("er");
my $delivery = $query->param("delivery_address");


if ($function2 ne "") {
 $function .= ", $function2";
}

if ($radioaddress eq "Berlin") { $address = "Schönhauser Allee 6/7, 10119 Berlin, Germany"; }
if ($radioaddress eq "DUS") { $address = "Bilker Allee 173, 40217 Düsseldorf, Germany"; }
if ($radioaddress eq "other") {  $address = "$otheraddress"; }

if ($delivery eq "") {
 $delivery = "$address";
}


my $date = strftime "%Y-%m-%d", localtime;
my $time = strftime "%s", localtime;
my $reference = "bc.$date." . substr $time, -3;
my $subject = "Business card order $reference";


# -----------------------------------------------------------------------------
# Generate mail to office
# -----------------------------------------------------------------------------

my $boundary = "NextPart$reference";

my $replyto = "dus\@office.fsfeurope.org, $email";

open(MAIL, "|/usr/lib/sendmail -t -f $email");
print MAIL "From: $email\n";
print MAIL "Reply-To: $replyto\n";
print MAIL "Mail-Followup-To: $replyto\n";
print MAIL "To: dus\@office.fsfeurope.org\n";
print MAIL "Cc: $email\n";

print MAIL "Subject: $subject\n";
print MAIL "Mime-Version: 1.0\n";
print MAIL "Content-Type: multipart/mixed; boundary=$boundary\n";
print MAIL "Content-Transfer-Encoding: 8bit\n\n\n";

print MAIL "--$boundary\n";
print MAIL "Content-Type: text/plain; charset=utf-8\n";
print MAIL "Content-Transfer-Encoding: 8bit\n\n";

print MAIL "This business card order was sent via web interface\n\n";

print MAIL "--$boundary\n";
print MAIL "Content-Type: text/plain; charset=utf-8\n";
print MAIL "Content-Disposition: attachment; filename=$reference.txt\n";
print MAIL "Content-Description: Business card order\n";
print MAIL "Content-Transfer-Encoding: 8bit\n\n";

print MAIL "-----------------------------------------\n";
print MAIL "Form for ordering business cards\n";
print MAIL "-----------------------------------------\n\n";
print MAIL "Full name: $name\n\n";
print MAIL "Title: $function\n\n";
print MAIL "Address: $address\n\n";
print MAIL "Tel: +$phone\n\n";
print MAIL "Mobile: +$mobile\n\n";
print MAIL "Fax: +$fax\n\n";
print MAIL "E-Mail: $email\n\n";
print MAIL "XMPP: $jabber\n\n";
print MAIL "Fingerprint: $fp\n\n";
print MAIL "Number of business cards ordered: $amount\n\n";
print MAIL "Delivery Address: $delivery\n\n";

print MAIL "--$boundary--\n";

close MAIL;


# -----------------------------------------------------------------------------
# Inform user that everything was ok
# -----------------------------------------------------------------------------

print "Content-type: text/html\n\n";
print "Your order $reference was sent. Thank you.<br /><br />";

