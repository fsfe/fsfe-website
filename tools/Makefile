
BASEDIR ::= $(shell dirname $(PWD))
TAGMAP ::= $(shell find $(BASEDIR) -name '*.xml' \
             | xargs ../build/source_globber.sh map_tags \
            )

TAGNAMES = $(shell printf %s '$(TAGMAP)' \
             | cut -d" " -f2- \
             | tr ' ' '\n' \
             | egrep -v '[\$%/:()]' \
             | sort -u \
             | xargs printf 'tagmaps/%s.map ' \
            )

all: $(TAGNAMES)

MAPREQS = $(shell printf %s '$(TAGMAP)' \
            | sed -r 's;[^ ]+\...\.xml;\n&;g' \
            | grep ' $*' \
            | cut -d' ' -f1 \
           )

.SECONDEXPANSION:
tagmaps/%.map: $$(MAPREQS)
	printf '%s\n' $^ > $@
