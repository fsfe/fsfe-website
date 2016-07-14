#!/bin/bash
# This file takes a .en.xhtml file in output and makes the .po and .pot files.
set -e
set -o pipefail

which html2po


dirname="$(dirname $1)"
prefix="${dirname}/$(basename $1 .en.xhtml)"
potfile="${prefix}.pot"
mkdir -p "${dirname}"

rev(){
    svn info --xml "$1" |
    xmllint --xpath "//entry/commit/@revision" /dev/stdin|
    grep -Eo [0-9]+||echo Unknown
}

html2po "$1" -P "${potfile}"

sed -i '2,10s/\("Project-Id-Version: \).*\(\\n"\)/\1'"$(rev $1)"'\2/' "${potfile}"

shift
LANGUAGES="$@"
for lang in $LANGUAGES
do
    pofile="${prefix}.${lang}.po"
    if test -f "${pofile}"
    then
        msgmerge -U "${pofile}" "${potfile}"
    else
        msginit -l "${lang}" --no-translator -i "${potfile}" -o "${pofile}"
    fi
done
