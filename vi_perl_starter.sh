#/bin/sh
exec perl /home/sjohnson/bin/vim.pl --group-write=pubstock /home/pubstock/perl --group-write=www-data /home/http --switch-screen=1 "$@"
