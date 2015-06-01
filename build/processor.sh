#!/bin/sh

inc_processor=true
[ -z "$inc_filenames" ] && . "$basedir/build/filenames.sh"
[ -z "$inc_scaffold" ]  && . "$basedir/build/scaffold.sh"

process_file(){
  infile="$1"
  processor="$2"
  olang="$3"

  shortname=$(get_shortname "$infile")
  lang=$(get_language "$infile")
  [ -z "$processor" ] && processor="$(get_processor "$shortname")"

  build_xmlstream "$shortname" "$lang" "$olang" \
  | xsltproc "$processor" - \
  | sed -r '
      s;< *(a|link)( [^>]*)? href="https?://'"$domain"'/([^"]*)";<\1\2 href="/\3";g
      s;< *(a|link)( [^>]*)? href='\''https?://'"$domain"'/([^'\'']*)'\'';<\1\2 href='\''/\3'\'';g

      s;< *(a|link)( [^>]*)? href="(https?://[^"]*)";<\1\2 href="#== norewrite ==\3";g
      s;< *(a|link)( [^>]*)? href="([^#"])([^"]*/)?([^\./"]*\.)(html|rss|ics)(#[^"]*)?";<\1\2 href="\3\4\5'"$lang"'.\6\7";g
      s;< *(a|link)( [^>]*)? href="([^#"]*/)(#[^"]*)?";<\1\2 href="\3index.'"$lang"'.html\4";g
      s;< *(a|link)( [^>]*)? href="#== norewrite ==(https?://[^"]*)";<\1\2 href="\3";g

      s;< *(a|link)( [^>]*)? href='\''(https?://[^'\'']*)'\'';<\1\2 href='\''#== norewrite ==\3'\'';g
      s;< *(a|link)( [^>]*)? href='\''([^#'\''])([^'\'']*/)?([^\./'\'']*\.)(html|rss|ics)(#[^'\'']*)?'\'';<\1\2 href='\''\3\4\5'"$lang"'.\6\7'\'';g
      s;< *(a|link)( [^>]*)? href='\''([^#'\'']*/)(#[^'\'']*)?'\'';<\1\2 href='\''\3index.'"$lang"'.html\4'\'';g
      s;< *(a|link)( [^>]*)? href='\''#== norewrite ==(https?://[^'\'']*)'\'';<\1\2 href='\''\3'\'';g
  '
}
