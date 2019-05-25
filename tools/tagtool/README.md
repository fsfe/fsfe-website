# Tagtool

## Example workflow

 1. xsltproc tagsToCSV.xsl tags/.tags.en.xml | sort > tagsdata.csv
 2. edit tagsdata.csv
 3. tagtool.sh tagsdata.csv

## Preparing a csv file:

```
xsltproc tagsToCSV.xsl tags/.tags.en.xml | sort > tagsdata.csv
```

This processes the tags data and outputs the columns "action;name;id;section;count".

Columns:
 * action: empty, to be filled by you
 * name: value of the "content" attribute
 * id: the tag itself
 * section: news|events
 * count

"Section" and "count" are for additional context only.
The "name" section comes at the beginning so that it is easier to find duplicate tags.

You can then fill the "action" field with the following actions:
 * mv:sometag
   rename the tag to sometag
 * rm
   remove the tag from all files

A word of warning: you'll probably need to polish the results by hand a little
(removing empty lines, checking for duplicate tags introduced by renaming).

## Debugging

You can call tagtool.sh with the environment variable "VERBOSE" set to 1.
