#!/bin/bash
# -----------------------------------------------------------------------------
# Update XML filelists (*.xmllist) and tag list pages (tags/tagged-*)
# -----------------------------------------------------------------------------
# This script is called from the phase 1 Makefile.
#
# * tags/tagged-<tags>.en.xhtml for each tag used. Apart from being
#   automatically created, these are regular source files for HTML pages, and
#   in phase 2 are built into pages listing all news items and events for a
#   tag.
#
# * <dir>/.<base>.xmllist for each <dir>/<base>.sources as well as for each
#   tags/tagged-<tags>.en.xhtml. These files are used in phase 2 to include the
#   correct XML files when generating the HTML pages. It is taken care that
#   these files are only updated whenever their content actually changes, so
#   they can serve as a prerequisite in the phase 2 Makefile.
#
# Changing or removing tags in XML files is also considered, in which case a
# file is removed from the .xmllist files.
#
# When a tag has been removed from the last XML file where it has been used,
# the tagged-* are correctly deleted.
# -----------------------------------------------------------------------------

set -e
set -o pipefail

pid=$$

# -----------------------------------------------------------------------------
# Make sure temporary directory is empty
# -----------------------------------------------------------------------------

tagmaps="/tmp/tagmaps-${pid}"

rm -rf "${tagmaps}"
mkdir "${tagmaps}"

# -----------------------------------------------------------------------------
# Create a complete and current map of which tag is used in which files
# -----------------------------------------------------------------------------

echo "* Generating tag maps"

for xml_file in $(find * -name '*.??.xml' | xargs grep -l '</tag>' | sort); do
  xsltproc "build/xslt/get_tags.xsl" "${xml_file}" | while read raw_tag; do
    tag=$(echo "${raw_tag}" | tr -d ' +-/:_' | tr '[:upper:]' '[:lower:]')
    echo "${xml_file%.??.xml}" >> "${tagmaps}/${tag}"
  done
done

for tag in $(ls "${tagmaps}"); do
  sort -u "${tagmaps}/${tag}" > "${tagmaps}/tmp"
  mv "${tagmaps}/tmp" "${tagmaps}/${tag}"
done

# -----------------------------------------------------------------------------
# Update only those files where a change has happened
# -----------------------------------------------------------------------------

for tag in $(ls "${tagmaps}"); do
  if ! cmp --quiet "${tagmaps}/${tag}" "tags/.tagged-${tag}.xmllist"; then
    echo "* Updating tag ${tag}"
    cp "tags/tagged.en.xhtml" "tags/tagged-${tag}.en.xhtml"
    cp "${tagmaps}/${tag}" "tags/.tagged-${tag}.xmllist"
  fi
done

# -----------------------------------------------------------------------------
# Remove the files for tags which have been completely deleted
# -----------------------------------------------------------------------------

for tag in $(ls "tags" | sed -rn 's/tagged-(.*)\.en.xhtml/\1/p'); do
  if [ ! -f "${tagmaps}/${tag}" ]; then
    echo "* Deleting tag ${tag}"
    rm "tags/tagged-${tag}.en.xhtml"
    rm "tags/.tagged-${tag}.xmllist"
  fi
done

# -----------------------------------------------------------------------------
# Remove the temporary directory
# -----------------------------------------------------------------------------

rm -rf "${tagmaps}"

# -----------------------------------------------------------------------------
# Update .xmllist files for .sources
# -----------------------------------------------------------------------------

all_xml="$(find * -name '*.??.xml' | sed -r 's/\...\.xml$//' | sort -u)"

for source_file in $(find * -name '*.sources' | sort); do
  cat ${source_file} | while read line; do
    pattern=$(echo "${line}" | sed -rn 's/(.*):\[.*\]$/\1/p')
    pattern=$(echo "${pattern}" | sed -r -e 's/\./\\./g; s/\*/.*/g')
    tag=$(echo "${line}" | sed -rn 's/.*:\[(.*)\]$/\1/p')
    tag=$(echo "${tag}" | tr -d ' +-/:_' | tr '[:upper:]' '[:lower:]')

    if [ -z "${pattern}" ]; then
      continue
    fi

    # We append || true so the script doesn't fail if grep finds nothing at all
    if [ -n "${tag}" ]; then
      cat "tags/.tagged-${tag}.xmllist"
    else
      echo "${all_xml}"
    fi | grep "${pattern}" || true
  done | sort -u > "/tmp/xmllist-${pid}"

  list_file="$(dirname ${source_file})/.$(basename ${source_file} .sources).xmllist"

  if ! cmp --quiet "/tmp/xmllist-${pid}" "${list_file}"; then
    echo "* Updating ${list_file}"
    cp "/tmp/xmllist-${pid}" "${list_file}"
  fi

  rm -f "/tmp/xmllist-${pid}"
done

# -----------------------------------------------------------------------------
# Touch all .xmllist files where one of the contained files has changed
# -----------------------------------------------------------------------------

for list_file in $(find * -name '.*.xmllist' | sort); do
  must_touch="no"
  for pattern in $(cat "${list_file}"); do
    for filename in $(ls ${pattern}.??.xml); do
      if [ "${filename}" -nt "${list_file}" ]; then
        must_touch="yes"
      fi
    done
  done
  if [ "${must_touch}" == "yes" ]; then
    echo "* Touching ${list_file}"
    touch "${list_file}"
  fi
done
