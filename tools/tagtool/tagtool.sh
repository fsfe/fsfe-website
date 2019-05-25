#!/bin/bash
# Tools to transform the tag data by bulk.
# Copyright (C) 2019 Johannes Zarl-Zierl <johannes@zarl-zierl.at>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
###
TAGSDATAFILE="$1"
if [[ ! -f "$1" ]]
then
	echo "No data file. Please read the source for help..." >&2
	exit 1
fi

# set to "1" to add verbose debug outpu
VERBOSE=${VERBOSE:-0}

doVerbose()
# doVerbose CMD ARGS..
{
	if [[ VERBOSE -eq 1 ]]
	then
		echo "${@@Q}" >&2
	fi
	"$@"
}

findTaggedFiles()
# findTaggedFiles TAG_ID
# grep for files containing the tag
{
	local tagId="$1"
	git grep -i -l ">$tagId</tag>"
}

renameTag()
# renameTag OLD NEW
# rename the tag using case-insensitive matching in all files.
{
	local oldTagId="$1"
	local newTagId="$2"
	echo "Renaming tag $oldTagId to $newTagId..." >&2
	for f in $(findTaggedFiles "$oldTagId")
	do
		echo "..$f" >&2
		if ! doVerbose sed -E -i "s;>\W*$oldTagId\W*</tag>;>$newTagId</tag>;" "$f"
		then
			echo "ERROR!" >&2
			return 1
		fi
	done
}

removeTag()
# removeTag TAG
# remove the tag id in all files
# this will result in additional empty lines
{
	local tagId="$1"
	echo "Deleting tag $tagId..." >&2
	for f in $(findTaggedFiles "$oldTagId")
	do
		echo "..$f" >&2
		if ! doVerbose sed -E -i "s;\W*<tag\W*content=\"[^\"]*\"\W*>\W*$TagId\W*</tag>\W*;;i" "$f"
		then
			echo "ERROR!" >&2
			return 1
		fi
	done
}

process_action()
# process a single csv action line from stdin and call the appropriate method
{
	IFS=";" read action name id section count || return 2
	# ignore empty actions
	if [[ -z "$action" ]]
	then
		return 0
	fi

	case "$action" in
		rm)
			removeTag "$id"
			;;
		mv:*)
			renameTag "$id" "${action/mv:/}"
			;;
		*)
			echo "Ignoring  action: $action on tag $section/$id" >&2
			;;
	esac
}

process_actions()
{
	read firstline
	if [[ "$firstline" != "action;name;id;section;count" ]]
	then
		echo "Input data does not look like it contains the right columns. Bailing out..." >&2
		exit 1
	fi
	while process_action
	do
		true
	done
}

process_actions < "$TAGSDATAFILE"
