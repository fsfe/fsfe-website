#!/usr/bin/env bash
set -euo pipefail
print_usage() { echo "make-outdated-list.sh -o outdir -r repo_path"; }

while getopts o:r:h OPT; do
	case $OPT in
	o) OUT=$OPTARG ;;
	r) REPO=$OPTARG ;;
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

if [[ -z "${OUT}" || -z "${REPO}" ]]; then
	echo "Mandatory option missing:"
	print_usage
	exit 1
fi

cd "${REPO}" || exit 2

prevlang=''
texts_dir="global/data/texts"
texts_en=$(grep 'id=".*"' ${texts_dir}/texts.en.xml | perl -pe 's/.*id=\"(.*?)\".*/\1/g')

OUT_TMP="${OUT}/.tmp-translations"
LOGFILE="${OUT}/log.txt"
echo "Making required dirs." | tee "$LOGFILE"
mkdir -p "${OUT_TMP}/translations" || exit

echo "Making index" | tee -a "$LOGFILE"
cat >"${OUT_TMP}/translations.html" <<-EOF
	<!DOCTYPE html>
	<html lang="en">
	<h1>Translation Status Page</h1>
	<body>
	<p>Click on the links below to jump to a particular language</p>
EOF
: >"${OUT_TMP}/translations/langs.txt"
find . -type f -iname "*\.en\.xhtml" | sed 's/\.[a-z][a-z]\.xhtml//' | sort | while read -r A; do
	for i in "$A".[a-z][a-z].xhtml; do
		# shellcheck disable=SC2001
		lang_uniq=$(echo "$i" | sed 's/.*\.\([a-z][a-z]\)\.xhtml/\1/')
		if [ "$lang_uniq" != "en" ]; then
			echo "$lang_uniq"
		fi
	done
done | sort | uniq | while read -r lang_uniq; do
	cat >>"${OUT_TMP}/translations.html" <<-EOF
		<a href="/translations/$lang_uniq.html">$lang_uniq</a>
	EOF
	cat >>"${OUT_TMP}/translations/langs.txt" <<-EOF
		$lang_uniq
	EOF
done

cat >>"${OUT_TMP}/translations.html" <<-EOF
	</body>
	</html>
EOF
echo "Index finished" | tee -a "$LOGFILE"

# Make filedates match git commits
echo "Begin syncing filedates with git commit dates" | tee -a "${LOGFILE}"
./tools/filedate-sync-git.sh >>"${LOGFILE}"
echo "File date sync finished" | tee -a "${LOGFILE}"
# Recently edited files, except news and events
echo "Search 1" >>"$LOGFILE"
files=$(find . -type f \( -iname "*\.en\.xhtml" -o -iname "*\.en\.xml" \) -mtime -365 -not -path './news/*' -not -path './events/*' | tee -a "$LOGFILE")
# News must be more recent
echo "Search 2" | tee -a "$LOGFILE"
files+=$'\n'$(find ./news -type f \( -iname "*\.en\.xhtml" -o -iname "*\.en\.xml" \) -mtime -30 | tee -a "$LOGFILE")
# Files in root directory, probably important
echo "Search 3" | tee -a "$LOGFILE"
files+=$'\n'$(find . -maxdepth 1 -type f \( -iname "*\.en\.xhtml" -o -iname "*\.en\.xml" \) | tee -a "$LOGFILE")
# Activitities are important
echo "Search 4" | tee -a "$LOGFILE"
files+=$'\n'$(find ./activities -type f \( -iname "*\.en\.xhtml" -o -iname "*\.en\.xml" \) | tee -a "$LOGFILE")
# Remove files that are not in the list of those managed by git
files="$(echo "$files""$(git ls-files)" | sort | uniq -d)"
# List of extra dirs/files to exclude
exclude=(
	# Internal pages
	"internal"
	# Order Items
	"order/.*/item"
	# Stuff not really important for other languages
	"donate/germany"
	"donate/netherlands"
	"donate/switzerland"
	# The boiler plate
	"boilerplate"
	# Some misc xml files
	"/\..*\.xml"
)
exclude_string=""
exclude_indexes=("${!exclude[@]}")
last_index=${exclude_indexes[-1]}
for index in "${!exclude[@]}"; do
	exclude["$index"]="$(echo "${exclude["$index"]}" | xargs | sed 's/\//\\\//g')"
	if [[ "$index" != "$last_index" ]]; then
		exclude_string+="${exclude["$index"]}\|"
	else
		exclude_string+="${exclude["$index"]}"
	fi
done
echo "Pre exclusion files:"$'\n'"${files}" >>"$LOGFILE"
echo "Excluding according to pattern: ${exclude_string}" >>"$LOGFILE"
echo "Excluding unwanted files" | tee -a "$LOGFILE"
files=$(echo "$files" | grep -v "$exclude_string" | sort)
echo "Post exclusion files:"$'\n'"${files}" >>"$LOGFILE"

echo "Begin generating language status for found langs" | tee -a "$LOGFILE"
echo "$files" | while read -r fullname; do
	ext="${fullname##*.}"
	base="${fullname//\.[a-z][a-z]\.${ext}/}"
	original_version=$(xsltproc build/xslt/get_version.xsl "$base".en."$ext")
	while read -r lang; do
		i="$base"."$lang"."$ext"
		echo "Processing file $i" >>"$LOGFILE"
		if [[ -f $i ]]; then
			translation_version=$(xsltproc build/xslt/get_version.xsl "$i")
		else
			translation_version="-1"
		fi
		if [ "${translation_version:-0}" -lt "${original_version:-0}" ]; then
			originaldate=$(git log --pretty="%cd" --date=raw -1 "$base".en."$ext" | cut -d' ' -f1)
			# shellcheck disable=SC2001
			lang=$(echo "$i" | sed "s/.*\.\([a-z][a-z]\)\.$ext/\1/")
			if [ "$ext" == "xhtml" ]; then
				original_url="https://webpreview.fsfe.org?uri=/${base/#\.\//}.en.html"
				translation_url="https://webpreview.fsfe.org?uri=/${base/#\.\//}.$lang.html"
			elif [ "$ext" == "xml" ]; then
				original_url="https://git.fsfe.org/FSFE/fsfe-website/src/branch/master/${base/#\.\//}.en.xml"
				translation_url="https://git.fsfe.org/FSFE/fsfe-website/src/branch/master/${base/#\.\//}.$lang.xml"
			else
				translation_url="#"
				original_url="#"
			fi
			if [ "$translation_version" == "-1" ]; then
				translation_url="#"
			fi
			echo "$lang $base $originaldate $original_url $original_version $translation_url ${translation_version/-1/Untranslated}"
		fi
	done <"${OUT_TMP}/translations/langs.txt"
done | sort -t' ' -k 1,1 -k 7,7 -k 2,2 |
	while read -r lang page originaldate original_url original_version translation_url translation_version; do
		if [[ "$prevlang" != "$lang" ]]; then
			if [[ "$prevlang" != "" ]]; then
				cat >>"${OUT_TMP}/translations/$prevlang.html" <<-EOF
					</table>  
				EOF

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
				echo "Longest text length for ${prevlang}: ${longest_text_length}" | tee -a "$LOGFILE"
				for index in "${!missing_texts[@]}"; do
					missing_texts["$index"]="<li style=\"display: inline-block; width: ${longest_text_length}em;\">${missing_texts["$index"]}</li>"$'\n'
				done

				cat >>"${OUT_TMP}/translations/$prevlang.html" <<-EOF
					<p>
					Missing texts in <a style="width: 100%;" href="https://git.fsfe.org/FSFE/fsfe-website/src/branch/master/${texts_file}">${texts_file}</a>:
					</p> 
					<ul>
					</ul>
					${missing_texts[*]}     
					</body>
					</html>
				EOF
			fi
			cat >"${OUT_TMP}/translations/$lang.html" <<-EOF
				<!DOCTYPE html>
				<html lang="en">
				<body>
				<h1 id="$lang">Language: $lang</h1>
				<p><span style="color: red">Red entries</span> are pages where the original is newer than 6 months.</p>
				<table>
				<tr><th>Page</th><th>Original date</th><th>Original version</th><th>Translation version</th></tr>
			EOF
			prevlang=$lang
		fi
		orig=$(date +"%Y-%m-%d" --date="@$originaldate")

		if [[ $originaldate -gt $(date +%s --date='6 months ago') ]]; then
			color='color: red;'
		else
			color=''
		fi
		cat >>"${OUT_TMP}/translations/$lang.html" <<-EOF
			<tr><td><a style="width: 100%; $color">$page</a></td><td>$orig</td><td><a href="$original_url">$original_version</a></td><td><a href="$translation_url">$translation_version</a></td></tr> 
		EOF
	done
echo "Finished creating language pages" | tee -a "$LOGFILE"

echo "Replacing old output" | tee -a "$LOGFILE"
rm -r -f "${OUT}/translations"
mv -f "${OUT_TMP}"/* "${OUT}"
rm -r "${OUT_TMP}"
echo "Finished" | tee -a "$LOGFILE"
rm "$LOGFILE"
