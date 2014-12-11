#!/usr/bin/env perl

use 5.008;

=head1 DESCRIPTION

PDFreaders petition form processing script.

=head1 AUTHOR

Sam Tuke <mail@samtuke.com>, extending Alexander Kahl <e-user@fsfe.org>

=cut

use open ":encoding(utf8)";
use open IN => ":encoding(utf8)", OUT => ":utf8";

use Cwd qw (abs_path);
use File::Basename qw (dirname);

my $root;
BEGIN { $root = abs_path (dirname (__FILE__).'/..') };
use lib "$root/tools";

use CGI;
use DateTime;
use Template;
use WebBuild::FormValidation;
use WebBuild::DynamicContent;

use strict;
use warnings;

use constant TEMPLATE => "$root/templates/pdfreaders-petition-mail.tt2.xml";
use constant UPLOAD   => "$root/upload/pdfreaders";


# Start actual logic
my $form = WebBuild::FormValidation->new;
my $content = WebBuild::DynamicContent->new;
my $query = CGI->new;

my $lang = $query->param('lang');
if (not $lang) {$lang = "en";}
unless ($lang =~ m/^[a-z]{2}$/ and -f "$root/campaigns/pdfreaders/petition.$lang.html")
  {
    $lang = 'en';
  }
$content->layout ("$root/campaigns/pdfreaders/petition.$lang.html");

$form->validates_presence_of ('name');
$form->validates_presence_of ('surname');
$form->validates_presence_of ('country');
$form->validate_format ('email', type => 'email');

if ($form->has_errors)
  {
    $content->content ($form->get_errors);
    $content->render;
    exit;
  }
elsif ($query->param ('url')) # Bot!!
  {
    exit;
  }

# Record data here
my $template = Template->new ({ INCLUDE_PATH => "$root/templates" });

my $mail;
my $dt = DateTime->now;

my $data = { country => $query->param ('country'),
             date => sprintf ('%d-%.2d-%.2d', $dt->year, $dt->month, $dt->day),
             name => $query->param ('name'),
             surname => $query->param ('surname'),
             email => $query->param ('email'),
             group => $query->param ('group') || '',
             newsletter => $query->param ('newsletter') || '' };

$template->process ('pdfreaders-petition-mail.tt2', $data, \$mail);

open MAIL, "|/usr/lib/sendmail -t";
print MAIL $mail;
close MAIL;

my $output = <<'EOF';

<div id="flash">
  <p>Thank you for signing - your signature has been recorded, and will be added shortly.</p>
</div>

EOF

$content->content ($output);
$content->render_utf8
