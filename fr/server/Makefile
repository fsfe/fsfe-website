MAKEINFO = makeinfo

all: sysadmin-france.en.html

%.html: %.texi
	$(MAKEINFO) --output $@ --html $<
	perl -pi -e '$$_ = "" if((/<html/ .. /<body/) || /body>/)' $@
