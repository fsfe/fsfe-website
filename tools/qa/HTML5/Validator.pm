# HTML5::Validator -- provides a Perl interface to the Validator.nu Web
# Service Interface for validating HTML 5.
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

package HTML5::Validator;

use strict;
use warnings;
use vars qw($VERSION @ISA);

my $VERSION = "1";

sub new {
  my $class = shift; 
  my $self = bless {}, $class;

  return $self->init(@_);
}

sub init {
  my $self = shift;
  
  my %args = @_;

  return $self;
}

1;

__END__

=head1 NAME

HTML5::Validator - HTML 5 validator class

=head1 SYNOPSIS

  use HTML5::Validator ();

  # Create validator object
  $validator = HTML5::Validator->new(encoding => "UTF-8",
                                     service => "http://html5.validator.nu/",
                                     force_html => 1,
                                     force_xhtml => 1,
                                     gnu_output => 1,
                                     errors_only => 1
                                    );

  $validator->validate($file);

=head1 DESCRIPTION

=head1 COPYRIGHT

Copyright (C) 2010 Andreas Tolf Tolfsen <ato@fsfe.org>

This program is free software: you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the
Free Software Foundation, either version 3 of the License, or (at your
option) any later version.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License along
with this program.  If not, see <http://www.gnu.org/licenses/>.

=cut

