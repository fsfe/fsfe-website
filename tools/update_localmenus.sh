#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# Update local menus
# -----------------------------------------------------------------------------
# This script is called from the phase 1 Makefile and upates all the
# .localmenu.*.xml files containing the local menus.
# -----------------------------------------------------------------------------

set -e

echo "* Updating local menus"

# -----------------------------------------------------------------------------
# Get a list of all source files containing local menus
# -----------------------------------------------------------------------------

all_files=$(
  find * -name "*.xhtml" -not -name "*-template.*" \
    | xargs grep -l "</localmenu>" \
    | sort
)

# -----------------------------------------------------------------------------
# Split that list by localmenu directory
# -----------------------------------------------------------------------------

declare -A files_by_dir

for file in ${all_files}; do
  dir=$(xsltproc build/xslt/get_localmenu_dir.xsl ${file})
  dir=${dir:-$(dirname ${file})}
  files_by_dir[${dir}]="${files_by_dir[${dir}]} ${file}"
done

# -----------------------------------------------------------------------------
# If any of the source files has been updated, rebuild all .localmenu.*.xml
# -----------------------------------------------------------------------------

for dir in ${!files_by_dir[@]}; do
  for file in ${files_by_dir[${dir}]}; do
    if [ "${file}" -nt "${dir}/.localmenu.en.xml" ]; then
      echo "*    Updating local menu in ${dir}"

      # Find out which languages to generate.
      languages=$(
        ls ${files_by_dir[${dir}]} \
          | sed 's/.*\.\(..\)\.xhtml/\1/' \
          | sort --uniq
      )

      # Compile the list of base filenames of the source files.
      basefiles=$(
        ls ${files_by_dir[${dir}]} \
          | sed 's/\...\.xhtml//' \
          | sort --uniq
      )

      # For each language, create the .localmenu.${lang}.xml file.
      for lang in $languages; do
        {
          echo "<?xml version=\"1.0\"?>"
          echo ""
          echo "<feed>"
          for basefile in ${basefiles}; do
            if [ -f "${basefile}.${lang}.xhtml" ]; then
              file="${basefile}.${lang}.xhtml"
            else
              file="${basefile}.en.xhtml"
            fi
            xsltproc \
              --stringparam "link" "/${basefile}.html" \
              build/xslt/get_localmenu_line.xsl \
              "${file}"
            echo ""
          done | sort
          echo "</feed>"
        } > "${dir}/.localmenu.${lang}.xml"
      done

      # The local menu for this directory has been built, no need to check
      # further source files.
      break
    fi
  done
done
