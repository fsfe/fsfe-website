#!/bin/bash


# Please read README.txt before executing this file
# This script is able to format the exported supporter file (.csv) so it can be imported in CiviCRM directly
# It only takes the First Name, Last Name, Email Address and the Country because everything else seemed to be of no interest for further campaigning
# Of course you can change that easily but please be aware that CiviCRM has fields like "ref_url" not by default
# This script is by far not perfect but does what it should do. For 3500 supporters, it needed ~5 minutes

# Written by Max Mehl <max.mehl@fsfe.org> for Free Software Foundation Europe
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the 
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.


# CHANGE these files if needed
INPUT=supporters.csv
OUTPUT=supporters_format.csv
COUNTRIES=countries.txt

## FROM HERE you (hopefully) do not need to change something
# empty output file
> $OUTPUT
> temp131031.txt
> temp131031_new.txt

# Makes all first letters of max. 3 names uppercase and the rest lowercase
function nameformat {
ORIGINALNAME=$1		# Name which should be formatted, should be given by function call
t=1			# start with the first name
AWK="1"
while [ "$AWK" != "" ]; do		# only runs if there is still a name

	NAME=$(echo $ORIGINALNAME | awk -F\  '{print $'$t'}')	# takes out first part of name

	NAME=$(echo $NAME | sed "s:[A-Z]:\L&:g")		# make all letters lowercase
	NAME_1l=$(echo $NAME | sed -e 's/\([a-z]\).*/\1/')	# first lowercase letter
	NAME_REST=$(echo $NAME | sed -e 's/^'$NAME_1l'//' )	# rest of lowercase letters remain unchanged
	NAME_1u=$(echo $NAME_1l | tr [a-z] [A-Z] )	# make first letter uppercase
	NAME=$NAME_1u$NAME_REST	# put strings together
	
	NAME[$t]=$NAME	# Put the formatted name in a different NAME variable each loop
	(( t++ ))		# Counts 1 up for next part of name
	AWK=$(echo $line | awk -F\  '{print $'$t'}')	# reads second name, if existing
done

CORRECTNAME="${NAME[1]}"	# if there is only one name
if [ "${NAME[3]}" != "" ]; then		# if there are 3 names, every additional name is lowercase only
	CORRECTNAME=""${NAME[1]}" "${NAME[2]}" "${NAME[3]}""
elif [ "${NAME[2]}" != "" ]; then	# if there are 2 names
	CORRECTNAME=""${NAME[1]}" "${NAME[2]}""
fi
}


while read line
do
	# erase all "", will be added later
	line=$(echo $line | sed 's/"//g')
	
	#ID=$(echo $line | awk -F, '{ print $1 }')
	#DATE=$(echo $line | awk -F, '{ print $2 }')
	FIRSTNAME=$(echo $line | awk -F, '{ print $3 }')
	LASTNAME=$(echo $line | awk -F, '{ print $4 }')
	EMAIL=$(echo $line | awk -F, '{ print $5 }')
	CCODE=$(echo $line | awk -F, '{ print $6 }')
	#SECRET=$(echo $line | awk -F, '{ print $7 }')
	#SIGNED=$(echo $line | awk -F, '{ print $8 }')
	#CONFIRMDATE=$(echo $line | awk -F, '{ print $9 }')
	#UPDATEDATE=$(echo $line | awk -F, '{ print $10 }')
	#REFURL=$(echo $line | awk -F, '{ print $11 }')
	#REFID=$(echo $line | awk -F, '{ print $12 }')
	
	# DATE: erase time, only keep date
	DATE=$(echo $DATE | awk -F\  '{ print $1 }')

	# FIRSTNAME: (only) first letters uppercase
	nameformat "$FIRSTNAME"
	FIRSTNAME="$CORRECTNAME"
	
	# LASTNAME: (only) first letters uppercase
	nameformat "$LASTNAME"
	LASTNAME="$CORRECTNAME"
	
	# EMAIL: all letters lowercase
	EMAIL=$(echo $EMAIL | sed "s:[A-Z]:\L&:g")		# make all letters lowercase

	
	## Replace Country Code with full Country name
	## FAR TOO SLOW!!!
	#while read line
	#do
		#GREP=$(echo "$line" | grep "$CCODE")
		#if [ $? = 0 ]; then
			#COUNTRY=$(echo "$line" | awk -F: '{print $2}')
		#fi
	#done <"$COUNTRIES"
	
	
	# Output of all interesting strings with "" surrounded, only if Firstname not empty
	if [ "$FIRSTNAME" != "" ]; then
		echo "\"$FIRSTNAME\",\"$LASTNAME\",$EMAIL,\"$CCODE\"" >> temp131031.txt
	fi
	
done <"$INPUT"

# Replaces all Country Codes with the Full Country name used in CiviCRM
while read line
do
	CCODE=$(echo $line | awk -F: '{print $1}')
	CNAME=$(echo $line | awk -F: '{print $2}')
	
	sed s/"\"$CCODE\""/"\"$CNAME\""/g temp131031.txt > temp131031_new.txt
	mv temp131031_new.txt temp131031.txt
done <"$COUNTRIES"

mv temp131031.txt $OUTPUT



