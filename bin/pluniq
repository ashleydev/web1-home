#!/usr/bin/perl

use strict;

my $while_handler;
my $file;
my $flag_keep_blank_lines;

foreach (@ARGV) {
  if (m/^(-k|--keep-blank-lines)$/) { $flag_keep_blank_lines = 1; }
  elsif ( -f $_ ) { $file = $_; }
}

if ( $file ) {
  open (FH, $file);
  $while_handler = "FH";
} else {
  $while_handler = "STDIN";
}

my %dupes;

while (<$while_handler>) {

  if ($dupes{$_}) {
    # nothing
  } else {
    if ( $flag_keep_blank_lines && (m/^\s*$/) ) {
      # if this flag is set, this will keep the nice whitespace spacing in your file.  handy for ini files that are spaced nicely.
    } else {
      $dupes{$_} = 1;
    }
    print $_;
  }

}
