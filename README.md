# FSFE Website

This repository contains the source files of [fsfe.org](https://fsfe.org), pdfreaders.org, freeyourandroid.org, ilovefs.org, drm.info, and test.fsfe.org.

## Table of Contents

* [Technical information](#technical-information)
* [Structure](#structure)
* [Contribute](#contribute)
* [Translate](#translate)
* [Build](#build)


## Technical information

Our web team has compiled some information about technology used for this website on the [Information for Webmasters](https://fsfe.org/contribute/web/) page.

## Structure

Most files are XHTML files organised in a rather logical folder structure. 

### Important folders

Notable directories are:

* `about`: Information about the FSFE itself, its team members etc
* `at`, `de`, `ee` etc: Folders used for the FSFE country teams
* `build`: Mostly custom Bash and XSL scripts to build the website
* `cgi-bin`: Our very few CGI scripts
* `error`: Custom 4xx and 5xx error pages
* `events`: Files for our events, ordered by year
* `graphics`: Icons, pictures and logos
* `internal`: Forms used mostly by FSFE staff for internal processes
* `look`: CSS and other style files
* `news`: Files for news articles, press releases, and newsletters ordered by year
* `order`: Our web shop
* `picturebase`: Central directory for pictures we use
* `scripts`: JavaScript files used on our pages
* `tags`: Files necessary to display used tags throughout the website. Mostly automatically generated
* `tools`: Contains miscellaneous XML, XSL, and SH files. Most notably it contains the static translated texts (strings).

### Other domains

This repository also contains the source files of other websites the FSFE hosts:

* `campaigns/android` for [freeyourandroid.org](http://freeyourandroid.org)
* `campaigns/ilovefs` for [ilovefs.org](http://ilovefs.org)
* `drm.info` for [drm.info](http://drm.info)
* `pdfreaders` for [pdfreaders.org](http://pdfreaders.org)
* [test.fsfe.org](http://test.fsfe.org) is build from the test branch of this repository

## Contribute

Become member of our awesome [webmaster team](https://fsfe.org/contribute/web/) and help improving our online information platform! The [web teams wiki page](https://wiki.fsfe.org/Teams/Web) contains info how to join the mailing list, where a issue tracker can be found, and how to edit the website's source code.

## Translate

We adore our voluntary translators who make information about Free Software available over 30 languages, from Arabic to Turkish!

Join them to spread the message of our community in all over Europe and beyond. The [translators team page](https://fsfe.org/contribute/translators/) will introduce you to its work.

## Build

You can build the fsfe.org website on your own computer to make previews of single pages possible offline and without having to wait for an online website build. A [dedicated wiki page](https://wiki.fsfe.org/TechDocs/Mainpage/BuildLocally) tells you how to do it.
