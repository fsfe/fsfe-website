#!/bin/sh

# lazy-ass include guard
inc_languages=true
[ -z "$inc_filenames" ] && . "$basedir/build/filenames.sh"

languages(){
cat <<EOL
ar &#1575;&#1604;&#1593;&#1585;&#1576;&#1610;&#1617;&#1577;
bg Български
bs Bosanski
ca Català
cs Česky
da Dansk
de Deutsch
el Ελληνικά
en English
es Español
et Eesti
fi Suomi
fr Français
hr Hrvatski
hu Magyar
it Italiano
ku Kurdî
mk Mакедонски
nb Norsk (bokmål)
nl Nederlands
nn Norsk (nynorsk)
pl Polski
pt Português
ro Română
ru Русский
sk Slovenčina
sl Slovenščina
sq Shqip
sr Српски
sv Svenska
tr Türkçe
uk Українська
EOL
}

get_languages(){
  languages |cut -d\  -f1
}
