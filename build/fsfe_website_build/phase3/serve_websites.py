# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

import http.server
import logging
import multiprocessing
import os
import shutil
import socketserver
from pathlib import Path

from fsfe_website_build.lib.misc import run_command

logger = logging.getLogger(__name__)


def _run_webserver(path: str, port: int) -> None:
    """
    Given a path as a string and a port it will
    serve that dir on that localhost:port for forever.
    """
    os.chdir(path)
    handler = http.server.CGIHTTPRequestHandler

    with socketserver.TCPServer(("", port), handler) as httpd:
        httpd.serve_forever()


def serve_websites(
    serve_dir: Path, sites: list, base_port: int, increment_number: int
) -> None:
    """
    Takes a target directory, a base port and a number to increment port by per dir
    It then serves all directories over http on localhost
    """
    site_names = [site.name for site in sites]
    dirs = (
        path
        for path in Path(serve_dir).iterdir()
        if (path.is_dir() and (path.name in site_names))
    )
    serves = []
    for index, directory in enumerate(dirs):
        port = base_port + (increment_number * index)
        url = f"http://127.0.0.1:{port}"
        logger.info("%s served at %s", directory.name, url)
        if shutil.which("xdg-open") is not None:
            run_command(["xdg-open", url + "/index.en.html"])
        serves.append((str(directory), port))
    with multiprocessing.Pool(len(serves)) as pool:
        pool.starmap(_run_webserver, serves)
