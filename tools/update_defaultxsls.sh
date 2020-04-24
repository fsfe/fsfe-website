#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# Update default sytlesheets
# -----------------------------------------------------------------------------
# This script is called from the phase 1 Makefile and places a .default.xsl
# into each directory containing source files for HTML pages (*.xhtml). These
# .default.xsl are symlinks to the first available actual default.xsl found
# when climbing the directory tree upwards, it's the XSL stylesheet to be used
# for building the HTML files from this directory.
# -----------------------------------------------------------------------------

set -e

echo "* Updating default stylesheets"

# -----------------------------------------------------------------------------
# Get a list of all directories containing .xhtml source files
# -----------------------------------------------------------------------------

directories=$(
  find -name "*.??.xhtml" \
    | xargs dirname \
    | sort --unique
)

# -----------------------------------------------------------------------------
# In each dir, place a .default.xsl symlink pointing to the nearest default.xsl
# -----------------------------------------------------------------------------

for directory in ${directories}; do
  dir="${directory}"
  prefix=""
  until [ -f "${dir}/default.xsl" -o "${dir}" = "." ]; do
    dir="$(dirname "${dir}")"
    prefix="${prefix}../"
  done
  ln -sf "${prefix}default.xsl" "${directory}/.default.xsl"
done
