#!/usr/bin/perl

use strict;
use v5.10.0;

use File::Basename;
use Term::ANSIColor qw(:constants);

my $flag_insensitive_change;
my @crude_args;

sub slurp { my $name = shift; open my $fh, '<', $name; local $/; <$fh> }

# ===

foreach (@ARGV) {
  when ("-i") { $flag_insensitive_change = 1; }
  default { push(@crude_args, $_); }
}

unless (scalar(@crude_args) == 2) {
  say "Purpose: to quickly make a s///g(i) on a list of files, determined by STDIN.";
  print "\n";
  say "Usage: ".basename($0)." (-i) [before] [after]";
  exit(1);
}

my @files;
my $before = shift(@crude_args);
my $after = shift(@crude_args);

while (<STDIN>) {
  chomp;
  my $file = $_;

  next unless (length($file));
  push(@files, $file);
}

print "\n";

foreach my $file (@files) {

  unless (-f $file) {
    say BOLD, RED, "$file - cannot find", RESET;
    next;
  }

  unless (-r $file && -w $file) {
    say BOLD, BLUE, "$file - need write permission", RESET;
    next;
  }

  my $buffer_in = slurp($file);

  my $bool_matches;
  if ($flag_insensitive_change) {
    if ($buffer_in =~ m/$before/i) { $bool_matches = 1; }
  } else {
    if ($buffer_in =~ m/$before/) { $bool_matches = 1; }
  }

  if ($bool_matches) {

    my $buffer_out = $buffer_in; # copy
    if ($flag_insensitive_change) {
      $buffer_out =~ s/$before/$after/gi;
    } else {
      $buffer_out =~ s/$before/$after/g;
    }

    open (WRITE, ">$file");
    print WRITE $buffer_out;
    if (close(WRITE)) {
      say BOLD, GREEN, "$file - saved", RESET;
    }
  } else {
    say "$file - cannot find string match";
  }

}
