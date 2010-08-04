if [ -n "$1" ] ; then
  
  if [ -f "/home/sjohnson/bin/which_helper_partB.pl" ] ; then

    RAMTMP="/tmp/tmpfs"
    REGTMP="/tmp"

    unset DIR_TO_USE

    if [ -d "$RAMTMP" ] ; then
      DIR_TO_USE="$RAMTMP"
    elif [ -d "$REGTMP" ] ; then
      DIR_TO_USE="$REGTMP"
    fi

    #echo "using $DIR_TO_USE as temp directory"

    if [ $DIR_TO_USE ] ; then
      alias > "$DIR_TO_USE/sj-alias.tmp"
      perl /home/sjohnson/bin/which_helper_partB.pl "$1"
      rm "$DIR_TO_USE/sj-alias.tmp"
    else
      echo Cannot find the ramdisk tmp directory
    fi

    unset RAMTMP
    unset REGTMP
    unset DIR_TO_USE

  else
    echo Cannot find the after-bootstrap Perl script
  fi

else
  echo Please specify a search parameter
fi
