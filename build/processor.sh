#!/usr/bin/env bash

inc_processor=true
[ -z "$inc_filenames" ] && . "$basedir/build/filenames.sh"
[ -z "$inc_scaffold" ]  && . "$basedir/build/scaffold.sh"

process_file(){
  infile="$1"
  processor="$2"

  shortname=$(get_shortname "$infile")
  lang=$(get_language "$infile")

  if [ -z "${processor}" ]; then
    if [ -f "${shortname}.xsl" ]; then
      processor="${shortname}.xsl"
    else
      # Actually use the symlink target, so the relative includes are searched
      # in the correct directory.
      processor="$(realpath "${shortname%/*}/.default.xsl")"
    fi
  fi

  # Make sure that the following pipe exits with a nonzero exit code if *any*
  # of the commands fails.
  set -o pipefail

  # The sed command of death below does the following:
  # 1. Remove https://fsfe.org (or https://test.fsfe.org) from the start of all
  #    links
  # 2. Change links from /foo/bar.html into /foo/bar.xx.html
  # 3. Change links from foo/bar.html into foo/bar.xx.html
  # 4. Same for .rss and .ics links
  # 5. Change links from /foo/bar/ into /foo/bar/index.xx.html
  # 6. Change links from foo/bar/ into foo/bar/index.xx.html
  # ... where xx is the language code.
  # Everything is duplicated to allow for the href attribute to be enclosed in
  # single or double quotes.
  # I am strongly convinced that there must be a less obfuscated way of doing
  # this. --Reinhard

  build_xmlstream "$shortname" "$lang" \
  | xsltproc --stringparam "build-env" "${build_env:-development}" "$processor" - \
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
