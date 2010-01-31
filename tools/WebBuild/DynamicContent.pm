package WebBuild::DynamicContent;

use strict;
use warnings;

use HTML::TreeBuilder::XPath;

sub new {
  my ($class, %args) = @_;
  my $self = bless({}, $class);
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
  $document_parser->parse_file("../boilerplate.en.html") or die $!;

  my $content = $document_parser->findnodes('//div[@id="content"]')->[0];
  $content->findnodes("//p")->[0]->delete;
  my $old_content = $content->detach_content;

  foreach my $node (@output) {
    $content->push_content($node);
  }

  $content->push_content($old_content);
  $self->{output} = $document_parser->as_XML_indented;
}

sub render {
  my $self = shift;

  print "Content-type: text/html\n\n";
  print $self->{output};
  print "\n";
}

1;

