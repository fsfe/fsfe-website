# Main Commands
Note that targets takes a comma separated list of valid rsync targets, and hence supports ssh targets. If targeting more than one directory one must use the --stage-dir flag documented below.
## build_main.sh [options] build_run "targets"
 Perform the page build. Write output to targets. The source directory is determined from the build scripts own location.

## build_main.sh [options] git_build_into "targets"
 Update repo to latest version of upstream branch and then perform a standard build. Write output to targets. The source directory is determined from the build scripts own location.

## build_main.sh [options] build_into "targets"
 Perform a full rebuild of the webpages, removing all cached files. Write output to targets. The source directory is determined from the build scripts own location.

# Internal Commands
It is unlikely that you will need to directly call these commands, but they are documented here never the less.
## build_main.sh [options] build_xmlstream "file.xhtml"
 Compile an xml stream from the specified file, additional sources will be determined and included automatically. The stream is suitable for being passed into xsltproc.

## build_main.sh [options] process_file "file.xhtml" [processor.xsl]
 Generate output from an xhtml file as if it would be processed during the
 build. Output is written to STDOUT and can be redirected as desired.
 If a xslt file is not given, it will be chosen automatically.

## build_main.sh [options] tree_maker [input_dir] "targets"
 Generate a set of make rules to build the website contained in input_dir. targets should be the www root of a web server. If input_dir is omitted, it will be the source directory determined from the build scripts location. Note: if targets is set via previous options, and only one parameter is given, then this parameter will be interpreted as input_dir

# OPTIONS
## --source "source_dir"
 Force a specific source directory. If not explicitly given source_dir is determined from the build scripts own location. Paths given in .sources files are interpreted as relative to source_dir making this option useful when building a webpage outside of the build scripts "regular" tree.

## --status-dir "status_dir"
A directory to which messages are written. If no status_dir is provided information will be written to stdout. The directory will also be used to store some temporary files, which would otherwise be set up in the system wide temp directory.

## --stage-dir "stage_dir"
Directory used for staging the website builds. The websites are first build into this directory, then copied to each targets.

## --build-env "selection"
Indicate the current build environment. "selection" can be one of: * "fsfe.org": building https://fsfe.org on the production server * "test.fsfe.org": building https://test.fsfe.org on the production server * "development" (default): local development build In a local development build, code to dynamically compile the less files into CSS will be included in the HTML output, while in the other environments, the precompiles fsfe.min.css (or valentine.min.css) will be referenced from the generated web pages.

## --languages "languages"
Takes a comma separated list of language shot codes to build the website in. For example, to build the site in English and French only one would use `--languages en,fr`. One of the built languages must be English.

## --help
Show this README.
