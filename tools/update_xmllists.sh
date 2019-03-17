#!/bin/bash
# -----------------------------------------------------------------------------
# Update XML filelists (*.xmllist) and tag list pages (tags/tagged-*)
# -----------------------------------------------------------------------------
# This script is called from the phase 1 Makefile and creates/updates the
# following files:
#
# * tags/tagged-<tags>.en.xhtml for each tag used. Apart from being
#   automatically created, these are regular source files for HTML pages, and
#   in phase 2 are built into pages listing all news items and events for a
#   tag.
#
# * tags/.tags.??.xml with a list of the tags useed.
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

thisyear=$(date --date="this year" +%Y)
lastyear=$(date --date="last year" +%Y)

# -----------------------------------------------------------------------------
# Make sure temporary directory is empty
# -----------------------------------------------------------------------------

tagmaps="/tmp/tagmaps-${pid}"

rm -rf "${tagmaps}"
mkdir "${tagmaps}"

taglabels="/tmp/taglabels-${pid}"

rm -rf "${taglabels}"
mkdir "${taglabels}"

# -----------------------------------------------------------------------------
# Create a complete and current map of which tag is used in which files
# -----------------------------------------------------------------------------

echo "* Generating tag maps"

for xml_file in $(find * -name '*.??.xml' -not -path 'tags/*' | xargs grep -l '</tag>' | sort); do
  xsltproc "build/xslt/get_tags.xsl" "${xml_file}" | while read tag label; do
    # Add file to list of files by tag name
    echo "${xml_file%.??.xml}" >> "${tagmaps}/${tag}"

    # Store label by language and tag name
    xml_base=${xml_file%.xml}
    language=${xml_base##*.}
    if [ "${language}" -a "${label}" ]; then
      mkdir -p "${taglabels}/${language}"
      # Always overwrite so the newest news item will win.
      echo "${label}" > "${taglabels}/${language}/${tag}"
    fi
  done
done

# -----------------------------------------------------------------------------
# Make sure that each file only appears once per tag map
# -----------------------------------------------------------------------------

for tag in $(ls "${tagmaps}"); do
  sort -u "${tagmaps}/${tag}" > "${tagmaps}/tmp"
  mv "${tagmaps}/tmp" "${tagmaps}/${tag}"
done

# -----------------------------------------------------------------------------
# Update only those files where a change has happened
# -----------------------------------------------------------------------------

for tag in $(ls "${tagmaps}"); do
  if ! cmp --quiet "${tagmaps}/${tag}" "tags/.tagged-${tag}.xmllist"; then
    echo "*   Updating tag ${tag}"
    cp "tags/tagged.en.xhtml" "tags/tagged-${tag}.en.xhtml"
    cp "${tagmaps}/${tag}" "tags/.tagged-${tag}.xmllist"
  fi
done

rm -f "tags/tagged-front-page.en.xhtml"         # We don't want that one

# -----------------------------------------------------------------------------
# Remove the files for tags which have been completely deleted
# -----------------------------------------------------------------------------

for tag in $(ls "tags" | sed -rn 's/tagged-(.*)\.en.xhtml/\1/p'); do
  if [ ! -f "${tagmaps}/${tag}" ]; then
    echo "*   Deleting tags/tagged-${tag}.en.xhtml"
    rm "tags/tagged-${tag}.en.xhtml"
  fi
done

for tag in $(ls -a "tags" | sed -rn 's/.tagged-(.*)\.xmllist/\1/p'); do
  if [ ! -f "${tagmaps}/${tag}" ]; then
    echo "*   Deleting tags/.tagged-${tag}.xmllist"
    rm "tags/.tagged-${tag}.xmllist"
  fi
done

# -----------------------------------------------------------------------------
# Update the tag lists
# -----------------------------------------------------------------------------

echo "* Updating tag lists"

taglist="/tmp/taglist-${pid}"

declare -A filecount

for section in "news" "events"; do
  for tag in $(ls "${tagmaps}"); do
    filecount["${tag}:${section}"]=$(grep "^${section}/" "${tagmaps}/${tag}" | wc --lines || true)
  done
done

for language in $(ls ${taglabels}); do
  {
    echo '<?xml version="1.0" encoding="UTF-8"?>'
    echo ''
    echo '<tagset>'

    for section in "news" "events"; do
      for tag in $(ls "${tagmaps}"); do
        if [ "${tag}" == "front-page" ]; then
          continue              # We don't want an actual page for that
        fi

        count=${filecount["${tag}:${section}"]}

        if [ -f "${taglabels}/${language}/${tag}" ]; then
          label="$(cat "${taglabels}/${language}/${tag}")"
        elif [ -f "${taglabels}/en/${tag}" ]; then
          label="$(cat "${taglabels}/en/${tag}")"
        else
          label="${tag}"
        fi

        if [ "${count}" != "0" ]; then
          echo "  <tag section=\"${section}\" name=\"${tag}\" count=\"${count}\">${label}</tag>"
        fi
      done
    done

    echo '</tagset>'
  } > ${taglist}

  if ! cmp --quiet "${taglist}" "tags/.tags.${language}.xml"; then
    echo "*   Updating tags/.tags.${language}.xml"
    cp "${taglist}" "tags/.tags.${language}.xml"
  fi

  rm -f "${taglist}"
done

# -----------------------------------------------------------------------------
# Remove the temporary directory
# -----------------------------------------------------------------------------

rm -rf "${tagmaps}"
rm -rf "${taglabels}"

# -----------------------------------------------------------------------------
# Update .xmllist files for .sources
# -----------------------------------------------------------------------------

echo "* Updating XML lists"

all_xml="$(find * -name '*.??.xml' | sed -r 's/\...\.xml$//' | sort -u)"

for source_file in $(find * -name '*.sources' | sort); do
  cat ${source_file} | while read line; do
    # Get the pattern from the pattern:[tag] construction
    pattern=$(echo "${line}" | sed -rn 's/(.*):\[.*\]$/\1/p')

    if [ -z "${pattern}" ]; then
      continue
    fi

    # Honor $thisyear and $lastyear variables
    pattern=${pattern//\$thisyear/${thisyear}}
    pattern=${pattern//\$lastyear/${lastyear}}

    # Change from a glob pattern into a regex
    pattern=$(echo "${pattern}" | sed -r -e 's/([.^$[])/\\\1/g; s/\*/.*/g')

    # Get the tag from the pattern:[tag] construction
    tag=$(echo "${line}" | sed -rn 's/.*:\[(.*)\]$/\1/p')

    # Change to lowercase and remove invalid characters
    tag=$(echo "${tag,,}" | tr ' ' '_' | tr -d '/:')

    # We append || true so the script doesn't fail if grep finds nothing at all
    if [ -n "${tag}" ]; then
      cat "tags/.tagged-${tag}.xmllist"
    else
      echo "${all_xml}"
    fi | grep "^${pattern}\$" || true
  done | sort -u > "/tmp/xmllist-${pid}"

  list_file="$(dirname ${source_file})/.$(basename ${source_file} .sources).xmllist"

  if ! cmp --quiet "/tmp/xmllist-${pid}" "${list_file}"; then
    echo "*   Updating ${list_file}"
    cp "/tmp/xmllist-${pid}" "${list_file}"
  fi

  rm -f "/tmp/xmllist-${pid}"
done

# -----------------------------------------------------------------------------
# Touch all .xmllist files where one of the contained files has changed
# -----------------------------------------------------------------------------

echo "* Checking contents of XML lists"

for list_file in $(find -name '.*.xmllist' -printf '%P\n' | sort); do
  if [ ! -s "${list_file}" ]; then                # Empty file list
    continue
  fi

  xml_files="$(sed -r 's/(^.*$)/\1.??.xml/' "${list_file}")"
  # For long file lists, the following would fail with an exit code of 141
  # (SIGPIPE), so we must add a "|| true"
  newest_xml_file="$(ls -t ${xml_files} | head --lines=1 || true)"

  if [ "${newest_xml_file}" -nt "${list_file}" ]; then
    echo "*   Touching ${list_file}"
    touch "${list_file}"
  fi
done
