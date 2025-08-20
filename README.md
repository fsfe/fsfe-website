# FSFE Website

This repository contains the source files of [fsfe.org](https://fsfe.org), pdfreaders.org, freeyourandroid.org, ilovefs.org, drm.info, and test.fsfe.org.

## Table of Contents

- [Technical information](#technical-information)
- [Structure](#structure)
- [Contribute](#contribute)
- [Translate](#translate)
- [Build](#build)

## Technical information

Our web team has compiled some information about technology used for this website on the [Information for Webmasters](https://fsfe.org/contribute/web/) page. This is mainly focused on page content.

For information on how the build process works see [docs subfolder](./docs/overview.md). For more information on contributing to the buid process, please see the [contributor docs](./docs/contributing.md) for some useful tips.

Some tips for management can be found in the [management docs](./docs/management.md)

## Structure

Most files are XHTML files organised in a rather logical folder structure.

Every website served using this repo has its own folder with the full domain name it is to be served from.

### Domains

This repository also contains the source files of other websites the FSFE hosts:

- `fsfe.org` for [fsfe.org](http://fsfe.org)
- `activities/android` for [freeyourandroid.org](http://freeyourandroid.org)
- `activities/ilovefs` for [ilovefs.org](http://ilovefs.org)
- `drm.info` for [drm.info](http://drm.info)
- `pdfreaders.org` for [pdfreaders.org](http://pdfreaders.org)
- [test.fsfe.org](https://test.fsfe.org) is fsfe.org built from the test branch of this repository

### Important folders

Notable top level directories are:

- `build`: Mostly custom Bash and XSL scripts to build the website
- `global`: Globally used data files and modules, also the static translated strings.
- `tools`: Contains miscellaneous XML, XSL, and SH files.

And of course the different website folders.

And here are dome notable directories inside the folder for the main webpage, fsfe.org.

- `about`: Information about the FSFE itself, its team members etc
- `activities`: All specific FSFE activities
- `at`, `de`, `ee` etc: Folders used for the FSFE country teams
- `cgi-bin`: Our very few CGI scripts
- `error`: Custom 4xx and 5xx error pages
- `events`: Files for our events, ordered by year
- `freesoftware`: More timeless pages explaining Free Software and related topics
- `graphics`: Icons, pictures and logos
- `internal`: Forms used mostly by FSFE staff for internal processes
- `look`: CSS and other style files
- `news`: Files for news articles, press releases, and newsletters ordered by year
- `order`: Our web shop
- `scripts`: JavaScript files used on our pages
- `tags`: Files necessary to display used tags throughout the website. Mostly automatically generated

## Contribute

Become member of our awesome [webmaster team](https://fsfe.org/contribute/web/) and help to improve our online information platform!

## Translate

We adore our voluntary translators who make information about Free Software available over 30 languages, from Arabic to Turkish!

Join them to spread the message of our community in all over Europe and beyond. The [translators team page](https://fsfe.org/contribute/translators/) will introduce you to their amazing work.

You can see the current status of translation progress of fsfe.org at [status.fsfe.org/translations](https://status.fsfe.org/translations)

## Build

[See the docs for more comprehesive and beginner-friendly documentation](https://docs.fsfe.org/en/techdocs/mainpage/buildlocally).

There are two ways to build and develop the directory locally. Initial builds of the webpages may take ~12 minutes, but subsequent builds should be much faster. Using the `--languages` flag to avoid building all supported languages can make this much faster. The `--sites` flag allows for building only some of the sites in this repo, which can also provide a speed boost to the developer experience. Run `./build.py --help` for more information.

Alterations to build scripts or the files used site-wide will result in near full rebuilds.

### Native

We can either install the required dependencies manually using our preferred package manager. If you are a nix use one can run `nix-shell` to enter a shell with the required build dependencies.

If installing manually, you need the python package `uv` and the node package `lessc`.

Also needed are the libraries

```
libxml2 libxslt
```

As we are using [UV](https://docs.astral.sh/uv/) we can just run the build process directly, and let it handle deps.

The pages can be built and served by running `uv run build`. Try `--help` for more information. The simple web server used lacks the features of `apache` which used on the FSFE web servers. This is why no index is automatically selected for each directory and other behaviours.

### Docker

> Docker is used on the build server, so you can use this to replicate the exact behavior
> **Advantage**: Reproducibility, no changes on the host system
> **Disadvantage**: Docker breaks sometimes, bigger install size, more network usage

The docker build process is in some ways designed for deployment. This means that it expects some environment variables to be set to function. Namely, it will try and load ssh credentials and git credentials, and docker does not support providing default values to these.

So, to stub out this functionality, please set the environment variables
`KEY_PRIVATE KEY_PASSWORD GIT_TOKEN` to equal `none` when running docker. One can set them for the shell session, an example in bash is seen below.

```
export KEY_PRIVATE=none;
export KEY_PASSWORD=none;
export GIT_TOKEN=none;
```
One can then run Docker commands like `docker compose ...`.

Alternatively one can prefix the Docker commands with the required variables, like so
```
KEY_PRIVATE=none KEY_PASSWORD=none GIT_TOKEN=none docker compose
```
Once your preferred method has been chosen, simply running `docker compose run --service-ports build --serve` should build the webpages and make them available over localhost.


Some more explanation: we are essentially just using docker as a way to provide dependencies and then running the build script. All flags after `build` are passed to the `build` cli. The `service-ports` flag is required to open ports from the container for serving the output, not needed if not using the `--serve` flag of the build script.

## Githooks

The repo contains some highly recommended githooks that one should enable. They check for several kinds of common issues. They are also run in CI, so enabling them locally speeds the development feedback loop.

One can enable them locally using

```sh
rm .git/hooks -r                  # remove git's sample hooks
ln -s tools/githooks/ .git/hooks  # link our hooks to the right dir
```

The hooks have some extra dependencies, namely

```
git xmllint sed file grep bash perl mediainfo curl mktemp
```

The provided `nix-shell` includes the needed packages. Otherwise, they can be installed manually.

## Testing

While most small changes can be tested adequately by building locally some larger changes, particularly ones relating to the order pages, event registration and other forms may require more integrated testing. This can be achieved using the `test` branch. This branch is built and served in the same way as the main site, [fsfe.org](https://fsfe.org). The built version of the `test` branch may be viewed at [test.fsfe.org](https://test.fsfe.org).

## Status Viewing

The status of builds of [fsfe.org](https://fsfe.org) and [test.fsfe.org](https://test.fsfe.org) can be viewed at [status.fsfe.org](https://status.fsfe.org)
