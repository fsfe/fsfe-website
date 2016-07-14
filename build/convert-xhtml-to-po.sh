#!/bin/bash
# This file takes a .en.xhtml file in output and makes the .po and .pot files.
i10ndirname="build/i10n/$(dirname $1)"
i10nprefix="${i10ndirname}/$(basename $1 .en.xhtml)"
potfile="${i10nprefix}.pot"
mkdir -p "${i10ndirname}"
html2po "$1" -P "${potfile}"
shift
LANGUAGES="$@"
for lang in $LANGUAGES
do
    pofile="${i10nprefix}.${lang}.po"
    if test -f "${pofile}"
    then
        msgmerge -U "${pofile}" "${potfile}"
    else
        msginit -l "${lang}" --no-translator -i "${potfile}" -o "${pofile}"
    fi
done
