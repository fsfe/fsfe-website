#!/bin/sh

c=/home/www/fsfe.org_htdig/htdig.conf
l="$(printf %s "$QUERY_STRING" |sed -rn '1s;^(.*&)?l=([^&]+)(&.*)?$;\2;p')"
q="$(printf %s "$QUERY_STRING" |sed -rn '1s;^(.*&)?q=([^&]+)(&.*)?$;\2;p')"

# htdig forces default config file if reading cgi-variabled directly
# this would prevent multisite usage, overriding request instead
unset REQUEST_METHOD

printf %s\\n\\n "Content-Type: text/html;charset=utf-8"

# htdig tries to escape non ascii characters.
# since it is however not utf-8 clean it tends to escape single
# octets in multibyte character sequences,
# hence we use xmllint and sed to unescape the characters again
/usr/lib/cgi-bin/htsearch -c "$c" "restrict=${l:-en}.html&words=${q}" \
| tail -n+3 \
| sed -r 's;&euro\;;\xa4;g' \
| xmllint --html --encode iso-8859-1 - \
| sed -r '2s;charset=iso-8859-1;charset=utf-8;'
