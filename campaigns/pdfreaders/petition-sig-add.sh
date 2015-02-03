#!/bin/bash

# This script makes it easier to update the PDFreaders signatures.
# 1. Save the automatically sent emails (subject: [PDFReaders] petition 
#    signature) to a local folder. In Thunderbird, it should be 
#    extracted as .eml file per default
# 2. Copy this script in the same folder and run it.
# 3. Manually check the new file (per default petition-sig.xml_NEW) if 
#    everythings looks fine. Delete test entries
# 4. Insert the new entries in /campaigns/pdfreaders/petition-sig.en.xml
#    and sort them alphabetically. Vim can help you with that.

# Coded by Max Mehl <max.mehl@fsfe.org>
# License: GNU GPL v3 and newer


FINALFILE="petition-sig.xml_NEW"    # In this file the result is printed
rm "$FINALFILE"

for f in *.eml
do 
  tr -d '\015' <"$f" >"1-$f"    # Convert DOS to Unix line breaks
  grep -A17 "Errors-To:" "1-$f" > "2-$f"    # Remove everything except the message body
  sed -e 's/Errors-To:.*//'  -e '/./!d' "2-$f" > "3-$f"  # Delete last header line and empty lines
  
  # Some messages are encoded in Base64. Decode them if necessary
  base64 -d "3-$f" &>/dev/null    
  if [ "$?" == 0 ]; then
    base64 -d "3-$f" > "4-$f"
  else 
    cat "3-$f" > "4-$f"
  fi
  
  # Extract names and surnames and remove them from unnecessary parts
  NAME=$(grep "\sname=\".*\"" "4-$f")
  NAME=$(echo $NAME | awk -F= '{ print $2 }')
  NAME=$(echo $NAME | sed 's/"//g')

  SURNAME=$(grep "surname=\".*\"" "4-$f")
  SURNAME=$(echo $SURNAME | awk -F= '{ print $2 }')
  SURNAME=$(echo $SURNAME | sed 's/"//g')
  
  # Add <li> tags
  echo "<li>$NAME $SURNAME</li>" >> "$FINALFILE.temp"
  
  # remove temporary files
  rm 1-*.eml 2-*.eml 3-*.eml 4-*.eml 
  
done

# Remove duplicate entries
sort "$FINALFILE.temp" | uniq -u > "$FINALFILE"
rm "$FINALFILE.temp"



