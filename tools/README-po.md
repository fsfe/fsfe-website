# EXPERIMENTAL and MANUAL procedures

# How to work with .po files

0. Install the "translate toolkit"

```
virtualenv ve
. ve/bin/activate
pip install translate-toolkit
```

1. Create/update the .po file for your language

```
. ve/bin/activate
./build/convert-xhtml-to-po.sh activities/ftf/legal-team.en.xhtml fr
```

The file will be located at

2. Modify the .po file

3. Convert the .po file back

```
. ve/bin/activate
./build/convert-po-to-xhtml.sh build/i10n/activities/ftf/legal-team.fr.po
```

