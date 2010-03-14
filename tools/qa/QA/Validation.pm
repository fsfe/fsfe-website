# QA::Validation -- Validates {X,HT}ML files and creates a report of its
# findings.
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

package QA::Validation;

use strict;
use warnings;

use Log::Log4perl qw(get_logger);

use QA::Config;
use QA::Report;
use HTML5::Validator;

use vars qw($VERSION @ISA);
my $VERSION = 1;

my $log = get_logger("QA::Validation");

sub new {
  my $class = shift;
  my $self = bless {}, $class;
  
  return $self->init(@_);
}

sub init {
  my ($self, %args) = @_;

  $log->debug("Initializing Validation module");

  my @supported_formats = (
    "html",
    "txt"
  );

  if (scalar($QA::Config->{report}->{formats}) > 0) {
    while (my ($key, $value) = each(%{ $QA::Config->{report}->{formats} })) {
      unless (grep $_ eq $value, @supported_formats) {  
        $log->error("Invalid format '$_'");
      }
    }
  }

  $self->{report_file} = $QA::Config->{report}->{output} . "/validation";
  $self->files($args{files});

  return $self;
}

sub files {
  my ($self, @files) = @_;

  if (@files) {
    $self->{files} = \@files;
  }
}

sub test {
  my $self = shift;

  my $validator = HTML5::Validator->new;
  my $report = QA::Report->new(file => $self->{report_file});

  if (scalar($self->{files}) == 0) {
    $log->info("No files to test.");
  }

  $log->info("Starting testing:");

  foreach my $file ($self->{files}[0][0]) {
    unless (-f $file) {
      $log->warn("  [ERROR] (Missing file) $file");
    } else { 
      $report->new_test_result(name    => $file,
                               outcome => "FAIL",
                               message => "Missing file.");
    
      if ($validator->parse_file($file)) {
        $log->info("  [PASS] $file");
      } else {
        $log->warn("  [FAIL] $file");
      }
    }
  }

  $log->info("Finished testing!");
  $report->compile;
}

sub get_report {
  my $self = shift;

  if (-f $self->{report_file}) {
    return $self->{report_file};
  } else {
    $log->info("Report has not yet been generated.");
  }
}

1;

__END__

