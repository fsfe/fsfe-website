subdirs := $(shell find */* -name "Makefile" | xargs --max-args=1 dirname)

include Make_local_menus

.PHONY: subdirs $(subdirs)

subdirs: $(subdirs)

$(subdirs):
	$(MAKE) -C $@
