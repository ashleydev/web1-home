#!/usr/bin/perl

use strict;
use v5.10.0;

use Digest::MD5 qw(md5_hex);

my $amount = shift(@ARGV);

my $base = md5_hex('');

for (1..$amount) {
  $base = md5_hex($base);
}

say $base;
