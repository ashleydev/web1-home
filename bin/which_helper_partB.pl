#!/usr/bin/perl

# NOTE:  this file should only be executed by /home/sjohnson/bin/which_helper_partA

use strict;
use Term::ANSIColor qw(:constants);

unless (scalar(@ARGV) == 2) {
  print "Usage: $0 [query] [file]\n";
  exit(1);
}

my $query = shift(@ARGV);
my $file_aliasdump = shift(@ARGV);

unless ( -f $file_aliasdump ) {
  warn "expecting but cannot find $file_aliasdump";
  exit(2);
}

open (READ, $file_aliasdump);

while (<READ>) {

  if (m/^alias $query=/) {
    my $alias_colored = YELLOW.'alias'.RESET;
    s/^alias/$alias_colored/;
    print; 
  }

}

open (READ_WHICH, "/usr/bin/which '$query' |");

while (<READ_WHICH>) {
  print GREEN, "which ", RESET;
  print;
}

close(READ_WHICH);
