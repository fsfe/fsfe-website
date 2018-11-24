#/bin/bash
ROOT=$(dirname "$(readlink -f "$0")")
source "$ROOT"/config.cfg
LOC_trunk=$(echo $LOC_trunk | sed 's|/$||')

cd ${LOC_trunk}/news
for f in $( grep -R front-page --files-with-matches 2*/*.{xhtml,xml} )
do
	base="${f%.*}"
	base="${base%.*}"
	sfx=${f##*.}
	en="$base.en.$sfx"
	if [[ ! -f "$en" ]]
	then
		echo "$f"
	fi
done

