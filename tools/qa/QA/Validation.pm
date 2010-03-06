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

use Carp;
use QA::Report;
use HTML5::Validator;

use vars qw($VERSION @ISA);
my $VERSION = 1;

sub new {
  my $class = shift;
  my $self = bless {}, $class;

  return $self->init(@_);
}

sub init {
  my $self = shift;
  my %args = @_;

  $self->files($args{files});

  return $self;
}

sub files {
  my ($self, @files) = @_;

  if (defined ($args{files})) {
    $self->{files} = $args{files};
  }
}

sub test {
  my $self = shift;

  my $validator = HTML5::Validator->new;
  my $report = QA::Report->new(file => $self->{report_file});

  if (scalar($self->{files}) == 0) {
    croak "No files to test.";
  }

  foreach $file ($self->{files}) {
    unless (-f $file) {
      $report->new_test_result(name    => $file,
                               outcome => "FAIL",
                               message => "Missing file.");
    }

    $validator->parse_file($file);
  }

  $report->compile;
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

