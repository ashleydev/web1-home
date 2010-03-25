#!/usr/bin/perl

use strict;

use File::Basename;

while (<STDIN>) {
  chomp;
  print basename($_)."\n";
}
