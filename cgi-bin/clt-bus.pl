#!/usr/bin/perl

use utf8;
use strict;
use warnings;

use File::Basename;                                                                            
use Cwd "abs_path";
use CGI;
use POSIX qw(strftime);
use Text::Wrap;
$Text::Wrap::columns = 72;

our $base_directory;
BEGIN { $base_directory = dirname(abs_path("../tools/WebBuild")); }
use lib $base_directory;

use WebBuild::FormValidation;
use WebBuild::DynamicContent;

my $form = WebBuild::FormValidation->new;
my $content = WebBuild::DynamicContent->new;
my $query = new CGI;

$form->validates_presence_of("first_name");
$form->validates_presence_of("family_name");
$form->validates_presence_of("tel_gsm");
$form->validates_format_of("email", type => "email");

$content->layout("../events/clt/clt-bus.de.html");

if ($form->has_errors) {
  $content->content($form->get_errors);
  $content->render;
  exit;
}

my $date = strftime "%Y-%m-%d", localtime;
my $time = strftime "%s", localtime;

open(MAIL, "|/usr/lib/sendmail -t -f nicoulas\@fsfe.org");
print MAIL "Reply-To: " . $query->param("email") . "\n";
print MAIL "From: office\@fsfeurope.org\n";
print MAIL "To: nicoulas\@fsfe.org\n";

my $subject = "New reservation for the CLT Bus from " . $query->param("first_name") . " " . $query->param("family_name");

print MAIL "Subject: $subject" . "\n";
print MAIL "Content-Type: text/plain; charset=UTF-8\n\n";
print MAIL "We have received a new reservation for the CLT Bus.\n\n";
print MAIL "Name:   " . $query->param("first_name") . $query->param("family_name") . "\n";
print MAIL "Phone: " . $query->param("tel_gsm") . "\n";
print MAIL "E-mail: " . $query->param("email") . "\n\n";
print MAIL "---\nInvoice address:\n";
print MAIL wrap('','',$query->param("invoice_address")) . "\n";
print MAIL "---\nComment:\n";
print MAIL wrap('','',$query->param("invoice_address")) . "\n";
print MAIL "---\n\n";

my $output = <<ENDHTML;

<div id="flash">
  <p>
    Your message was sent, and we will get in touch with you very
    soon.
  </p>
</div>

ENDHTML

$content->content($output);
$content->render;

