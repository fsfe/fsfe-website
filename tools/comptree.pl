#! /usr/bin/perl


use strict;
use warnings;

use constant false => 0;
use constant true  => 1;

use XML::LibXML;



#print areEqual("./thankgnus.en.xhtml", "./thankgnus.fr.xhtml")."\n";


sub areEqual {
    
    my ($file1, $file2) = @_;
    
    my $dom = XML::LibXML->load_xml(location => $file1);
    my $don = XML::LibXML->load_xml(location => $file2);
    
    my $root = $dom->documentElement();
    my $roon = $don->documentElement();
    
    return nodesAreEqual($file1, $file2, $root, $roon, "/");
    
}


sub nodesAreEqual {
    
    my ($file1, $file2, $node1, $node2, $uptree) = @_;
    
    # test that two nodes at the same position have the same name
    if (not $node1->nodeName eq $node2->nodeName) {
        
        # short excerpts of these nodes' contents, to give a hint where the error is
        my $hint1 = $node1->textContent;
        $hint1 =~ s/\n//g; $hint1 =~ s/  //g; $hint1 =~ s/\t//g;
        $hint1 = substr($hint1,0,40)."...";
        
        my $hint2 = $node2->textContent;
        $hint2 =~ s/\n//g; $hint2 =~ s/  //g; $hint2 =~ s/\t//g;
        $hint2 = substr($hint2,0,40)."...";
        
        return (false, "$file2:\n
                        en contains $uptree".$node1->nodeName."\t(".$hint1."), but\n".
                       "** contains $uptree".$node2->nodeName."\t(".$hint2.")");
    }
    
    $uptree .= $node1->nodeName."/";
    
    # get all children of ecah node
    my @nodes = $node1->getChildrenByTagName('*');
    my @nodez = $node2->getChildrenByTagName('*');
    
    #print "\t".$node1->nodeName."(".scalar(@nodes).")", "\t", $node2->nodeName."(".scalar(@nodez).")", "\n";
    
    # remove <translator> and <timestamp> from the nodesz
    for (my $i=scalar(@nodes)-1; $i>=0; $i--) {
      if ( $nodes[$i]->nodeName eq "translator" or $nodes[$i]->nodeName eq "timestamp" ) {
        splice(@nodes,$i,1);
      }
    }
    for (my $i=scalar(@nodez)-1; $i>=0; $i--) {
      if ( $nodez[$i]->nodeName eq "translator" or $nodez[$i]->nodeName eq "timestamp" ) {
        splice(@nodez,$i,1);
      }
    }
    
    # test the size of the two lists of nodes
    if ( scalar(@nodes) != scalar(@nodez) ) {
      foreach (@nodes) { $_ = $_->nodeName  };
      foreach (@nodez) { $_ = $_->nodeName  };
      return (false, "$file1: ".join(",", @nodes)."\t\t<-children differences under $uptree\n"."$file2: ".join(",", @nodez) );
    }
    
    # comparing the two lists of nodes
    my $commons = "";
    for my $i (0 .. $#nodes) {
      if (not $nodes[$i]->nodeName eq $nodez[$i]->nodeName) {
        return (false, "$file2: after common $commons, " . $nodes[$i]->nodeName . " != " . $nodez[$i]->nodeName );
      }
      $commons .= $nodes[$i]->nodeName.","
    }
    
    # recur!
    for my $i (0 .. $#nodes) {
      my ($bool, $err) = nodesAreEqual($file1, $file2, $nodes[$i], $nodez[$i], $uptree);
      if (not $bool) {
        return ($bool, $err);
      }
    }
    
    # if we get here, it means we did not 
    return (true, "trees are equal");
    
}


return 1;














