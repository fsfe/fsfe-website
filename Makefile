SUBDIRS := $(shell find */* -name "Makefile" | xargs --max-args=1 dirname)

.PHONY: subdirs $(SUBDIRS)

subdirs: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@
