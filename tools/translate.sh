#! /bin/sh

BASE="$1"
LANGUAGE="$2"
LANGS=""
RESULT=""

# Find what translations are available.
for j in $BASE.??.xhtml; do 
    LANGS="`expr $j : $BASE.\\\\\(.*\\\\\).xhtml` $LANGS"
done
# Special case while we don't change all those *.xhtml to *.en.xhtml
if [ -f $BASE.xhtml ]; then
    LANGS="EN $LANGS"
fi

# Create the string to be included in the webpage.
BASENAME=`basename $BASE` 
SEPARATOR="[ "
if [ "`echo $LANGS | grep de`" != "" ]; then
    RESULT="$RESULT""$SEPARATOR"
    if [ "$LANGUAGE" != "de" ]; then
	RESULT="$RESULT""<a href=\"$BASENAME.de.html\">"
    fi
    RESULT="$RESULT""Deutsch"
    if [ "$LANGUAGE" != "de" ]; then
	RESULT="$RESULT""</a>"
    fi
    SEPARATOR=" | "
fi
if [ "`echo $LANGS | grep en`" != "" ]; then
    RESULT="$RESULT""$SEPARATOR"
    if [ "$LANGUAGE" != "en" ]; then
	RESULT="$RESULT""<a href=\"$BASENAME.en.html\">"
    fi
    RESULT="$RESULT""English"
    if [ "$LANGUAGE" != "en" ]; then
	RESULT="$RESULT""</a>"
    fi
    SEPARATOR=" | "
fi
# Again, the special case
if [ "`echo $LANGS | grep EN`" != "" ]; then
    RESULT="$RESULT""$SEPARATOR"
    if [ "$LANGUAGE" != "en" ]; then
	RESULT="$RESULT""<a href=\"$BASENAME.html\">"
    fi
    RESULT="$RESULT""English"
    if [ "$LANGUAGE" != "en" ]; then
	RESULT="$RESULT""</a>"
    fi
    SEPARATOR=" | "
fi
if [ "`echo $LANGS | grep es`" != "" ]; then
    RESULT="$RESULT""$SEPARATOR"
    if [ "$LANGUAGE" != "es" ]; then
	RESULT="$RESULT""<a href=\"$BASENAME.es.html\">"
    fi
    RESULT="$RESULT""Espa&ntilde;ol"
    if [ "$LANGUAGE" != "es" ]; then
	RESULT="$RESULT""</a>"
    fi
    SEPARATOR=" | "
fi
if [ "`echo $LANGS | grep fr`" != "" ]; then
    RESULT="$RESULT""$SEPARATOR"
    if [ "$LANGUAGE" != "fr" ]; then
	RESULT="$RESULT""<a href=\"$BASENAME.fr.html\">"
    fi
    RESULT="$RESULT""Fran&ccedil;ais"
    if [ "$LANGUAGE" != "fr" ]; then
	RESULT="$RESULT""</a>"
    fi
    SEPARATOR=" | "
fi
if [ "`echo $LANGS | grep it`" != "" ]; then
    RESULT="$RESULT""$SEPARATOR"
    if [ "$LANGUAGE" != "it" ]; then
	RESULT="$RESULT""<a href=\"$BASENAME.it.html\">"
    fi
    RESULT="$RESULT""Italiano"
    if [ "$LANGUAGE" != "it" ]; then
	RESULT="$RESULT""</a>"
    fi
    SEPARATOR=" | "
fi
if [ "`echo $LANGS | grep pt`" != "" ]; then
    RESULT="$RESULT""$SEPARATOR"
    if [ "$LANGUAGE" != "pt" ]; then
	RESULT="$RESULT""<a href=\"$BASENAME.pt.html\">"
    fi
    RESULT="$RESULT""Portugu&ecirc;s"
    if [ "$LANGUAGE" != "pt" ]; then
	RESULT="$RESULT""</a>"
    fi
    SEPARATOR=" | "
fi
RESULT="$RESULT ]"

# Output the string.
echo "$RESULT"

# Create or update $BASE.lang file as needed
if [ "$LANGUAGE" != "" ]; then
    LANGSTRING="`$0 $BASE`"
else
    LANGSTRING="$RESULT"
fi
if [ ! -f "$BASE.lang" ]; then
    echo "$LANGSTRING" > $BASE.lang
elif [ "$LANGSTRING" != "`cat $BASE.lang`" ]; then
    echo "$LANGSTRING" > $BASE.lang
fi
