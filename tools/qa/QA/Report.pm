# QA::Report -- Allows easy generation of QA report files.
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

package QA::Report;

use strict;
use warnings;

use Carp;

use vars qw($VERSION @ISA);
my $VERSION = 1;

my @supported_outcomes = (
  "PASS",
  "FAIL",
  "ERROR"
);

sub new {
  my $class = shift;
  my $self = bless {}, $class;

  return $self->init(@_);
}

sub init {
  my ($self, %args) = @_;

  if (defined $args{file}) {
    $self->{report_file} = $args{file};
  } else {
    croak "You must supply a filename for your report.";
  }

  return $self;
}

sub new_test_result {
  my ($self, %args) = @_;

  my ($name, $outcome, $message);

  unless (defined $args{name} && defined $args{outcome}) {
    croak "You must define 'name' and 'outcome' arguments.";
  }

  if ($args{name}) {
    $name = $args{name};
  }

  unless (grep $_ eq uc($args{outcome}), @supported_outcomes) {
    croak "Invalid outcome '" . $args{outcome} . "'";
  } else {
    $outcome = uc($args{outcome});
  }

  if ($args{message}) {
    $message = $args{message};
  }

  $self->{tests}{scalar($self->{tests}) + 1} = {
    outcome => $outcome,
    message => $message
  };  
}

sub compile {
  my $self = shift;

  use Data::Dumper;
  return Dumper($self->{tests});
}

sub compile_to_file {
  my $self = shift;

  open REPORT, ">", $self->{report_file} or die $!;
  print REPORT $self->compile;
  close REPORT;
}

sub get_report {
  my $self = shift;

  if (-f $self->{report_file}) {
    return $self->{report_file};
  } else {
    croak "Report has not yet been generated.";
  }
}

1;

__END__

