#!/usr/bin/perl

$date_HHMM = `date '+%H%M'`; chomp $date_HHMM;

use constant ELEVEN_OCLOCK => 2300;
use constant ELEVEN_THIRTY => 2330;

if ($date_HHMM >= ELEVEN_OCLOCK) { # 2300 == 11:30pm
  print "WARNING!  You're approaching midnight.  Start doing a backup NOW if you haven't already done one yet.\n";
  if ($date_HHMM >= ELEVEN_THIRTY) {
    exit(1);
  } else {
    $dummy = <>;
  }
}
