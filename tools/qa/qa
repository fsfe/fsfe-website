#!/usr/bin/env perl

# QA -- Tools to do quality assurance on static web pages.
#
# Copyright (C) 2010 Andreas Tolf Tolfsen <ato@fsfe.org>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or (at
# your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

use strict;
use warnings;

use Log::Log4perl; #qw(:easy);
use Log::Log4perl::Level;

use Pod::Usage;
use File::Path qw(mkpath);
use Data::Dumper;

use QA::Options;
use QA::Config;
use QA::Utilities;

my $VERSION = 1;

# Logger
#Log::Log4perl->easy_init($INFO);
#my $log = get_logger();
#my $log_file = Log::Log4perl::Appender->new(
#  "Log::Dispatch::File",
#  filename => "qa.log",
#  mode     => "append"
#);
#my $log_screen = Log::Log4perl::Appender->new(
#  "Log::Dispatch::Screen"
#);
#my $log_file_layout = Log::Log4perl::Layout::PatternLayout->new(
#  "%d %p> %F{1}:%L %M - %m%n");
#my $log_screen_layout = Log::Log4perl::Layout::PatternLayout->new(
#  "%m%n");

#$log_file->layout($log_file_layout);
#$log_screen->layout($log_screen_layout);
#$log->add_appender($log_file);
#$log->add_appender($log_screen);

my $log_config = q(
  log4perl.rootLogger=DEBUG, Screen, File 
  log4perl.appender.Screen=Log::Log4perl::Appender::Screen
  log4perl.appender.Screen.stderr=0
  log4perl.appender.Screen.layout=Log::Log4perl::Layout::PatternLayout
  log4perl.appender.Screen.layout.ConversionPattern = %m%n
  log4perl.appender.File=Log::Log4perl::Appender::File
  log4perl.appender.File.filename=qa.log
  log4perl.appender.File.layout=Log::Log4perl::Layout::PatternLayout
  log4perl.appender.File.layout.ConversionPattern=%d %-1.1p %M - %m%n
);

Log::Log4perl::init(\$log_config);
my $log = Log::Log4perl->get_logger;


# Program.
if ($QA::Options->{help}) {
  pod2usage(-verbose => 2);
  exit;
} elsif ($QA::Options->{version}) {
  print "QA tools $VERSION\n";
  print "Copyright (C) 2010 Andreas Tolf Tolfsen\n";
  print "Licensed under GNU GPLv3 or later.\n";
  exit;
} elsif ($QA::Options->{debug}) {
  $log->level($DEBUG);
}

# Config
$QA::last_revision = QA::Utilities::vcs_last_revision;
$QA::Config->{report}->{output} .= "/" . $QA::last_revision;

unless (-d $QA::Config->{report}->{output}) {
  unless (mkpath($QA::Config->{report}->{output})) {
    $log->error("Config output directory does not exist '" .
      $QA::Config->{report}->{output} . "'");
  }
}

# Modules
my @available_modules = (
  "validation"
);

my @loaded_modules = ();

$log->info("Starting QA tools");

# Include modules.
while (my ($key, $value) = each(%{ $QA::Config->{modules} })) {
  if (grep $_ eq $value, @available_modules) {
    my $module = ucfirst($value);
    $log->debug("Including module '$value'");
    eval "use QA::$module";
    push @loaded_modules, $value;
  } else {
    $log->error("Module does not exist '$_'");
  }
}

$log->debug("Creating list of all files to be tested");
my @files = <../../*.html>;

foreach my $module (@loaded_modules) {
  $log->debug("Loading module '$module'");

  if ($module eq "validation") {
    my $validation = QA::Validation->new(files => \@files);
    $validation->test;
  }
}

__END__

=head1 NAME

qa - Tools to do quality assurance on static web pages.

=head1 SYNOPSIS

B<qa> [B<-c> I<config>] [B<-dhv>]

=head1 DESCRIPTION

B<qa> is a program that provides a framework for performing automated
quality assurance on static web pages.  It can be easily extended with
modules for various test types.

=head1 OPTIONS

=over 4

=item B<-c> I<config>, B<--config>=I<config>

Use specified configuration file instead of the default configuration
file (config.xml).

=item B<-d>, B<--debug>

Output more verbose messages.

=item B<-h>, B<--help>

Display manual page (this).

=item B<-v>, B<--version>

Displays program version.

=back

=head1 CONFIGURATION

=head1 AUTHOR

Andreas Tolf Tolfsen <ato@fsfe.org>

=head1 WEBSITE

No website yet.

=cut

