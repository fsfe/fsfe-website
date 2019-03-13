#!/bin/bash
# -----------------------------------------------------------------------------
# Update XSL stylesheets (*.xsl) according to their dependency
# -----------------------------------------------------------------------------
# This script is called from the phase 1 Makefile and updates (actually: just
# touches) all XSL files which depend on another XSL file that has changed
# since the last build run. The phase 2 Makefile then only has to consider the
# directly used stylesheet as a prerequisite for building each file and doesn't
# have to worry about other stylesheets imported into that one.
# -----------------------------------------------------------------------------

set -e
set -o pipefail

echo "* Updating XSL stylesheets"

pid=$$

# -----------------------------------------------------------------------------
# Generate a temporary makefile with dependencies for all .xsl files
# -----------------------------------------------------------------------------

makefile="/tmp/makefile-${pid}"

{
  for xsl_file in $(find * -name '*.xsl' -not -name '.default.xsl'); do
    prerequisites=$(echo $(
      cat "${xsl_file}" \
      | tr '\t\r\n' '   ' \
      | sed -r 's/(<xsl:(include|import)[^>]*>)/\n\1\n/g' \
      | sed -rn '/<xsl:(include|import)[^>]*>/s/^.*href *= *"([^"]*)".*$/\1/gp' \
      | xargs -I'{}' realpath "$(dirname ${xsl_file})/{}" \
    ))
    if [ -n "${prerequisites}" ]; then
      echo "all: ${xsl_file}"
      echo "${xsl_file}: ${prerequisites}"
      echo ""
    fi
  done 

  echo '%.xsl:'
  echo -e '\techo "*   Touching $@"'
  echo -e '\ttouch $@'
} > "${makefile}"

# -----------------------------------------------------------------------------
# Execute the temporary makefile
# -----------------------------------------------------------------------------

make --silent --file="${makefile}"

# -----------------------------------------------------------------------------
# Clean up
# -----------------------------------------------------------------------------

rm -f "${makefile}"
