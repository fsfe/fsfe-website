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

#   <input size="35" name="first_name" type="text">
#   <input size="35" name="family_name" type="text"> 
#   <input size="5" name="fellowship_no" type="text">
#   <select size="3" name="room">
#     <option>Doppelzimmer, Kat.1, 40,- EUR pro Nacht</option>
#     <option>Einzelzimmer, Kat.1, 30,- EUR pro Nacht</option>
#     <option>Doppelzimmer, Kat.3, 30,- EUR pro Nacht</option>
#     <option>Einzelzimmer, Kat.3, 22,- EUR pro Nacht</option>
#   </select>
# 
#   <input size="35" name="second_bed_name" type="text">
# 
#   <input name="like_to_share" value="yes" type="checkbox">
#   <input name="sponsor_second_bed" value="yes" type="checkbox">
# 
#   <input name="breakfast_sa" value="yes" type="checkbox">
#   <input name="breakfast_sa_no" value="yes" type="checkbox">
#   <input name="breakfast_su" value="yes" type="checkbox">
#   <input name="breakfast_su_no" value="yes" type="checkbox">
# 
#   <textarea cols="35" rows="5" name="invoice_address">      </textarea>
# 
#   <input size="35" name="tel_gsm" type="text"> 
#   <input size="35" name="email" type="text"> 
# 
#   <textarea cols="60" rows="5" name="comment">      </textarea>
# 
# <input name="send" value="Daten absenden" type="submit">

$form->validates_presence_of("first_name");
$form->validates_presence_of("family_name");
$form->validates_format_of("email", type => "email");

$content->layout("../events/clt/clt-hotel.de.html");

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

my $subject = "New reservation for the CLT Hotel from " . $query->param("first_name") . " " . $query->param("family_name");

print MAIL "Subject: $subject" . "\n";
print MAIL "Content-Type: text/plain; charset=UTF-8\n\n";
print MAIL "We have received a new reservation for the CLT Bus.\n\n";
print MAIL "Name:   " . $query->param("first_name") . $query->param("family_name") . "(Fellowhsip Nummer: " . $query->param("fellowship_no") . ")\n";
print MAIL "Phone: " . $query->param("tel_gsm") . "\n";
print MAIL "E-mail: " . $query->param("email") . "\n\n";
print MAIL "Room: " . $query->param("room") . "\n";
print MAIL "---\nDoppelzimmer?\n";
print MAIL "Second bed name: " . $query->param("second_bed_name") . "\n";
print MAIL "Like to share?: " . $query->param("like_to_share") . "\n";
print MAIL "Sponsor second bed: " . $query->param("sponsor_second_bed") . "\n";
print MAIL "Breakfast Samstag?: " . $query->param("breakfast_sa") . "\n";
print MAIL "Breakfast Samstag number: " . $query->param("breakfast_sa_no") . "\n";
print MAIL "Breakfast Samstag?: " . $query->param("breakfast_su") . "\n";
print MAIL "Breakfast Samstag?: " . $query->param("breakfast_su_no") . "\n";
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

