# $Id: Makefile,v 1.10 2002-04-01 00:47:43 loic Exp $

MAKEINFO = makeinfo

all: sysadmin-france.en.html publish.en.html

%.html: %.texi
	@echo "generating $@ from $<"
	$(MAKEINFO) --no-split --output $@ --html $<
	perl -pi -e '$$_ = "" if((/<html/ .. /<body/) || /body>/)' $@
