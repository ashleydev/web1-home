if [ -n "$1" ] ; then
  
  if [ -f "/home/sjohnson/bin/which_helper_partB.pl" ] ; then

    if [ -d "/tmp/tmpfs/" ] ; then
      alias > /tmp/tmpfs/sj-alias.tmp
      perl /home/sjohnson/bin/which_helper_partB.pl "$1"
      rm /tmp/tmpfs/sj-alias.tmp
    else
      echo Cannot find the ramdisk tmp directory
    fi

  else
    echo Cannot find the after-bootstrap Perl script
  fi

else
  echo Please specify a search parameter
fi
