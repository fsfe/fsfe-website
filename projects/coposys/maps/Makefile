include Config.mk

BASE_GEOMETRY = 1600x800
BASE_MAP = bio_1600.jpg

WGET =  wget -N

XPLANET = xplanet \
	--shade 100 \
	--geometry $(BASE_GEOMETRY) \
	--projection rectangular \
	--image $(MAPDIR)/$(BASE_MAP)

GEOMETRIES = \
	1280x640 \
	1024x512 \
	800x400 \
	640x320 \
	320x160

ALL = $(foreach g,\
	$(BASE_GEOMETRY) $(GEOMETRIES),$(COMMUNITIES:%=$(MAPDIR)/%-$(g).png))

all: $(ALL);

clean:
	$(RM) $(ALL)

$(MAPDIR)/earth_2400.jpg:
	$(WGET) http://www.radcyberzine.com/xglobe/$(@F) -O $@

$(MAPDIR)/bio_1600.jpg:
	$(WGET) http://www.radcyberzine.com/xglobe/$(@F) -O $@

$(COMMUNITIES:%=$(MAPDIR)/%-$(BASE_GEOMETRY).png): $(MAPDIR)/%-$(BASE_GEOMETRY).png: $(MARKERDIR)/%.noname.mark $(MAPDIR)/$(BASE_MAP)
	$(XPLANET) -markerfile $< -output $@

$(MAPDIR)/geometries.mk:
	for g in $(GEOMETRIES); do \
		echo -e "\$$(COMMUNITIES:%=\$$(MAPDIR)/%-$$g.png): \$$(MAPDIR)/%-$$g.png: \$$(MAPDIR)/%-\$$(BASE_GEOMETRY).png ; convert -geometry $$g \$$< \$$@\n" \
	; done > $@

include $(MAPDIR)/geometries.mk

# remove names
$(MARKERDIR)/%.noname.mark: $(MARKERDIR)/%.mark
	sed -e 's/^\([^ ]*\) \([^ ]*\) .*$$/\1 \2 ""/' < $< > $@
