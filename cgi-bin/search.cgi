#!/bin/sh

c=/home/www/fsfe.org_htdig/htdig.conf
l="$(printf %s "$QUERY_STRING" |sed -rn '1s;^(.*&)?l=([^&]+)(&.*)?$;\2;p')"
q="$(printf %s "$QUERY_STRING" |sed -rn '1s;^(.*&)?q=([^&]+)(&.*)?$;\2;p')"

# htdig forces default config file if reading cgi-variabled directly
# this would prevent multisite usage, overriding request instead
unset REQUEST_METHOD

/usr/lib/cgi-bin/htsearch -c "$c" "restrict=${l:-en}.html&words=${q}" \
| xmllint --html --encode iso-8859-1 - \
| sed -r '2s;charset=iso-8859-1;charset=utf-8;'
