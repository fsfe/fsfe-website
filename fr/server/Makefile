# $Id: Makefile,v 1.9 2001-10-12 12:56:43 cyb Exp $

MAKEINFO = makeinfo

all: sysadmin-france.en.html

%.html: %.texi
	@echo "generating $@ from $<"
	$(MAKEINFO) --no-split --output $@ --html $<
	perl -pi -e '$$_ = "" if((/<html/ .. /<body/) || /body>/)' $@
