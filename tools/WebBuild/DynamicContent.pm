package WebBuild::DynamicContent;

=head1 DESCRIPTION

Please document me >:(

=cut

use strict;
use warnings;

use Carp;
use HTML::TreeBuilder::XPath;

sub new {
  my ($class, %args) = @_;
  my $self = bless({}, $class);

  $self->{layout} = "../boilerplate.en.html";

  return $self;
}

sub layout {
  my ($self, $new_layout) = @_;
 
  if (-f $new_layout) {
    $self->{layout} = $new_layout;
  }
}

sub content {
  my ($self, $raw_output) = @_;
  $self->{raw_output} = $raw_output;

  $self->transform;
}

sub transform {
  my $self = shift;

  my $output_parser = HTML::TreeBuilder::XPath->new;
  $output_parser->parse($self->{raw_output});
  my @output = $output_parser->disembowel;

  my $document_parser = HTML::TreeBuilder::XPath->new;
  open(my $fh, "<:encoding(UTF-8)", $self->{layout});
  $document_parser->parse_file($fh) or croak $!;
  close($fh);
  
  my $content = $document_parser->findnodes('//[@id="content"]')->[0];

  if ($self->{layout} =~ /boilerplate/) {
    $content->findnodes("//p")->[0]->delete;
  }

  my @old_content = $content->content_list;

  foreach my $node (@output) {
    $content->push_content($node);
  }

  foreach my $n (@old_content) {
    $content->push_content($n);
  }

  $self->{output} = $document_parser->as_XML;
}

sub render {
  my $self = shift;

  print "Content-type: text/html\n\n";
  print $self->{output};
  print "\n";
}

sub render_utf8 {
  my $self = shift;

  print "Content-type: text/html; charset=utf-8\n\n";
  print $self->{output};
  print "\n";
}

1;

