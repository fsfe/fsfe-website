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

FORCE=0
LANGUAGE=
NO_ACT=0
VERBOSE=0

log()
# log LVL MESSAGE
{
	local min_lvl="$1"
	shift
	if [[ VERBOSE -ge min_lvl ]]
	then
		echo "$@" >&2
	fi
}

print_help()
{
	cat <<EOF >&2
Usage: tagstool OPTIONS --find-tags TAG..
       tagstool OPTIONS --remove-empty-labels
       tagstool OPTIONS --remove-tags TAG..
       tagstool OPTIONS --rename-tags OLD NEW
       tagstool OPTIONS --set-label LABEL [--force] TAG

Transform tag data by bulk.

Options:
-n|--no-act                Don't perform any changes.
-v|--verbose               Add verbose output of changes.
--language CC              Limit action to files with the given two-letter
                           ISO 639-1 language code; leave empty to select all.
                           (default: $LANGUAGE).
-f|--force                 Overwrite existing information (for --set-label).

Actions (only one action per invocation):
--find-tags TAG..          List all files containing the given tags.
                           If a non-empty language is given, the output is
                           limited to that language.
--remove-empty-labels      Remove empty content attribute for tags.
                           Not affected by --language option.
--remove-tags TAG..        Remove the given tags.
--rename-tag OLD NEW       Rename the OLD tag to NEW tag in all files.
--set-label LABEL          Set the given label on all given tag.
                           The tag is given as positional parameter.
                           This action is limited to one language at a time,
                           because the label is a localized string.
                           By default, existing labels are not overwritten.

EOF
}

performAction()
# performAction CMD ARGS..
# Perform the given command, if NO_ACT is not set.
# If VERBOSE is set, also print the command.
# Please use this for all actions that perform a change on the data!
{
	log 1 "${@@Q}"
	if [[ NO_ACT -eq 1 ]]
	then
		echo "NOT calling $1..." >&2
	else
		"$@"
	fi
}

findTaggedFiles()
# findTaggedFiles TAG_ID
# grep for files containing the tag
{
	local tagId="$1"
	git grep -i -l ">$tagId</tag>"
}

fileIsLanguage()
# fileIsLanguage FILE LANGUAGE
# Check the language of a file based on its filename
# If the filename matches the language or if the language is an empty string, return true,
# otherwise return false.
{
	# remove filename until first "."
	local suffix="${1#*.}"
	local language="$2"
	if [[ -z "$language" ]]
	then
		return 0
	fi
	# greedily remove from back to the leftmost "."
	local pre_suffix="${suffix%%.*}"
	[[ "$pre_suffix" == "$language" ]]
}

renameTag()
# renameTag OLD NEW
# rename the tag using case-insensitive matching in all files.
# Global variables: LANGUAGE
{
	local oldTagId="$1"
	local newTagId="$2"
	echo "Renaming tag $oldTagId to $newTagId..." >&2
	for f in $(findTaggedFiles "$oldTagId")
	do
		if ! fileIsLanguage "$f" "$LANGUAGE"
		then
			log 2 "Ignoring file (language filter): $f"
			continue
		fi
		echo "  $f" >&2
		if ! performAction sed -E -i "s;>\W*$oldTagId\W*</tag>;>$newTagId</tag>;i" "$f"
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
# Global variables: LANGUAGE
{
	local tagId="$1"
	echo "Deleting tag $tagId..." >&2
	for f in $(findTaggedFiles "$tagId")
	do
		if ! fileIsLanguage "$f" "$LANGUAGE"
		then
			log 2 "Ignoring file (language filter): $f"
			continue
		fi
		echo "  $f" >&2
		if ! performAction sed -E -i "s;\W*<tag\W*(content=\"[^\"]*\"\W*)?>\W*$tagId\W*</tag>\W*;;i" "$f"
		then
			echo "ERROR!" >&2
			return 1
		fi
	done
}

setTagLabel()
# setTagLabel TagId Label
# Global Variables: FORCE, LANGUAGE
{
	local TagId="$1"
	local Label="$2"
	# regexp part to force content:
	local re_force_content=
	if [[ FORCE -eq 1 ]]
	then
		re_force_content="content=\"[^\"]*\"\W*"
	fi
	echo "Setting label for tag $TagId to $Label.." >&2
	for f in $(findTaggedFiles "$TagId")
	do
		# language is not empty
		if ! fileIsLanguage "$f" "$LANGUAGE"
		then
			log 2 "Ignoring file (language filter): $f"
			continue
		fi
		echo "  $f" >&2
		if ! performAction sed -E -i "s;<tag\W*$re_force_content>\W*$TagId\W*</tag>\W*;<tag content=\"$Label\">$TagId</tag>;i" "$f"
		then
			echo "ERROR!" >&2
			return 1
		fi
	done
}

action_findTags()
# action_findTags TAGS..
# find all files containing the given tags
# If language is set, limit to the given language.
# Global variables: LANGUAGE
{
	for tagId
	do
		for f in $(findTaggedFiles "$tagId")
		do
			if fileIsLanguage "$f" "$LANGUAGE"
			then
				echo "$f"
			else
				log 2 "Ignoring file (language filter): $f"
			fi
		done
	done | sort -u
}

action_removeEmpty()
# removeEmpty
# removes empty labels
{
	echo "Removing empty 'content' attribute  from tags..." >&2
	for f in $(git grep -Eil '<tag\W+content="\W*"\W*>')
	do
		echo "  $f" >&2
		performAction sed -E -i 's;<tag\W+content="\W*"\W*>;<tag>;g' "$f"
	done
}

action_removeTags()
# action_removeTags TAG..
# Remove the given tags from all files
# Global variables: LANGUAGE (indirect)
{
	for tagId
	do
		removeTag "$tagId"
	done
}

action_renameTag()
# action_renameTag OLD NEW
# Rename the old tag to new.
# Global variables: LANGUAGE (indirect)
{
	if [[ "$#" -ne 2 ]]
	then
		echo "Error: expected 2 arguments, got $#." >&2
		return 1
	fi
	renameTag "$1" "$2"
}

action_setLabel()
# action_setLabel TAG
# Global variables: FORCE, LABEL, LANGUAGE
{
	local TagId="$1"
	if [[ -z "${LANGUAGE}" || -n "${LANGUAGE/??}" ]]
	then
		echo "Language must be a two-letter ISO 639-1 code!" >&2
		return 1
	fi
	setTagLabel "$TagId" "$LABEL"
}

###
# Parse commandline:
###

TEMP=`getopt -o hnv \
      --long find-tags,force,help,language:,no-act,remove-empty-labels,remove-tags,rename-tag,set-label:,verbose \
      -n 'tagtool' -- "$@"`

if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi

# Note the quotes around `$TEMP': they are essential!
eval set -- "$TEMP"

while true ; do
	case "$1" in
		--find-tags) ACTION=action_findTags ; shift ;;
		--force) FORCE=1 ; shift ;;
		-h|--help) print_help ; exit ;;
		--language) LANGUAGE="$2" ; shift 2 ;;
		-n|--no-act) NO_ACT=1 ; shift ;;
		--remove-empty-labels) ACTION=action_removeEmpty ; shift ;;
		--remove-tags) ACTION=action_removeTags ; shift ;;
		--rename-tag) ACTION=action_renameTag ; shift ;;
		--set-label) ACTION=action_setLabel ; LABEL="$2" ; shift 2 ;;
		-v|--verbose) let VERBOSE++ ; shift ;;
		--) shift ; break ;;
		*) echo "Internal error!" ; exit 1 ;;
	esac
done

###
# Perform action:
###

if [ -z "$ACTION" ]
then
	echo "No action chosen!" >&2
	print_help
	exit 1
fi

"$ACTION" "$@"
