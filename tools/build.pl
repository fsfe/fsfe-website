#! /usr/bin/perl
#
# build.pl - a tool for building FSF Europe web pages
#
# Copyright (C) 2003 Jonas Öberg
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
# 02111-1307, USA.
#
use File::Find::Rule;
use Getopt::Std;
use File::Path;
use File::Basename;
use XML::LibXSLT;
use XML::LibXML;
use File::Copy;
use POSIX qw(strftime);

# This defines the focuses and their respective preferred / original
# language. For example, it says that we should have a focus called
# "se" (Sweden) which has the preferred language "sv" (Swedish).
#
# This also says that documents in the directory /se should be considered
# as having the Swedish version as the original, and so on.
#
our %countries = (
  global => 'en',
  de => 'de',
  it => 'it',
  fr => 'fr',
  se => 'sv' );

#
# This is a hash of all the languages that we have translations into, and their
# respective names in the local language. Make sure that one entry exists
# here for every language, or it won't be rendered.
#
our %languages = (
  cs => 'Cesky',
  de => 'Deutsch',
  el => '&#917;&#955;&#955;&#951;&#957;&#953;&#954;&#940;',
  en => 'English',
  es => 'Espa&ntilde;ol',
  fr => 'Fran&ccedil;ais',
  it => 'Italiano',
  nl => 'Nederlands',
  pt => 'Portugu&ecirc;s',
  sv => 'Svenska',
);

our $current_date = strftime "%Y-%m-%d", localtime;

#
# Parse the command line options. We need two; where to put the finished
# pages and what to use as base for the input.
#
getopts('o:i:duqn', \%opts);
unless ($opts{o}) {
  print STDERR "Usage: $0 [-q] [-u] [-d] [-n] -o <output directory>\n";
  print STDERR "  -q   Quiet\n";
  print STDERR "  -u   Update only\n";
  print STDERR "  -d   Print some debug information\n";
  print STDERR "  -n   Don't write any files\n";
  exit 1;
}

# It might be nice to be able to specify this, but it will break things as
# they are now. This is on the TODO list :-)

$opts{i} = ".";

$| = 1;

#
# First topic of today: create all directories we need. Instead of creating
# these as they are used, we create them in a batch at the beginning of each
# run, so we won't have to worry about them later.
# Note though that this also REMOVES the previous paths. You don't want to
# build directly into the production web tree.
#
my @dirs = File::Find::Rule->directory()
                           ->in($opts{i});

while (my ($path, undef) = each %countries) {
  print STDERR "Reseting path for $path\n" unless $opts{q};
  rmtree($opts{o}.'/'.$path) unless ($opts{u} || $opts{n});
  my @paths = map { $opts{o}."/$path/".$_ } grep(!/^\.\.?$/, @dirs);
  foreach (@paths) {
    print "Creating $_\n" if $opts{d};
    mkpath($_) unless $opts{n};
  }
}

#
# Here starts our real work. First we get ourselves a list of all files
# that we need to worry about and then single out the XHTML files. We
# create a hash of hashes, %bases, which contains the basename of each
# file, together with the translations that it exists in.
#
my @files = File::Find::Rule->file()
                            ->in($opts{i});

my %bases;
foreach (grep(/\.xhtml$/, @files)) {
  $_ =~ s/^$opts{i}\/?// unless $opts{i} eq ".";
  my ($lang) = ($_ =~ /\.([a-z][a-z])\.xhtml$/);
  unless ($lang) { $lang = "en"; }
  $_ =~ s/\.[a-z][a-z]\.xhtml$//;
  $_ =~ s/\.xhtml$//;
  $bases{$_}{$lang} = 1;
}

#
# For each file, translation and focus, we create a new XML file. This will
# contain all information that the XSL needs to produce a finished page.
# The XML file will look like this:
#
# <buildinfo>
#   <trlist>            <!-- All translations that this page exists in -->
#     <tr id="sv">Svenska</tr>
#     ...
#   </trlist>
#   <menuset>           <!-- The menu items for the right hand bar -->
#     ...
#   </menuset>
#   <textset>           <!-- The static text set for this language -->
#     ...
#   </textset>
#   <document>          <!-- The actual document, as read from the XHTML -->
#     <head>
#       <title>...</title>
#       <body>...</body>
#     </head>
#   </document>
# </buildinfo>
#
# In addition to this, the buildinfo and document root will be equipped with
# the following attributes:
#
#  buildinfo/@original   The language code of the original document
#  buildinfo/@filename   The filename without language or trailing .html
#  buildinfo/@language   The language that we're building into
#  buildinfo/@outdated   Set to "yes" if the original is newer than this page
#  document/@language    The language that this documents is in
#
while (my ($file, $langs) = each %bases) {
  print STDERR "Building $file.. " unless $opts{q};

  #
  # Create XML and XSLT parser contexts. Also create the root note for the
  # above mentioned XML file (used to feed the XSL transformation).
  #
  my $parser = XML::LibXML->new();
  my $xslt_parser = XML::LibXSLT->new();

  my $dom = XML::LibXML::Document->new("1.0", "iso-8859-1");
  my $root = $dom->createElement("buildinfo");
  $dom->setDocumentElement($root);

  #
  # Set the current date, to use for comparision in the XSLT.
  #
  $root->setAttribute("date", $current_date);

  #
  # Find original language. It's en, unless we're in the country specific
  # se/, fr/, de/ and so on, directories.
  #
  $root->setAttribute("original", "en");
  if ($file =~ /^([a-z][a-z])\//) {
      $root->setAttribute("original", $countries{$1});
  }

  $root->setAttribute("filename", "/$file");

  #
  # Find all translations for this document, and create the trlist set
  # for them.
  #
  my $trlist = $dom->createElement("trlist");
  while (my ($lang, undef) = each %{ $langs }) {
      my $tr = $dom->createElement("tr");
      $tr->setAttribute("id", $lang);
      $tr->appendText($languages{$lang});
      $trlist->appendChild($tr);
  }
  $root->appendChild($trlist);

  #
  # Transform it, once for every focus!
  #
  while (my ($dir, undef) = each %countries) {
    print STDERR "$dir " unless $opts{q};

    #
    # And once for every language!
    #
    while (my ($lang, undef) = each %languages) {
	$root->setAttribute("language", $lang);

        #
	# This finds the source file to use. If we can't find a translation
	# into the language, it uses the english version instead, or that in
	# the local language. Or the first version it finds. This should be
        # made prettier.
        #
	my $document = $dom->createElement("document");
	$document->setAttribute("language", $lang);
	$root->appendChild($document);

	my $source = "$opts{i}/$file.$lang.xhtml";
	unless (-f $source) {
            if (-f "$opts{i}/$file.xhtml") {
                $document->setAttribute("language", "en");
                $source = "$opts{i}/$file.xhtml";
            } elsif (-f "$opts{i}/$file.en.xhtml") {
		$document->setAttribute("language", "en");
		$source = "$opts{i}/$file.en.xhtml";
	    } elsif (-f "$opts{i}/$file.".$root->getAttribute("original").".xhtml") {
		$document->setAttribute("language", $root->getAttribute("original"));
		$source = "$opts{i}/$file.".$root->getAttribute("original").".xhtml";
	    } else {
                my $l = (keys %{$bases{$file}})[0];
                $document->setAttribute("language", $l);
		$source = "$opts{i}/$file.$l.xhtml";
            }
	}

        if ( (stat("$opts{o}/$dir/$file.$lang.html"))[9] >
             (stat($source))[9] && $opts{u} && ! -f "$opts{i}/$file.xsl" ) {
           next;
        }

        #
        # Here begins automated magic for those pages which we need to
        # assemble other sets of informations for first (automatically
        # updated pages).
        #
	if (-f "$opts{i}/$file.xsl") {
          #
          # Settle down please, children. First we remove all previous
          # document leftovers.
          #
          foreach ($root->getElementsByTagName("document")) {
	    $root->removeChild($_);
          }
          $root->appendChild($document);

          #
          # Get the list of sources and create the files hash. The files
          # hash contains the base name for each file we want to use, and
          # then the language for it as a value. It prefers a file in the
          # language we're building into, but will accept an English file as
          # a substitute.
          #
          #     "Learn all that is learnable and return that information
          #      to the Creator."
          #
          open(IN, '<', "$opts{i}/$file.sources");
          my @auto_sources = <IN>;
          close IN;
          my %files;
          foreach (@auto_sources) {
            if (/(.*):[a-z,]*global/ || /(.*):[a-z,]*$dir/) {
              foreach my $f (glob("$1*")) {
                 if ($f =~ /(.*)\.([a-z][a-z])\.xml$/) {
                    if (!$files{$1}) {
                      $files{$1} = $2;
                    } elsif ($2 eq $lang) {
                      $files{$1} = $2;
                    } elsif (($2 eq "en") &&
                             ($files{$1} ne $lang)) {
                      $files{$1} = $2;
                    }
                 }
              }
            }
          }

          #
          # With that information, we load the source document and create
          # a new element in it, called <set>, which will hold the combined
          # knowledge of all the sets in the source files.
          #
          my $sourcedoc = $parser->parse_file($source);
          $sourcedoc->documentElement->setAttribute("date", $current_date);
          my $auto_data = $sourcedoc->createElement("set");

          while (my ($base, $l) = each %files) {
              print STDERR "Loading $base.$l.xml\n" if $opts{d};
              my $source_data = $parser->parse_file("$base.$l.xml");
              foreach ($source_data->documentElement->childNodes) {
                 my $c = $_->cloneNode(1);
                 $auto_data->appendChild($c);
              }
          }
          $sourcedoc->documentElement->appendChild($auto_data);

          #
          # Transform the document using the XSL file and then push the
          # result into the <document> element of the document we're building.
          #
          my $style_doc = $parser->parse_file("$opts{i}/$file.xsl");
	  my $stylesheet = $xslt_parser->parse_stylesheet($style_doc);
	  my $results = $stylesheet->transform($sourcedoc);

          foreach ($results->documentElement->childNodes) {
            my $c = $_->cloneNode(1);
            $document->appendChild($c);
          }
        } else {
          #
          # If this wasn't an automatically updating document, we simply
          # clone the contents of the source file into the document.
          #
	  clone_document($document, $source);
        }

        #
        # Find out if this translation is to be regarded as outdated or not.
        # Make allowances for files called either file.en.xhtml or file.xhtml.
        #
	if ((stat("$opts{i}/$file.".$root->getAttribute("original").".xhtml"))[9] >
	    (stat($source))[9]) {
	    $root->setAttribute("outdated", "yes");
	} else {
	    $root->setAttribute("outdated", "no");
	}

        if (-f "$opts{i}/$file.xhtml") {
	  if ((stat("$opts{i}/$file.xhtml"))[9] >
	      (stat($source))[9]) {
	      $root->setAttribute("outdated", "yes");
	  } else {
	      $root->setAttribute("outdated", "no");
	  }
        }

        #
        # Get the appropriate textset for this language. If one can't be
        # found, use the English. (I hope this never happens)
        #
	my $textlang = $lang;
	unless (-f $opts{i}."/tools/texts-$textlang.xml") {
	    $textlang = "en";
	}

	my $textdoc = $dom->createElement("textset");
	$root->appendChild($textdoc);
	clone_document($textdoc, $opts{i}."/tools/texts-$textlang.xml");

	#
        # And then we do the same thing for the menues. But first we take the
        # global menu here, then we add any information that is specific to
        # the focus.
        #
	foreach ($root->getElementsByTagName("menuset")) {
	    $root->removeChild($_);
	}

	my %menu;
	foreach ('global', $dir) {
	    if (-f $opts{i}."/tools/menu-$_.xml") {
		my $menudoc = $parser->parse_file($opts{i}."/tools/menu-$_.xml");
		foreach my $n ($menudoc->documentElement->getElementsByTagName("menu")) {
		    $menu{$n->getAttribute("id")} = $n;
		}
	    }
	}
	my $menuroot = $dom->createElement("menuset");
	while (my ($id, $n) = each %menu) {
            my $m = $n->cloneNode(1);
	    $menuroot->appendChild($m);
	}
	$root->appendChild($menuroot);

        #
        # Do the actual transformation.
        #
	my $style_doc = $parser->parse_file($opts{i}."/fsfe-new.xsl");
	my $stylesheet = $xslt_parser->parse_stylesheet($style_doc);
	my $results = $stylesheet->transform($dom);

        #
        # In post-processing, we replace links pointing back to ourselves
        # so that they point to the correct language.
        #
        foreach ($results->documentElement->getElementsByTagName("a")) {
          my $href = $_->getAttribute("href");
          if ($href =~ /^http:\/\/www.fsfeurope.org/) {
            $href =~ s/http:\/\/www.fsfeurope.org//;
          }
          if ($href !~ /^http/) {
            if ($href !~ /\.html$/) {
              if (-d $opts{i}."/$href") {
                $href =~ s/\/?$/\/index.$lang.html/;
              } elsif ($href =~ /\/\w+$/) {
                $href .= ".$lang.html";
              }
            } else {
              $href =~ s/([^\.][a-z0-9-][a-z0-9-])\.html/$1.$lang.html/;
            }
            $_->setAttribute("href", $href);
          }
        }

	print "Writing: $opts{o}/$dir/$file.$lang.html\n" if $opts{d};

	$stylesheet->output_file($results, "$opts{o}/$dir/$file.$lang.html")
		unless $opts{n};
    }
  }    
  print STDERR "\n" unless $opts{q};
}

print STDERR "Fixing index links\n" unless $opts{q};

while (my ($path, undef) = each %countries) {   
  my @dirs = File::Find::Rule->directory()
                             ->in($opts{o}."/$path");
  foreach (@dirs) {
    my $base = basename($_);
    while (my ($lang, undef) = each %languages) {
      if (-f "$_/$base.$lang.html" &&
          ! -f "$_/index.$lang.html") {
        link("$_/$base.$lang.html", "$_/index.$lang.html")
		unless $opts{n};
      }
      if (! -f "$_/index.html") {
        if (-f "$_/index.en.html") {
          link("$_/index.en.html", "$_/index.html")
		unless $opts{n};
        } elsif (-f "$_/$base.en.html") {
          link("$_/$base.en.html", "$_/index.html")
		unless $opts{n};
        }
      }
    }
  }
}

#
# For all files that are not XHTML source files, we copy them verbatim to
# the final location, for each focus. These should be links instead to
# prevent us from vasting disk space.
#
print STDERR "Copying misc files\n" unless $opts{q};
foreach (grep { !/\.xsl$/ } grep(!/\.xhtml$/, @files)) {
  while (my ($dir, undef) = each %countries) {
    if (-f "$opts{i}/$_" && !$opts{n}) {
      link("$opts{i}/$_", "$opts{o}/$dir/$_");
    }
  }
}

#
# Helper function that clones a document. It accepts an XML node and
# a filename as parameters. Using this, it loads the source file into
# the XML node.
#
sub clone_document {
    my ($doc, $source) = @_;
    my $root = $doc->parentNode;

    print "Source: $source\n" if $opts{d};

    foreach ($root->getElementsByTagName($doc->nodeName)) {
	$root->removeChild($_);
    }
    $root->appendChild($doc);

    my $parser = XML::LibXML->new();

    open(IN, '<', $source);
    $textsource = join('', <IN>);

    #
    # This requires an explanation. I had bad luck with some versions of
    # XML::LibXML wanting to validate the DTD. So just to be extra safe
    # we maintain a local copy of it, so it doesn't need to go browsing
    # www.w3.org for -every- parsing.
    #
    $textsource =~ s|http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd|tools/xhtml1-transitional.dtd|g;
    $parser->load_ext_dtd(0);
    $parser->recover(1);

    my $sourcedoc = $parser->parse_string($textsource);
    foreach ($sourcedoc->documentElement->childNodes) {
        $_->unbindNode();
	my $n = $_->cloneNode(1);
	$doc->appendChild($n);
    }
}
