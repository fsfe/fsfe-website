# $Id: Makefile,v 1.8 2001-06-08 21:14:51 olberger Exp $

MAKEINFO = makeinfo

all: sysadmin-france.en.html

%.html: %.texi
	@echo "generating $@ from $<"
	$(MAKEINFO) --output $@ --html $<
	perl -pi -e '$$_ = "" if((/<html/ .. /<body/) || /body>/)' $@
