# Phase 2

After all the XHTML files and their dependencies have been nicely lined up and prepared in phase 1, phase 2 begins

It will

1. Takes an XHTML source file, with name `<name>.<lang>.xhtml`
2. If it exists in the same dir, loads `<name>.sources` and makes any data files specified in it available.
3. This making available is done by loading the source XHTML, and specified data files, texts files for common strings into a new in memory XML.
4. Selects an XSL file to process the in memory XML with. It will use `<name>.xsl` if available, else the first `default.xsl` it finds ascending through parent dirs.
5. Processes the file, and puts the result into the output dir with name `<name>.<lang>.<html>`.
6. If the file name matches its parent directory name, IE it is in `<name>/<name>.<lang>.xhtml`, then generate an index symlink in the output dir.
7. Generate symlinks from `<name>.<lang>.html` to `<name>.html.<lang>`, for [Apache Multiviews](https://httpd.apache.org/docs/current/content-negotiation.html) (how we handle choosing pages based on user browser language)
8. Using some somewhat advanced XSL wizardry, Phase 2 is also able to build RSS and ICS files from XML data. The process of selecting stylesheets etc is the same as for XHTML>
9. Copies over any static files that are needed, like images, PDFs etc.

After phase 2 is over we have a copy of all sites built. If the site was not staged then it is in the target directory if it was staged, then it is in the staging directory.

And now, [phase3](./phase3.md)
