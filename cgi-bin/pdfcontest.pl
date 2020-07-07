#!/usr/bin/env perl

use 5.008;

=head1 DESCRIPTION

PDFreaders campaign "Commercials on Public websites" form processing script.

=head1 AUTHOR

Alexander Kahl <e-user@fsfe.org>

=cut

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

use constant TEMPLATE => "$root/templates/pdfcontest.tt2.xml";
use constant UPLOAD   => "$root/upload/pdfreaders";


# Start actual logic
my $form = WebBuild::FormValidation->new;
my $content = WebBuild::DynamicContent->new;
my $query = CGI->new;
$content->layout ("$root/activities/pdfreaders/bug-report-uk.en.html");

$form->validates_presence_of ('institution-name');
$form->validates_presence_of ('institution-country');
$form->validate_format ('institution-url', type => 'url');
$form->validates_presence_of ('institution-address');
$form->validates_presence_of ('name');
$form->validate_format ('email', type => 'email');
# Group, Comment are optional

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
my $data = { institution_name => $query->param ('institution-name'),
             institution_country => $query->param ('institution-country'),
             institution_address => $query->param ('institution-address'),
             institution_email => $query->param ('institution-email'),
             institution_url => $query->param ('institution-url'),
             opened => sprintf ('%d-%.2d-%.2d', $dt->year, $dt->month, $dt->day),
             name => $query->param ('name'),
             email => $query->param ('email'),
             group => $query->param ('group') || '',
             petition => $query->param ('petition'),
             newsletter => $query->param ('newsletter'),
             contact => $query->param ('contact'),
             comment => $query->param ('comment') || '' };

$template->process ('pdfreaders-mail.tt2', $data, \$mail);

open MAIL, "|/usr/lib/sendmail -t -f web\@lists.fsfe.org";
print MAIL $mail;
close MAIL;

my $output = <<'EOF';

<div id="flash">
  <p>All data recorded, we will get in touch with you very soon.</p>
</div>

EOF

$content->content ($output);
$content->render_utf8
