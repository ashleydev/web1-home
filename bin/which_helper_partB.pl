#!/usr/bin/perl

# NOTE:  this file should only be executed by /home/sjohnson/bin/which_helper_partA

use strict;
use Term::ANSIColor qw(:constants);

use constant FILE_ALIASDUMP => '/tmp/tmpfs/sj-alias.tmp';

my $query = shift(@ARGV);

unless (length($query)) {
  print "Usage: $0 [query]\n";
  exit(1);
}

unless ( -f FILE_ALIASDUMP ) {
  print "Missing ".FILE_ALIASDUMP."\n";
  exit(2);
}

open (READ, FILE_ALIASDUMP);

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
