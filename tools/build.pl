#! /usr/bin/perl
#
# build.pl - a tool for building FSFE web pages
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
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  
# 02110-1301, USA.
#
use File::Find::Rule;
use Getopt::Std;
use File::Path;
use File::Basename;
use XML::LibXSLT;
use XML::LibXML;
use File::Copy;
use POSIX qw(strftime);
use IO::Handle;
use IO::Select;
use Socket;
use Fcntl ':flock';

# This defines the focuses and their respective preferred / original
# language. For example, it says that we should have a focus called
# "se" (Sweden) which has the preferred language "sv" (Swedish).
#
# This also says that documents in the directory /se should be considered
# as having the Swedish version as the original, and so on.
#
our %countries = (global => 'en');
#our %countries = (
#  global => 'en',
#  de => 'de',
#  es => 'es',
#  it => 'it',
#  fr => 'fr',
#  se => 'sv' );

#
# This is a hash of all the languages that we have translations into, and their
# respective names in the local language. Make sure that one entry exists
# here for every language, or it won't be rendered.
#
# NOTE: Make sure that the language also is added to Apache configuration so
# content negotiation works.
#
our %languages = (
  ar => '&#1575;&#1604;&#1593;&#1585;&#1576;&#1610;&#1617;&#1577;',
  bg => '&#1041;&#1098;&#1083;&#1075;&#1072;&#1088;&#1089;&#1082;&#1080;',
  ca => 'Catal&#224;',
  cs => '&#268;esky',
  da => 'Dansk',
  de => 'Deutsch',
  el => '&#917;&#955;&#955;&#951;&#957;&#953;&#954;&#940;',
  en => 'English',
  es => 'Espa&#241;ol',
  et => 'Eesti',
  fi => 'Suomi',
  fr => 'Fran&#231;ais',
  hr => 'Hrvatski',
  hu => 'Magyar',
  it => 'Italiano',
  ku => 'Kurd&#238;',
  mk => 'M&#1072;&#1082;&#1077;&#1076;&#1086;&#1085;&#1089;&#1082;&#1080;',
  nb => 'Norsk&nbsp;(bokm&aring;l)',
  nl => 'Nederlands',
  nn => 'Norsk&nbsp;(nynorsk)',
  pl => 'Polski',
  pt => 'Portugu&#234;s',
  ro => 'Rom&#226;n&#259;',
  ru => '&#1056;&#1091;&#1089;&#1089;&#1082;&#1080;&#1081;',
  sk => 'Sloven&#269;ina',
  sl => 'Sloven&#353;&#269;ina',
  sq => 'Shqip',
  sr => 'Srpski',
  sv => 'Svenska',
  tr => 'T&#252;rk&#231;e',
);

our $current_date = strftime "%Y-%m-%d", localtime;
our $current_time = strftime "%Y-%m-%d %H:%M:%S", localtime;


# This static array contains files that can't be out of date
our %cant_be_outdated = (
  "news/news" => 1,
  "index" => 1
);


#
# Parse the command line options. We need two; where to put the finished
# pages and what to use as base for the input.
#
getopts('o:i:t:duqn', \%opts);
unless ($opts{o}) {
  print STDERR "Usage: $0 [-q] [-u] [-d] [-n] [-t #] -o <output directory>\n";
  print STDERR "  -q   Quiet\n";
  print STDERR "  -u   Update only\n";
  print STDERR "  -d   Print some debug information\n";
  print STDERR "  -n   Don't write any files\n";
  print STDERR "  -t   Number of worker childs to create (default: 1)\n";
  exit 1;
}

# It might be nice to be able to specify this, but it will break things as
# they are now. This is on the TODO list :-)

$opts{i} = ".";

$| = 1;

$SIG{CHLD} = 'IGNORE';

# Create XML and XSLT parser contexts. Also create the root note for the
# above mentioned XML file (used to feed the XSL transformation).

my $parser = XML::LibXML->new('encoding'=>'utf-8');
my $xslt_parser = XML::LibXSLT->new('encoding'=>'utf-8');

# Parse the global stylesheet

my $global_style_doc = $parser->parse_file($opts{i}."/fsfe.xsl");
my $global_stylesheet = $xslt_parser->parse_stylesheet($global_style_doc);

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
  print STDERR "Resetting path for $path\n" unless $opts{q};
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

# Open the file where we will log all outdated and missing translations
open (TRANSLATIONS, '>', "$opts{o}/translations.log");

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
#   <localmenuset>      <!-- Local menu items for some directories -->
#     ...
#   </localmenuset>
#   <menuset>           <!-- The menu items for the left hand bar -->
#     ...
#   </menuset>
#   <textset>           <!-- The static text set for this language -->
#     ...
#   </textset>
#   <textsetbackup>     <!-- The English textset as backup for missing translations -->
#     ...
#   </textsetbackup>
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
#  buildinfo/@original    The language code of the original document
#  buildinfo/@filename    The filename without language or trailing .html
#  buildinfo/@dirname    The path to the file
#  buildinfo/@language    The language that we're building into
#  buildinfo/@outdated    Set to "yes" if the original is newer than this page
#  document/@language     The language that this documents is in
#
#
# $threads is the number of child processes to fork off to build the tree
#
unless ($threads = $opts{t}) {
  $threads = 1;
}

#
# Start the required number of children, for each child we create a socket
# pair to communicate between parent and child. This information is kept in
# the %procs hash, which contains file handles for both child and parent.
#
foreach my $i (1..$threads) {
  $procs[$i]{child} = new IO::Handle;
  $procs[$i]{parent} = new IO::Handle;

  socketpair($procs[$i]{child}, $procs[$i]{parent}, AF_UNIX,
             SOCK_STREAM, PF_UNSPEC);

  $procs[$i]{child}->autoflush(1);
  $procs[$i]{parent}->autoflush(1);
  #$procs[$i]{child}->blocking(false);
  #$procs[$i]{parent}->blocking(false);

  if (fork()) {
    # 
    # The parent doesn't do anything at this stage, except close one of
    # the filehandes not used.
    #
    close($procs[$i]{parent});
  } else {
    #
    # This is the main worker for the children, which wait for a command
    # to execute, either DIE or PROCESS. In the case of the first, the child
    # exists gracefully, in the case of the second, it calls on process()
    # to build the required page and languages.
    #
    # When waiting for the next page to be sent to it, the child sends NEXT
    # to the parent to signify that it's ready for the next command.
    #
    close($procs[$i]{child});
    my $io = $procs[$i]{parent};
    print $io "NEXT\n";
    while (!$io->error) {
      my $cmd = <$io>;
      if ($cmd =~ /DIE/) {
         exit;
      } elsif ($cmd =~ /PROCESS/) {
         chomp($cmd);
         my (undef, $file, $langs) = split(/\|/, $cmd);
         process($file, $langs);
	 print $io "NEXT\n";
      }
    }
    exit;
  }
}

#
# This sets up an IO::Select object with the filehandles of all children.
# The parent uses this when looking for the next available child and blocks
# until any child is ready.
#
my $s = IO::Select->new();
foreach my $i (1..$threads) {
  $s->add($procs[$i]{child});
}

while (my ($file, $langs) = each %bases) {
  $s->can_read();

  my $done = 0;
  while (!$done) {
    foreach my $fh ($s->can_read()) {
      $cmd = <$fh>;
      if ($cmd =~ /NEXT/) {
        printf $fh "PROCESS|%s|%s\n", $file, join(':', keys(%{$langs}));
	$done = 1;
        last;
      }
    }
  }
}

#
# When done, we send the DIE command to each child.
#
foreach my $i (1..$threads) {
  my $io = $procs[$i]{child};
  print $io "DIE\n";
}

#
# This ensures a timely wait for every child to finish processing and shutdown.
#
while (wait() != -1) {
  sleep 2;
}

sub process {
  my ($file, $langs) = @_;

  print STDERR "Building $file.. \n" unless $opts{q};
  # Create the root note for the above mentioned XML file (used to feed the XSL
  # transformation).

  my $dom = XML::LibXML::Document->new("1.0", "utf-8");
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
  my $srcfocus = "global";
  if ($file =~ /^([a-z][a-z])\//) {
      $srcfocus = "$1";
      $root->setAttribute("original", $countries{$1});
  }
  
  $root->setAttribute("filename", "/$file");
  
  #
  # Set the directory name attribute
  #
  my (undef, $current_dir, undef) = fileparse($file);

  $root->setAttribute("dirname", "$current_dir");
  $root->setAttribute("workdir", $ENV{'PWD'});

  #
  # Find all translations for this document, and create the trlist set
  # for them.
  #
  my $trlist = $dom->createElement("trlist");
  foreach my $lang (split(/:/, $langs)) {
    my $tr = $dom->createElement("tr");
    $tr->setAttribute("id", $lang);
    $tr->appendText($languages{$lang});
    $trlist->appendChild($tr);
  }
  $root->appendChild($trlist);

  #
  # Load the file with local menu's
  #
  my $localmenu = "$opts{i}/localmenuinfo.xml";
  if (-f $localmenu) {
    my $menudoc = $dom->createElement("localmenuset");
    $root->appendChild($menudoc);
    clone_document($menudoc, $localmenu);
  }

  #
  # Load English backup texts
  #

  my $backup = $dom->createElement("textsetbackup");
  $root->appendChild($backup);
  clone_document($backup, $opts{i}."/tools/texts-en.xml");

  #
  # Transform it, once for every focus!
  #
  while (my ($dir, undef) = each %countries) {
    # If we handle a focus specific file, only process it in that focus
    # -> we don't handle focus-specific files anymore, commenting next line out, since it's causing errors
    #next if (("$srcfocus" ne "global") && ("$dir" ne "$srcfocus"));

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
          my $missingsource = $source;
          if (-f "$opts{i}/$file.en.xhtml") {
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
          if ($dir eq "global") {
    	      lock(*TRANSLATIONS);
            print TRANSLATIONS "$lang $missingsource $source\n";
	          unlock(*TRANSLATIONS);
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

          # Create the <timestamp> tag automatically for these documents
          my $timestamp = $dom->createElement("timestamp");
          $timestamp->appendText("\$"."Date: ".$current_time." \$ \$"."Author: automatic \$");
          $document->appendChild($timestamp);

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
          $sourcedoc->documentElement->setAttribute("lang", $lang);
          my $auto_data = $sourcedoc->createElement("set");

          while (my ($base, $l) = each %files) {
              if (($dir eq "global") && ($l ne $lang)) {
	              lock(*TRANSLATIONS);
                print TRANSLATIONS "$lang $base.$lang.xml $base.$l.xml\n";
      		      unlock(*TRANSLATIONS);
              }
              print STDERR "Loading $base.$l.xml\n" if $opts{d};
              my $source_data = $parser->parse_file("$base.$l.xml");
              foreach ($source_data->documentElement->childNodes) {
                 my $c = $_->cloneNode(1);
                 # add the filename to nodes (news, events, …) so that we can use it as an identifier (e.g. for RSS)
                 if (ref($c) eq "XML::LibXML::Element") {
                   $base =~ /.*[\/_]([^\/_]*$)/;
                   $c->setAttribute( "filename", $1 );
                 }
                 $auto_data->appendChild($c);
              }
          }
          $sourcedoc->documentElement->appendChild($auto_data);
          
          #
          # Get the appropriate textset for this language. If one can't be
          # found, use the English. (I hope this never happens)
          #
          my $textlang = $lang;
          unless (-f $opts{i}."/tools/texts-content-$textlang.xml") {
              $textlang = "en";
          }
          
          my $textdoc = $sourcedoc->createElement("textset-content");
          $auto_data->appendChild($textdoc);
          clone_document($textdoc, $opts{i}."/tools/texts-content-$textlang.xml");
          
          # Get also backup texts from the English file
          my $textdocbak = $sourcedoc->createElement("textset-content-backup");
          $auto_data->appendChild($textdocbak);
          clone_document($textdocbak, $opts{i}."/tools/texts-content-en.xml");
          
          # TODO: optimise getting texts-content-xx.xml and texts-content-en.xml,
          # since it does not depend on the xsl file being treated, we should do it only once!
          
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

          #
          # Now, while we're just at it, we create the RSS feeds if we want any
          #
	        if (-f "$opts{i}/$file.rss.xsl") {
            my $style_doc = $parser->parse_file("$opts{i}/$file.rss.xsl");
	          my $stylesheet = $xslt_parser->parse_stylesheet($style_doc);
	          my $results = $stylesheet->transform($sourcedoc);
	          $stylesheet->output_file($results, "$opts{o}/$dir/$file.$lang.rss")
    	      unless $opts{n};
          }

    		  #
          # and possibly the corresponding iCal (ics) file
          #
  	      if (-f "$opts{i}/$file.ics.xsl") {
            my $style_doc = $parser->parse_file("$opts{i}/$file.ics.xsl");
			      my $stylesheet = $xslt_parser->parse_stylesheet($style_doc);
			      my $results = $stylesheet->transform($sourcedoc);
			      $stylesheet->output_file($results, "$opts{o}/$dir/$file.$lang.ics")
			      unless $opts{n};
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
          # A translation is deemed outdated if it is more than 2 hours older
          # than the original. This makes sure a translation committed together
          # with the original (but maybe a second earlier) isn't marked outdated.
          #
          my $originalsource = "$file.".$root->getAttribute("original").".xhtml";
	        if (( stat("$opts{i}/$originalsource"))[9] > (stat($source))[9] + 7200
	              and not $cant_be_outdated{$file} ) {
	          $root->setAttribute("outdated", "yes");
		        if ($dir eq "global") {
			        lock(*TRANSLATIONS);
		          print TRANSLATIONS "$lang $source $originalsource\n";
			        unlock(*TRANSLATIONS);
		        }
			} else {
				$root->setAttribute("outdated", "no");
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
	# Read the fundraising text, if it exists.
	#
	if (-f $opts{i}."/fundraising.$lang.xml") {
	    my $fundraisingdoc = $dom->createElement("fundraising");
	    $root->appendChild($fundraisingdoc);
	    clone_document($fundraisingdoc, $opts{i}."/fundraising.$lang.xml");
	} elsif (-f $opts{i}."/fundraising.en.xml") {
	    my $fundraisingdoc = $dom->createElement("fundraising");
	    $root->appendChild($fundraisingdoc);
	    clone_document($fundraisingdoc, $opts{i}."/fundraising.en.xml");
        }


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
        my $results = $global_stylesheet->transform($dom);

        #
        # In post-processing, we replace links pointing back to ourselves
        # so that they point to the correct language.
        #
        foreach ($results->documentElement->getElementsByTagName("a")) {
          my $href = $_->getAttribute("href");
          if ($href =~ /^http:\/\/www.fsfe.org/) {
            if ($_->textContent != "Our global work") {
              $href =~ s/http:\/\/www.fsfe.org//;
            }
          }
          if (($href !~ /^http/) && ($href !~ /^#/)) {
	    # Save possible anchor and remove it from URL
	    my $anchor = $href;
	    if (!($anchor =~ s/.*#/#/)) {
	      $anchor = "";
	    }
	    $href =~ s/#.*//;
	    # process URL
	    if (($href =~ /\.html$/) && ($href !~ /\.[a-z][a-z]\.html$/)) {
              $href =~ s/\.html$/\.$lang.html/;
            } elsif (($href =~ /\.rss$/) && ($href !~ /\.[a-z][a-z]\.rss$/)) {
              $href =~ s/\.rss$/\.$lang.rss/;
            } elsif (($href =~ /\.ics$/) && ($href !~ /\.[a-z][a-z]\.ics$/)) {
              $href =~ s/\.ics$/\.$lang.ics/;
            } else {
              if (-d $opts{i}."/$href") {
                $href =~ s/\/?$/\/index.$lang.html/;
              } elsif ($href =~ /\/\w+$/) {
                $href .= ".$lang.html";
              }
            }
	    # replace anchor
	    $href .= $anchor;
            # For pages running on an external server, use full URL
            if ($document->getAttribute("external")) {
              $href = "http://www.fsfe.org$href";
            }
            $_->setAttribute("href", $href);
          }
        }

	print "Writing: $opts{o}/$dir/$file.$lang.html\n" if $opts{d};

	$global_stylesheet->output_file($results, "$opts{o}/$dir/$file.$lang.html")
		unless $opts{n};
        # Add foo.html.xx link which is used by Apache's MultiViews option when
        # a user enters foo.html as URL.
        link("$opts{o}/$dir/$file.$lang.html", "$opts{o}/$dir/$file.html.$lang")
		unless $opts{n};
    }
  }
  print STDERR "\n" unless $opts{q};
}

# Close the logfile for outdated and missing translations
close (TRANSLATIONS);

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
        link("$_/$base.html.$lang", "$_/index.html.$lang")
		unless $opts{n};
      }
    }
  }
}

#
# For all files that are not XHTML source files, we copy them verbatim to
# the final location, for each focus. These should be links instead to
# prevent us from wasting disk space.
#
print STDERR "Copying misc files\n" unless $opts{q};
foreach (grep(!/\.sources$/, grep(!/\.xsl$/, grep(!/\.xml$/, grep(!/\.xhtml$/,
          @files))))) {
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
    
    my $parser = XML::LibXML->new('encoding'=>'utf-8');
    $parser->load_ext_dtd(0);
    $parser->recover(1);
    
    my $sourcedoc = $parser->parse_file($source);
    foreach ($sourcedoc->documentElement->childNodes) {
      $_->unbindNode();
	    my $n = $_->cloneNode(1);
	    $doc->appendChild($n);
    }
    if ($sourcedoc->documentElement->getAttribute("external")) {
      $doc->setAttribute("external", "yes");
    }
    if ($sourcedoc->documentElement->getAttribute("newsdate")) {
      # necessary for xhtml news files
      $doc->setAttribute("newsdate", $sourcedoc->documentElement->getAttribute("newsdate"));
    }
    if ($sourcedoc->documentElement->getAttribute("type")) {
      # necessary to differentiate news and newsletter pages
      # TODO: find a way to copy all such attributes!
      $doc->setAttribute("type", $sourcedoc->documentElement->getAttribute("type"));
    }
}

#
# Helper functions to lock and unlock the translation log.
#
sub lock {
  my ($fh) = @_;

  flock($fh, LOCK_EX);
  seek($fh, 0, 2);
}

sub unlock {
  my ($fh) = @_;
  flock($fh, LOCK_UN);
}
