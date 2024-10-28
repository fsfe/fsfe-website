#!/usr/bin/env bash

inc_filenames=true

get_language(){
  # extract language indicator from a given file name
  echo "$(echo "$1" |sed -r 's:^.*\.([a-z]{2})\.[^\.]+$:\1:')";
}

get_shortname(){
  # get shortened version of a given file name
  # required for internal processing

  #echo "$(echo "$1" | sed -r 's:\.[a-z]{2}.xhtml$::')";
  echo "${1%.??.xhtml}"
}
