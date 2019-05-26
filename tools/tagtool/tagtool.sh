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

VERBOSE=0
NO_ACT=0

print_help()
{
	cat <<EOF >&2
Usage: tagstool [-n|--no-act] [-v|--verbose] -b|--bulk-process TAGSDATAFILE
       tagstool [-n|--no-act] [-v|--verbose] --remove-empty

Transform tag data by bulk.

Options:
-n|--no-act                Don't perform any changes.
-v|--verbose               Add verbose output of changes.

Actions (only one action per invocation):
-b|--bulk TAGSDATAFILE     Transform bulk transformations a defined in the
                           csv file. See README.md for details.
                           Available transformations:
                            - rm: delete tag
                            - mv:newtag: move the tag to a newtag

--remove-empty             Remove empty content attribute for tags.

EOF
}

performAction()
# performAction CMD ARGS..
# Perform the given command, if NO_ACT is not set.
# If VERBOSE is set, also print the command.
# Please use this for all actions that perform a change on the data!
{
	if [[ VERBOSE -eq 1 ]]
	then
		echo "${@@Q}" >&2
	fi
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

renameTag()
# renameTag OLD NEW
# rename the tag using case-insensitive matching in all files.
{
	local oldTagId="$1"
	local newTagId="$2"
	echo "Renaming tag $oldTagId to $newTagId..." >&2
	for f in $(findTaggedFiles "$oldTagId")
	do
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
{
	local tagId="$1"
	echo "Deleting tag $tagId..." >&2
	for f in $(findTaggedFiles "$oldTagId")
	do
		echo "  $f" >&2
		if ! performAction sed -E -i "s;\W*<tag\W*content=\"[^\"]*\"\W*>\W*$TagId\W*</tag>\W*;;i" "$f"
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

do_bulk()
# do_bulk TAGSDATAFILE
# perform a bulk action based on data in the given tags data csv file.
{
	local TAGSDATAFILE="$1"
	if [[ ! -f "$TAGSDATAFILE" ]]
	then
		echo "No data file. Please read the source for help..." >&2
		return 1
	fi
	process_actions < "$TAGSDATAFILE"
}

do_removeEmpty()
# removeEmpty
{
	echo "Removing empty 'content' attribute  from tags..." >&2
	for f in $(git grep -Eil '<tag\W+content="\W*"\W*>')
	do
		echo "  $f" >&2
		performAction sed -E -i 's;<tag\W+content="\W*"\W*>;<tag>;g' "$f"
	done
}

###
# Parse commandline:
###

TEMP=`getopt -o hbvn --long help,bulk-process,verbose,no-act,remove-empty \
     -n 'tagtool' -- "$@"`

if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi

# Note the quotes around `$TEMP': they are essential!
eval set -- "$TEMP"

while true ; do
	case "$1" in
		-b|--bulk-process) ACTION=do_bulk ; shift ;;
		-h|--help) print_help ; exit ;;
		-n|--no-act) NO_ACT=1 ; shift ;;
		--remove-empty) ACTION=do_removeEmpty ; shift ;;
		-v|--verbose) VERBOSE=1 ; shift ;;
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
