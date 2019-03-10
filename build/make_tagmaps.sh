#!/bin/sh
# -----------------------------------------------------------------------------
# Update tagmaps (tools/tagmaps/*.map) and tag list pages (tags/tagged-*)
# -----------------------------------------------------------------------------
# This script collects all <tag> content from all XML files in the source
# directory, and from that creates or updates the following files:
#
# tools/tagmaps/<tag>.map - a list of all XML files containing that tag. It is
#   used by the "premake" Makefile via "build/source_globber.sh sourceglobs" to
#   determine the XML files covered by each .sources file.
#
# tags/tagged-<tag>.en.xhtml - a source file which will be built by the
#   standard build process into a web page listing all news and events with
#   this tag.
#
# tags/tagged-<tag>.sources - the pattern list of XML files to be included when
#   building that web page.
#
# Each of these files is only touched when the actual file list for a tag
# changes, so the makefile can determine which taglist web pages must be
# rebuilt.
#
# Changing or removing tags in XML files is also considered, in which case a
# file is removed from the map, and the taglist web page source files are
# touched so the build script will rebuild the corresponding web page.
#
# When a tag has been removed from the last XML file where it has been used,
# all the files listed above are correctly deleted.
# -----------------------------------------------------------------------------

set -e

echo "Updating tag maps"

# -----------------------------------------------------------------------------
# Make sure temporary directory is empty
# -----------------------------------------------------------------------------

rm -rf /tmp/tagmaps
mkdir /tmp/tagmaps

# -----------------------------------------------------------------------------
# Create a complete and current map of which tag is used in which files
# -----------------------------------------------------------------------------

echo "* Collecting list of files for each tag"

for xml_file in `find * -name '*.xml' | xargs grep -l '</tag>' | sort`; do
  xsltproc build/xslt/get_tags.xsl "${xml_file}" | while read raw_tag; do
    tag=`echo "${raw_tag}" | tr -d ' +-/:_' | tr '[:upper:]' '[:lower:]'`
    echo ${xml_file} >> "/tmp/tagmaps/${tag}.map"
  done
done

# -----------------------------------------------------------------------------
# Update only those map files where a change has happened (an XML file been
# added or removed) so make can later see what has changed since the last build
# -----------------------------------------------------------------------------

echo "* Checking for updated tags"

for map_file in `ls /tmp/tagmaps`; do
  if ! cmp --quiet "/tmp/tagmaps/${map_file}" "tools/tagmaps/${map_file}"; then
    tag=`basename "${map_file}" .map`
    echo "*   Tag ${tag} has been updated."
    cp "/tmp/tagmaps/${map_file}" "tools/tagmaps/${map_file}"
    cp "tags/tagged.en.xhtml" "tags/tagged-${tag}.en.xhtml"
    echo "news/*/news:[${tag}]" >> "tags/tagged-${tag}.sources"
    echo "news/*/.news:[${tag}]" >> "tags/tagged-${tag}.sources"
    echo "news/nl/nl:[${tag}]" >> "tags/tagged-${tag}.sources"
    echo "news/nl/.nl:[${tag}]" >> "tags/tagged-${tag}.sources"
    echo "events/*/events:[${tag}]" > "tags/tagged-${tag}.sources"
    echo "d_day:[]" >> "tags/tagged-${tag}.sources"
  fi
done

# -----------------------------------------------------------------------------
# Remove the map files for tags which have been completely deleted
# -----------------------------------------------------------------------------

echo "* Checking for deleted tags"

for map_file in `ls tools/tagmaps | grep '\.map'`; do
  if [ ! -f "/tmp/tagmaps/${map_file}" ]; then
    tag=`basename "${map_file}" .map`
    echo "*   Tag ${tag} has been deleted."
    rm "tools/tagmaps/${map_file}"
    rm "tags/tagged-${tag}.en.xhtml"
    rm "tags/tagged-${tag}.sources"
  fi
done

# -----------------------------------------------------------------------------
# Remove the temporary directory
# -----------------------------------------------------------------------------

echo "* Cleaning up"

rm -rf /tmp/tagmaps
