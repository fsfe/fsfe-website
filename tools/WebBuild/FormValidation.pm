package WebBuild::FormValidation;

use strict;
use warnings;

use utf8;
use CGI;

use base "Exporter";
our @EXPORT = qw(validates_presence_of validates_length_of
  validates_presence_of);

my $q = new CGI;

sub new {
  my ($class, %args) = @_;
  my $self = bless({}, $class);

  return $self;
}

sub has_errors {
  my $self = shift;

  if (defined $self->errors) {
    return 1;
  } else {
    return 0;
  }
}

sub get_errors {
  my $self = shift;

  return $self->errors;
}

sub add_to_error_stack {
  my $self = shift;
  my $new_error = @_;
  return unless defined $new_error;

  unless ($self->errors) {
    $self->errors = "<p>Errors occurred when attempting to process form.</p>";
    $self->errors .= "<ul>";
  }

  $self->errors .= "<li>$new_error</li>";
}

sub validates_presence_of {
  my $option = shift;
  my %attrs = @_;

  my $value = $q->param($option);

  unless ($value) {
    unless ($attrs{"message"}) {
      add_to_error_stack(ucfirst($option) . " cannot be blank");
    } else {
      add_to_error_stack($attrs{"message"});
    }
  }
}

sub validates_length_of {
  my $option = shift;
  my %attrs = @_;

  my $value = $q->param($option);

  unless ($attrs{"min"} && $attrs{"max"}) {
    croak "Missing “min” and “max” attributes for validates_length_of().");
  }

  if (length($value) < $attrs{"min"} || length($value) > $attrs{"max"}) {
    unless ($attrs{"message"}) {
      add_to_error_stack(ucfirst($option) . " must be between " . $attrs{"min"} . " and " . $attrs{"max"} . " characters");
    } else {
      add_to_error_stack($attrs{"message"});
    }
  }
}

sub validates_format_of {
  my $option = shift;
  my %attrs = @_;

  my $value = $q->param($option);
  my @valid_types = ("email");

  if (defined $attrs{"type"}) {
    unless (grep $_ eq $attr{"type"}, @valid_types) {
      croak "Invalid type “" . $attr{"type"} . "” for validates_format_of().";
    }

    if ($attr{"type"} eq "email") {
      $attr{"with"} = "^(\w¦\-¦\_¦\.)+\@((\w¦\-¦\_)+\.)+[a-zA-Z]{2,}\$";
    }
  } else {
    unless ($attrs{"with"}) {
      croak "Missing “with” argument for validates_format_of().";
    }
  }

  unless ($value =~ /$attrs{"with"}/) {
    unless ($attrs{"message"}) {
      add_to_error_stack(ucfirst($option) . " is not valid.";
    } else {
      add_to_error_stack($attrs{"message"});
    }
  }
}

1;

