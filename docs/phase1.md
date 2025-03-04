# Phase 1

Phase 1 is arguably the most complicated phase.

This phase never modifies the output directory, it concerns itself only with generating files in the source tree that are then used in phase 2.

It handles the generation of files not generated with an XSL processor (search indices, compiling CSS, etc) and ensuring the dependencies of each XHTML are present and up to date.

Phase 1 goes through XSL stylesheets, and updates the modification time of those whose parents have been updated, so that only the stylesheet an XHTML file depends on directly depends on modification times need be considered.

It runs the subdirectory scripts, which perform custom actions required by those directories. For example, the news and events subdirectory in the main site, use subdirectory scripts to generate indices based on a template for every year in the archives.

It also generates the paths for global texts files, for storing commonly used strings based on if that text exists or else it falls back to English.

It does a few other things, as well, for an exhaustive list please examine the codebase.

After phase 1 is complete we can be reasonably sure that dependencies for phase 2 etc are in place, and with timestamps that phase2 can depend on to be useful
