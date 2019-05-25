#!/bin/bash

inc_processor=true
[ -z "$inc_filenames" ] && . "$basedir/build/filenames.sh"
[ -z "$inc_scaffold" ]  && . "$basedir/build/scaffold.sh"

process_file(){
  infile="$1"
  processor="$2"

  shortname=$(get_shortname "$infile")
  lang=$(get_language "$infile")
  [ -z "$processor" ] && processor="$(get_processor "$shortname")"

  # Make sure that the following pipe exits with a nonzero exit code if *any*
  # of the commands fails.
  set -o pipefail

  build_xmlstream "$shortname" "$lang" \
  | xsltproc "$processor" - \
  | sed -r ':X; N; $!bX;
      s;<[\r\n\t ]*(a|link)([\r\n\t ][^>]*)?[\r\n\t ]href="(https?:)?//'"$domain"'/([^"]*)";<\1\2 href="/\4";gI
      s;<[\r\n\t ]*(a|link)([\r\n\t ][^>]*)?[\r\n\t ]href='\''(https?:)?//'"$domain"'/([^'\'']*)'\'';<\1\2 href='\''/\4'\'';gI

      s;<[\r\n\t ]*(a|link)([\r\n\t ][^>]*)?[\r\n\t ]href="((https?:)?//[^"]*)";<\1\2 href="#== norewrite ==\3";gI
      s;<[\r\n\t ]*(a|link)([\r\n\t ][^>]*)?[\r\n\t ]href="([^#"])([^"]*/)?([^\./"]*\.)(html|rss|ics)(#[^"]*)?";<\1\2 href="\3\4\5'"$lang"'.\6\7";gI
      s;<[\r\n\t ]*(a|link)([\r\n\t ][^>]*)?[\r\n\t ]href="([^#"]*/)(#[^"]*)?";<\1\2 href="\3index.'"$lang"'.html\4";gI
      s;<[\r\n\t ]*(a|link)([\r\n\t ][^>]*)?[\r\n\t ]href="#== norewrite ==((https?:)?//[^"]*)";<\1\2 href="\3";gI

      s;<[\r\n\t ]*(a|link)([\r\n\t ][^>]*)?[\r\n\t ]href='\''((https?:)?//[^'\'']*)'\'';<\1\2 href='\''#== norewrite ==\3'\'';gI
      s;<[\r\n\t ]*(a|link)([\r\n\t ][^>]*)?[\r\n\t ]href='\''([^#'\''])([^'\'']*/)?([^\./'\'']*\.)(html|rss|ics)(#[^'\'']*)?'\'';<\1\2 href='\''\3\4\5'"$lang"'.\6\7'\'';gI
      s;<[\r\n\t ]*(a|link)([\r\n\t ][^>]*)?[\r\n\t ]href='\''([^#'\'']*/)(#[^'\'']*)?'\'';<\1\2 href='\''\3index.'"$lang"'.html\4'\'';gI
      s;<[\r\n\t ]*(a|link)([\r\n\t ][^>]*)?[\r\n\t ]href='\''#== norewrite ==((https?:)?//[^'\'']*)'\'';<\1\2 href='\''\3'\'';gI
  '
}
