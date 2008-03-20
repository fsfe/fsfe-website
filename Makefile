subdirs := $(shell find */* -name "Makefile" | xargs --max-args=1 dirname)

.PHONY: subdirs $(subdirs)

subdirs: $(subdirs)

$(subdirs):
	$(MAKE) -C $@
