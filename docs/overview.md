# Overview

This is to serve as a general overview of the build process, largely aimed at those who intent to contribute to the process.

Firstly, the language of the build process is XML. Everything is based around XML, XHTML, XSL, with a few non XML extras the build process adds for features like choosing source files.

## Simple walkthrough

Firstly a general case of how the build process works. The build process,

1. Takes an XHTML source file, with name `<name>.<lang>.xhtml`
2. If it exists in the same dir, loads `<name>.sources` and makes any data files specified in it available.
3. This making available is done by loading the source XHTML, and specified data files, texts files for common strings into a new in memory XML.
4. Selects an XSL file to process the in memory XML with. It will use `<name>.xsl` if available, else the first `default.xsl` it finds ascending through parent dirs.
5. Processes the file, and puts the result into the output dir with name `<name>.<lang>.<html>`.
6. If the file name matches its parent directory name, IE it is in `<name>/<name>.<lang>.xhtml`, then generate an index symlink in the output dir.
7. Generate symlinks from `<name>.<lang>.html` to `<name>.html.<lang>`, for [Apache Multiviews](https://httpd.apache.org/docs/current/content-negotiation.html) (how we handle choosing pages based on user browser language)
8. If the site has been staged, which occurs when manually specified, using multiple targets, or using ssh targets. In this cases the build process will have built the sites to a local directory, and will then copy them to each of the specified targets.

## General details

The website uses incremental caching. These cache files are generally hidden files, and should be `gitignored`. For exactly what are cache files see the `gitignore` in the repo root. The build process determines what must be updated based on the file modification time of dependencies of any file.

Care has been taken to make sure that files are rebuilt only when required, and are always rebuild when required. But changes to fundamentals may not propagate correctly and may require a manually triggered full rebuild, or waiting till the nightly one on prod.

## Phases

For details on the phases and exact implementation please examine the codebase

The build process can be conceptually divided into four phases: Phases 0-3

### [phase0](./phase0.md)

### [phase1](./phase1.md)

### [phase2](./phase2.md)

### [phase3](./phase3.md)
