#!/usr/bin/perl

use strict;
use v5.10.0;

use Cwd qw(realpath);
use File::Basename;
use Data::Dumper;

my $flag_debug = 0; # used to print out verbose details while this script runs

my @vim_files;
my @vim_args;
my @lost_and_found;

my $flag_stdin;
my $flag_switch_screen;
my $time_switch_screen_warn;
my $flag_switch_screen_warning;

my @permission_hashrefs;

=cut

Section A) Why this script was created:
=======================================

- hated being told by Vim that I was accidently piping something to it without the - argument.
- hated piping something from vim to something like grep, and seeing all the garbage on the screen from this mistake.
- hated being prompted with a question that someone else is editing a file.  "Then don't edit it, then!  Quit asking me!" is the attitude I have.
- hated being told I was editing a file already in a different GNU screen window.  Then switch the goddamn window for me! (optional switch in this script)
- hated editing a file, THEN being told I didn't have permission to edit it in the first place.  Now you can specify directories and which group to set the write to.
- hated that grep's -n argument to also print which line of the file wasn't enough to tell vim to edit a file on that line if you copy and paste it with your mouse.
- hated accidently putting a space in the filename and having vim tell me that there were "2 more files to edit" all the time.
- hated editing a directory by accident cause of auto complete and it firing it up its file manager.
- hated using the up-arrow and executing a command like this, because I forgot to remove the previous command:   vi md5sum /some/file.  Now it will edit it.

  Now, I realize that it's probably possible to do the vim screen switching via Vim itself (maybe with a script), but it would take me longer to find it, and get it working,
  and likely it wouldn't work the way I want.  I find writing a front-end gives you complete control.


Section B) Features and how to use them:
========================================

1. Step put this script somewhere, and record the absolute path.  It doesn't need to be in the PATH.

2. Write a .sh bootstrapper script to fire up this perl script.  I use the file /home/sjohnson/vi_perl_starter.sh.  This also doesn't need to be in the PATH.
   The contents of this file look something like this:

   exec perl /home/sjohnson/bin/vim.pl --group-write=wheel /home/something/important --group-write=www-data /home/other/stuff --switch-screen=1 "$@"

3. Edit your .bashrc (or .bash_aliases, whichever you prefer) and add the following export, changing it to suit your own absolute path, of course:

   export EDITOR='/home/sjohnson/vi_perl_starter.sh'

4. Below the above export line, add an alias in the same file.  This will use your bootstrapper now when you write 'vi' as well as allow other programs
   that you may write in the future to "remember" the preferences indicated in Point 2., because calling system('vi', 'file'); from another perl script
   will not execute your arguments for this frontend, but the bootstapper will.

   alias vi="$EDITOR"

5. Re-execute your new bash settings, and get to work!


Section C) Explanation of the arguments, and common uses:
=========================================================
--switch-screen-warning
print a warning on the screen that it will attempt to switch your GNU screen window for you

--user-write=<user>  [dir1] (dir2 .. dir3)
--group-write=<user> [dir1] (dir2 .. dir3)
warn you that the file you are editing does not have write permission, and ask you whether you'd like to have it reset based on the arguments you gave.

--switch-screen(=seconds in integer)
enable the feature to switch your GNU screen window for you.  Ignore the equal-sign and integer to instantly switch it for you.  Note that this uses perl's sleep() function, so decimal numbers are not supported.

Examples of other features:

sjohnson@web1:~$ vi md5sum file.txt # will know you're trying to edit file.txt, not md5sum (checks to see if the file exists first, that's how it knows).

sjohnson@web1:~$ vi file.txt:23 # jump to line 23 in Vim, useful when grep -n returns this sort of <file>:<number> output.


Section D) Known issues
=======================

1. this will only edit the realpath of the file if it already exists.   this is show it shows up easier in the process list.
2. even though there are lists at the top of this file declared, they are lists in case someday my colleagues want the functionality changed
   to allow multiple editing.  If you would like to do that, make sure exec is switched to system and a foreach put in place.
3. if it cannot detect who is editing the file, it is because the commandline used by the editor in the first place is using relative paths, or no one is editing
   it but the swapfile is present nonetheless.
4. if you have told /home to be a group to wheel and /home/derp to be a group to something else something else, likely /home will take precedence first.
   one way to sort this would be to sort the paths by length.. or maybe there's another way.  eventual TODO for some other day.
5. group and user changing is not possible due to limitations of the hash.  perhaps the hash fields could be nested.  also perhaps the way should change too..
   --group(-write)?  i'll decide if it's worth it if i get some free time...
6. someday program an infinite loop check to see that the editor being called is not the script itself.

=cut

if (! -t STDOUT) {
  say "Preventing piping from Vim.  Exiting.";
  exit(1);
}

# scan for debug arg first, since regular @ARGV parsing will undef arguments
foreach (@ARGV) {
  if (! $flag_debug && $_ eq '--debug') {
    $flag_debug = 1;

    # copy original @ARGV array, because it will be modified now and later.
    my @original_argv = @ARGV;

    # get rid of @ARGV's --debug flag, now that it has been processed.
    $_ = undef;

    # display all ARGV originals
    my $i = 0;
    printList('original ARGVs', @original_argv);
  }
}

# counter to process @ARGVs.  starts at -1 so that the first iteration of the foreach loop increases it to start it off at 0.
my $i = -1;
my $allow_next_argv;

foreach (@ARGV) {
  ++$i;

  next if ! defined;

  say "after defined check, arg: [$_]" if $flag_debug;

  my ($pre_colon, $post_colon) = split(/:/);

  if ($allow_next_argv) {
    push(@vim_args, $_);
    undef $allow_next_argv;
  } elsif (-d $_) {
    # disallow directories
    say "$_ is a directory.";
    exit(1);
  } elsif (-d $pre_colon) {
    say "$pre_colon is a directory.";
    exit(1);
  } elsif ($_ eq '--switch-screen-warning') {
    $flag_switch_screen_warning = 1;
  } elsif (m/^--switch-screen(=(\d+))?$/) { # only allow [s]econds
    say "feature enabled: switch screen" if $flag_debug;
    $flag_switch_screen = 1;
    $time_switch_screen_warn = $2;
  } elsif (m/^--(user|group)-write=(.+)$/) {
    
    my $counter_follow = $i + 1;

    while (-d $ARGV[$counter_follow]) {

      my $directory = $ARGV[$counter_follow];

      # since directories will be scanned via regex, a slash should be added to the end to "encapsulate"
      # the last directory name of the path, so the regex is not confused with a the file to be edited
      $directory .= '/' if $directory !~ m{/$};
      my $section = $1;
      my $name = $2;

      push(@permission_hashrefs, { directory_regex => $directory, section => $section, name => $name });

      # get rid ARGV piece
      $ARGV[$counter_follow] = undef;

      ++$counter_follow;
    }

  } elsif (-f $_) {
    push(@vim_files, { file => $_, line => 1 });
  } elsif (-f $pre_colon && $post_colon =~ m/^[0-9]+$/) {
    push(@vim_files, { file => $pre_colon, line => $post_colon });
  } elsif (defined(my $gitfile = getPath_ab($_))) {
    push(@vim_files, { file => $gitfile, line => 1 });
  } elsif (defined(my $gitfile = getPath_ab($pre_colon)) && $post_colon =~ m/^[0-9]+$/) {
    push(@vim_files, { file => $gitfile, line => $post_colon });
  } elsif ($_ eq '-') {
    $flag_stdin = 1;
    push(@vim_args, $_);
  } elsif ($_ eq '-c') {
    push(@vim_args, $_);
    # this vim argument expects the next ARGV to be a command to execute, so set the flag to allow it to do so without scrutiny
    say "setting allow_next_argv toggle..." if $flag_debug;
    $allow_next_argv = 1;
  } elsif (m/^(\+|-)/) {
    push(@vim_args, $_);
  } else {
    push(@lost_and_found, $_);
  }

}

if (! -t STDIN && ! $flag_stdin) {
  say "Preventing piping to Vim.  Exiting.";
  exit(1);
}

my @cmd;

# do NOT use the shell environment variable EDITOR here, as it will cause an infinite loop.
# the idea is that because you can't run an alias from perl by using system() is the beauty of the script
if (my $hashref_file_data = shift(@vim_files)) {
  my $file = $hashref_file_data->{file};
  my $file_realpath = realpath($file);

  my $line = $hashref_file_data->{line};

  unshift(@vim_args, "+$line") if ($line > 1);

  if (@permission_hashrefs && ! -w $file) {
    foreach (@permission_hashrefs) {
      if ($file_realpath =~ m/^$_->{directory_regex}/) {
	askToChangePermission($file_realpath, $_);
      }
    }
  }

  @cmd = ('vi', $file_realpath, @vim_args);

} elsif (my $first_and_only_try = shift(@lost_and_found)) {
  @cmd = ('vi', $first_and_only_try, @vim_args);
} else {
  @cmd = ('vi', @vim_args);
}

my $file_to_edit = $cmd[1];

if ($flag_debug) {

  # display all @cmd values
  printList('vi cmd', @cmd);

  # pause for debug mode.
  pauseMsg() if $flag_debug;
}

if (defined($file_to_edit)) {

  my $file_to_edit_dirname = dirname($file_to_edit);
  my $file_to_edit_basename = basename($file_to_edit);

  if ($file_to_edit_basename !~ m/^\./) {
    # add period to filename if none found
    $file_to_edit_basename = ".$file_to_edit_basename";
  }

  if (-f "$file_to_edit_dirname/$file_to_edit_basename.swp") {

    my $ps_query_regex = "vim? $file_to_edit";
    say "ps query: $ps_query_regex" if $flag_debug;
    my ($user, $ip, $stat, $screen_window) = getVimPsWhoInfo($ps_query_regex);

    my $buf;

    # check for user and ip from 'who' command
    if (defined($user) && defined($ip)) {
      $buf .= "Found swap file from $user, from $ip";

      # check if screen window provided
      if (defined($screen_window)) {
	if ($ENV{USER} eq $user && $ENV{WINDOW} eq $screen_window) {
	  $buf .= ", on your current window ($screen_window)";
	} else {
	  $buf .= ", on screen window $screen_window";
	}
      }

    } else {
      $buf .= "Found swap file, but unable to determine who is editing it.";
    }

    if (defined($stat) && $stat eq 'T') {
      $buf .= " (backgrounded)";
    }

    print "$buf\n";

    if ($flag_switch_screen && defined($screen_window) && defined($user) && $ENV{USER} eq $user && $ENV{WINDOW} ne $screen_window) {
      say "Switching to screen $screen_window..." if $flag_switch_screen_warning;
      if (defined($time_switch_screen_warn)) {
	sleep($time_switch_screen_warn);
      }
      system('screen', '-X', 'select', $screen_window);
    }

    exit(1);
  }
}

# run commands
exec(@cmd) if @cmd;

# ---- getRevParseCdup getPath_ab - copied from Sjohnson::Git to not rely on external files
sub getRevParseCdup {
  my $buffer = `git rev-parse --show-cdup`;
  chomp($buffer);

  return $buffer;
}

sub getPath_ab {
  my $file = shift;

  if ($file =~ m{^(a|b)/}) {
    $file =~ s/^$&/getRevParseCdup($file)/e;

    if (-f $file) {
      return $file;
    }
  }

  return undef;
}

sub getVimPsWhoInfo {
  my $ps_query = shift;

  my $user;
  my $ip;
  my $screen_window;

  my $first_relevant_ps_line = (grep(/$ps_query/, split (/\n/, `ps aux`)))[0];
  return unless defined $first_relevant_ps_line;

  my @ps_chunks = split(' ', $first_relevant_ps_line);
  $user = $ps_chunks[0];
  my $pts = $ps_chunks[6];
  my $stat = $ps_chunks[7];

  my $first_relevant_who_line = (grep(/$user \s+ $pts/x, split (/\n/, `who`)))[0];
  return unless defined($first_relevant_who_line);

  my @who_chunks = split(' ', $first_relevant_who_line);
  my $host_info = pop(@who_chunks);
  if ($host_info =~ m/^\((.*?)(:S.(\d+))?\)/i) {
    $ip = $1;
    $screen_window = $3;
  }

  return ($user, $ip, $stat, $screen_window);
}

sub askToChangePermission {
  my $file = shift;
  my $hashref = shift;

  print "Would you like to change the $hashref->{section} permissions to $hashref->{name} on $file? [yes/no]: ";
  chomp(my $answer = <STDIN>);

  if ($answer !~ m/^y/i) {
    return;
  }

  my $chown_arg;
  given($hashref->{section}) {

    when ('user') {
     my @cmd_chown = ('sudo', 'chown', $hashref->{name}, $file);
     say Dumper @cmd_chown if $flag_debug;
     system(@cmd_chown);

     my @cmd_chmod = ('sudo', 'chmod', 'u+w', $file);
     say Dumper @cmd_chmod if $flag_debug;
     system(@cmd_chmod);
    }

    when ('group') {
     my @cmd_chgrp = ('sudo', 'chgrp', $hashref->{name}, $file);
     say Dumper @cmd_chgrp if $flag_debug;
     system(@cmd_chgrp);

     my @cmd_chmod = ('sudo', 'chmod', 'g+w', $file);
     say Dumper @cmd_chmod if $flag_debug;
     system(@cmd_chmod);
    }

    die "unknown group/user mode";
  }

  pauseMsg() if $flag_debug;

}

sub pauseMsg {
  print "Press enter to continue . . .";
  my $dummy = <STDIN>;
}

sub printList {
  my $title = shift;
  if (@_) {
    my $i = 0;
    foreach (@_) {
      say $title.'['.$i.'] = ['.$_.']';
      ++$i;
    }
  } else {
    say "Empty array for: $title";
  }
}
