#!/usr/bin/env bash

# checks whether there non-EN items appear on the FSFE front-page, which is undesired

DIR=$1

# select all items which have the front-page tag
exit=0
for f in $( grep -R "<tag.*>front-page</tag>" --files-with-matches ${DIR}/2*/*.{xhtml,xml} )
do
	base="${f%.*}"      # file.xx
	base="${base%.*}"   # file
	sfx=${f##*.}        # xhtml
	en="$base.en.$sfx"  # file.en.xhtml
	if [[ ! -f "$en" ]]
	then
		echo "$f"         # echo file if it's not existent in an English version
    exit=1
	fi
done

exit $exit
