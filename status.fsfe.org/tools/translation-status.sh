#!/usr/bin/env bash
set -euo pipefail

while getopts h OPT; do
	case $OPT in
	h)
		print_usage
		exit 0
		;;
	*)
		echo "Unknown option: -$OPTARG"
		print_usage
		exit 1
		;;
	esac
done
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
readonly SCRIPT_DIR
REPO="$SCRIPT_DIR"/../..
readonly REPO
OUT="${REPO}"/status.fsfe.org/translations/data
readonly OUT
OUT_TMP="${REPO}"/status.fsfe.org/translations/data-tmp
readonly OUT_TMP

cd "${REPO}" || exit 2

echo "Making required directories!"
mkdir -p "$OUT"
mkdir -p "$OUT_TMP"

LOGFILE="${OUT_TMP}/log.txt"

langs="$(
	find ./global/languages -type f -printf "%f\n" | while read -r lang; do
		echo "$lang $(cat ./global/languages/"$lang")"
	done
)"
readonly langs
texts_dir="global/data/texts"
readonly texts_dir
texts_en=$(grep 'id=".*"' ${texts_dir}/texts.en.xml | perl -pe 's/.*id=\"(.*?)\".*/\1/g')
readonly texts_en

# Make filedates match git commits
echo "Begin syncing filedates with git commit dates" | tee "${LOGFILE}"
"$SCRIPT_DIR"/filedate-sync-git.sh >>"${LOGFILE}"
echo "File date sync finished" | tee -a "${LOGFILE}"
files=""
# Grouped by priority
files+=$'\n'$(find ./index.en.xhtml | sed 's/$/ 1/')
files+=$'\n'$(find ./freesoftware/freesoftware.en.xhtml | sed 's/$/ 1/')

files+=$'\n'$(find ./activities -type f \( -iname "activity\.en\.xml" \) | sed 's/$/ 2/')

files+=$'\n'$(find ./activities -type f \( -iname "*\.en\.xhtml" -o -iname "*\.en\.xml" \) | sed 's/$/ 3/')
files+=$'\n'$(find ./freesoftware -type f \( -iname "*\.en\.xhtml" -o -iname "*\.en\.xml" \) | sed 's/$/ 3/')

files+=$'\n'$(find ./order -maxdepth 1 -type f \( -iname "*\.en\.xhtml" -o -iname "*\.en\.xml" \) | sed 's/$/ 4/')
files+=$'\n'$(find ./contribute -maxdepth 1 -type f \( -iname "spreadtheword*\.en\.xhtml" -o -iname "spreadtheword*\.en\.xml" \) | sed 's/$/ 4/')

files+=$'\n'$(find . -type f \( -iname "*\.en\.xhtml" -o -iname "*\.en\.xml" \) -mtime -200 -not -path './news/*' -not -path './events/*' | sed 's/$/ 5/')
files+=$'\n'$(find ./news -type f \( -iname "*\.en\.xhtml" -o -iname "*\.en\.xml" \) -mtime -30 | sed 's/$/ 5/')
# Remove files that are not in the list of those managed by git
tmp=""
files="$(
	echo "$files" | while read -r line priority; do
		if [[ "$(git ls-files | grep -o "${line:2}" | wc -l)" -ge 1 ]] && [[ "$(echo "$tmp" | grep "$line")" == "" ]]; then
			echo "$line" "$priority"
			tmp+="$line"
		fi
	done
)"
unset tmp
files=$(echo "$files" | grep -v "internal\|order\/data\/items\.en\.xml\|donate\/germany\|donate\/netherlands\|donate\/switzerland\|status.fsfe.org\|boilerplate\|\/\..*\.xml\|)")
readonly files

prevlang=""
prevprio=""
echo "Begin generating translation status for all languages" | tee -a "$LOGFILE"
statuses="$(
	echo "$files" | while read -r fullname priority; do
		ext="${fullname##*.}"
		base="${fullname//\.[a-z][a-z]\.${ext}/}"
		original_version=$(xsltproc build/xslt/get_version.xsl "$base".en."$ext")
		echo "$langs" | while read -r lang_short lang_long; do
			i="$base"."$lang_short"."$ext"
			echo "Processing file $i" >>"$LOGFILE"
			if [[ -f $i ]]; then
				translation_version=$(xsltproc build/xslt/get_version.xsl "$i")
			else
				translation_version="-1"
			fi
			if [ "${translation_version:-0}" -lt "${original_version:-0}" ]; then
				originaldate=$(git log --pretty="%cd" --date=raw -1 "$base".en."$ext" | cut -d' ' -f1)
				if [ "$ext" == "xhtml" ]; then
					original_url="https://webpreview.fsfe.org?uri=/${base/#\.\//}.en.html"
					translation_url="https://webpreview.fsfe.org?uri=/${base/#\.\//}.$lang_short.html"
				elif [ "$ext" == "xml" ]; then
					original_url="https://git.fsfe.org/FSFE/fsfe-website/src/branch/master/${base/#\.\//}.en.xml"
					translation_url="https://git.fsfe.org/FSFE/fsfe-website/src/branch/master/${base/#\.\//}.$lang_short.xml"
				else
					translation_url="#"
					original_url="#"
				fi
				if [ "$translation_version" == "-1" ]; then
					translation_url="#"
				fi
				echo "$lang_short $lang_long $base $priority $originaldate $original_url $original_version $translation_url ${translation_version/-1/Untranslated}"
			fi
		done
	done | sort -t' ' -k 1,1 -k 4,4 -k 3,3 | cat - <(echo "zz zz zz zz zz zz zz zz zz")
)"
echo "Status Generated" | tee -a "$LOGFILE"

echo "Generate language status overview" | tee -a "$LOGFILE"
cat >"${OUT_TMP}/langs.en.xml" <<-EOF
	<?xml version="1.0" encoding="UTF-8"?>

	<translation-overall-status>
	<version>1</version>
EOF
echo "$langs" | while read -r lang_short lang_long; do
	declare -A prio_counts
	for i in {1..6}; do
		prio_counts["$i"]="<priority number=\"$i\" value=\"$(echo "$statuses" | sed -n "/^$lang_short\ $lang_long\ [^\ ]*\ $i/p" | wc -l)\"/>"
	done
	cat >>"${OUT_TMP}/langs.en.xml" <<-EOF
		<language short="$lang_short" long="$lang_long">
		${prio_counts["1"]}
		${prio_counts["2"]}
		</language>
	EOF
	unset prio_counts
done
cat >>"${OUT_TMP}/langs.en.xml" <<-EOF
	</translation-overall-status>
EOF
echo "Finished Generating status overview" | tee -a "$LOGFILE"
echo "Create language pages" | tee -a "$LOGFILE"
echo "$statuses" | while read -r lang_short lang_long page priority originaldate original_url original_version translation_url translation_version; do
	if [[ "$prevlang" != "$lang_short" ]]; then
		if [[ "$prevlang" != "" ]]; then
			# Translatable strings
			texts_file="${texts_dir}/texts.${prevlang}.xml"
			missing_texts=()
			longest_text_length=0
			for text in $texts_en; do
				if ! xmllint --xpath "//text[@id = \"${text}\"]" "${texts_file}" &>/dev/null; then
					missing_texts+=("$text")
					tmp_length="${#text}"
					if [ "$tmp_length" -gt "$longest_text_length" ]; then
						longest_text_length="$tmp_length"
					fi
				fi
			done

			for index in "${!missing_texts[@]}"; do
				missing_texts["$index"]="<text>${missing_texts["$index"]}</text>"$'\n'
			done

			cat >>"${OUT_TMP}/translations.$prevlang.xml" <<-EOF
				</priority>  
				<missing-texts>
				<url>https://git.fsfe.org/FSFE/fsfe-website/src/branch/master/${texts_file}</url> 
				<max-length>$((longest_text_length + 5))ch</max-length>
				<filename> $texts_file</filename>
				${missing_texts[*]}     
				</missing-texts>
				</translation-status>
			EOF
			if [[ "$lang_short" == "zz" ]]; then
				break
			fi
		fi
		cat >"${OUT_TMP}/translations.$lang_short.xml" <<-EOF
			<?xml version="1.0" encoding="UTF-8"?>

			<translation-status>
			<version>1</version>
		EOF
		prevprio=""
		prevlang=$lang_short
	fi
	if [[ "$priority" != "$prevprio" ]]; then
		if [[ "$prevprio" != "" ]]; then
			cat >>"${OUT_TMP}/translations.$lang_short.xml" <<-EOF
				</priority>  
			EOF
		fi
		cat >>"${OUT_TMP}/translations.$lang_short.xml" <<-EOF
			<priority value="$priority">
		EOF
		prevprio=$priority
	fi
	orig=$(date +"%Y-%m-%d" --date="@$originaldate")

	if [[ $originaldate -gt $(date +%s --date='6 months ago') ]]; then
		new=true
	else
		new=false
	fi
	cat >>"${OUT_TMP}/translations.$lang_short.xml" <<-EOF
		<file>
			<page>$page</page>
			<original_date>$orig</original_date>
			<new>$new</new>
			<original_url>$original_url</original_url> 
			<original_version>$original_version</original_version>
			<translation_url>$translation_url</translation_url> 
			<translation_version>$translation_version</translation_version>  
		</file>
	EOF
done
echo "Finished creating language pages" | tee -a "$LOGFILE"

rsync -avz --delete --remove-source-files "$OUT_TMP"/ "$OUT"/
echo "Finished !"
