# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
"""Serve any websites in the output directory on localhost."""

import http.server
import logging
import multiprocessing
import os
import socketserver
import webbrowser
from pathlib import Path

logger = logging.getLogger(__name__)


def _run_webserver(path: Path, port: int) -> None:
    """Given a path and a port it will serve that dir on that localhost:port."""
    os.chdir(path)
    handler = http.server.SimpleHTTPRequestHandler

    with socketserver.TCPServer(("", port), handler) as httpd:
        httpd.serve_forever()


def serve_websites(
    serve_dir: Path, sites: list[Path], base_port: int, increment_number: int
) -> None:
    """Serve the sites in serve_dir from base port.

    Each sites port is increment by increment_number.

    It then serves all directories over http on localhost
    """
    site_names = [site.name for site in sites]
    dirs = (
        path
        for path in Path(serve_dir).iterdir()
        if (path.is_dir() and (path.name in site_names))
    )
    serves: list[tuple[Path, int]] = []
    for index, directory in enumerate(dirs):
        port = base_port + (increment_number * index)
        serves.append((directory, port))
    with multiprocessing.Pool(len(serves)) as pool:
        pool.starmap_async(_run_webserver, serves)
        for directory, port in serves:
            url = f"http://127.0.0.1:{port}"
            logger.info("%s served at %s", directory.name, url)
            webbrowser.open(url + "/index.en.html")
