#!/bin/bash
# -----------------------------------------------------------------------------
# Update XML filelists (*.xmllist) and tag list pages (tags/tagged-*)
# -----------------------------------------------------------------------------
# From all <tag> content from all XML files, and from all .sources filelists,
# this script creates or updates the following files:
#
# */.<base>.xmllist - a list of all XML files matching the patterns in the
#   corresponding */<base>.sources list.
#
# tags/tagged-<tag>.en.xhtml - a source file which will be built by the
#   standard build process into a web page listing all news and events with
#   this tag.
#
# Each of these files is only touched when the actual content has changed,
# so the build makefile can determine which web pages must be rebuilt.
#
# Changing or removing tags in XML files is also considered, in which case a
# file is removed from the .xmllist files.
#
# When a tag has been removed from the last XML file where it has been used,
# the tagged-* are correctly deleted.
# -----------------------------------------------------------------------------

set -e
set -o pipefail

# -----------------------------------------------------------------------------
# Make sure temporary directory is empty
# -----------------------------------------------------------------------------

rm -rf /tmp/tagmaps
mkdir /tmp/tagmaps

# -----------------------------------------------------------------------------
# Create a complete and current map of which tag is used in which files
# -----------------------------------------------------------------------------

echo "* Generating tag maps"

for xml_file in `find * -name '*.xml' | xargs grep -l '</tag>' | sort`; do
  xsltproc "build/xslt/get_tags.xsl" "${xml_file}" | while read raw_tag; do
    tag=`echo "${raw_tag}" | tr -d ' +-/:_' | tr '[:upper:]' '[:lower:]'`
    echo ${xml_file} | sed -r 's;\...\.xml$;;' >> "/tmp/tagmaps/${tag}"
  done
done

for tag in `ls /tmp/tagmaps`; do
  echo "d_day" >> "/tmp/tagmaps/${tag}"
  sort -u "/tmp/tagmaps/${tag}" > "/tmp/tagmaps/tmp"
  mv "/tmp/tagmaps/tmp" "/tmp/tagmaps/${tag}"
done

# -----------------------------------------------------------------------------
# Update only those files where a change has happened (an XML file been added
# or removed) so make can later see what has changed since the last build
# -----------------------------------------------------------------------------

for tag in `ls /tmp/tagmaps`; do
  if ! cmp --quiet "/tmp/tagmaps/${tag}" "tags/.tagged-${tag}.xmllist"; then
    echo "* Updating tag ${tag}"
    cp "tags/tagged.en.xhtml" "tags/tagged-${tag}.en.xhtml"
    cp "/tmp/tagmaps/${tag}" "tags/.tagged-${tag}.xmllist"
  fi
done

# -----------------------------------------------------------------------------
# Remove the map files for tags which have been completely deleted
# -----------------------------------------------------------------------------

for tag in `ls tags | sed -rn 's/tagged-(.*)\.en.xhtml/\1/p'`; do
  if [ ! -f "/tmp/tagmaps/${tag}" ]; then
    echo "* Deleting tag ${tag}"
    rm "tags/tagged-${tag}.en.xhtml"
    rm "tags/.tagged-${tag}.xmllist"
  fi
done

# -----------------------------------------------------------------------------
# Remove the temporary directory
# -----------------------------------------------------------------------------

rm -rf /tmp/tagmaps

# -----------------------------------------------------------------------------
# Update map files for .sources
# -----------------------------------------------------------------------------

all_xml="`find * -name '*.xml' | sed -r 's;\...\.xml$;;' | sort -u`"

for source_file in `find * -name '*.sources' | sort`; do
  cat ${source_file} | while read line; do
    pattern=`echo "${line}" | sed -rn 's;(.*):\[.*\]$;\1;p'`
    pattern=`echo "${pattern}" | sed -r -e 's;\.;\\.;g' -e 's;\*;.*;g'`
    tag=`echo "${line}" | sed -rn 's;.*:\[(.*)\]$;\1;p'`
    tag=`echo "${tag}" | tr -d ' +-/:_' | tr '[:upper:]' '[:lower:]'`

    if [ -z "${pattern}" ]; then
      continue
    fi

    # We append || true so the script doesn't fail if grep finds nothing at all
    if [ -n "${tag}" ]; then
      cat "tags/.tagged-${tag}.xmllist"
    else
      echo "${all_xml}"
    fi | grep "${pattern}" || true
  done | sort -u > "/tmp/xmllist"

  list_file="`dirname ${source_file}`/.`basename ${source_file} .sources`.xmllist"

  if ! cmp --quiet "/tmp/xmllist" "${list_file}"; then
    echo "* Updating ${list_file}"
    cp "/tmp/xmllist" "${list_file}"
  fi

  rm -f /tmp/xmllist
done
