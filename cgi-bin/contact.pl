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

$form->validates_presence_of("name");
$form->validates_format_of("email", type => "email");
$form->validates_length_of("message", min => 5, max => 2500);

$content->layout("../contact/contact.en.html");
 
if ($form->has_errors) {
  $content->content($form->get_errors);
  $content->render;
  exit;
}

my $date = strftime "%Y-%m-%d", localtime;
my $time = strftime "%s", localtime;

open(MAIL, "|/usr/lib/sendmail -t -f ato\@fsfe.org");
print MAIL "Reply-To: " . $query->param("email") . "\n";
print MAIL "From: office\@fsfeurope.org\n";
print MAIL "To: office\@fsfeurope.org,nicoulas\@fsfe.org\n";
print MAIL "Cc: ato\@fsfe.org\n";

my $subject = $query->param("subject");
if ($subject eq "") {
  $subject = "New message from website from " . $query->param("name");
}

print MAIL "Subject: $subject" . "\n";
print MAIL "Content-Type: text/plain; charset=UTF-8\n\n";
print MAIL "We have received a new message from our website contact form.\n\n";
print MAIL "Name:   " . $query->param("name") . "\n";
print MAIL "E-mail: " . $query->param("email") . "\n\n";
print MAIL "---\n";
print MAIL wrap('','',$query->param("message")) . "\n";
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

