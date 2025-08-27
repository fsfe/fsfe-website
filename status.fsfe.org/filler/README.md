# README

The languages to build a site in for the fsfe webpages are determined by what languages are available for that site, along with some heuristics about percentage of files translated, etc.

The status.fsfe.org page is a little different, as it needs to be built in languages that it has no proper files in.

It was decided that the best way to resolve this quandary was to just add some near empty files to the folder that would then successfully convince the build process to build it in all relevant languages.

This is accomplised programatically by means of the early_subdir.py script
