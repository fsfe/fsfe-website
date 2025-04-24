# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

import http.server
import logging
import multiprocessing
import os
import socketserver
from pathlib import Path

logger = logging.getLogger(__name__)


def _run_webserver(path: str, port: int) -> None:
    """
    Given a path as a string and a port it will
    serve that dir on that localhost:port for forever.
    """
    os.chdir(path)
    Handler = http.server.CGIHTTPRequestHandler

    with socketserver.TCPServer(("", port), Handler) as httpd:
        httpd.serve_forever()


def serve_websites(serve_dir: str, base_port: int, increment_number: int) -> None:
    """
    Takes a target directory, a base port and a number to increment port by per dir
    It then serves all directories over http on localhost
    """
    dirs = sorted(list(filter(lambda path: path.is_dir(), Path(serve_dir).iterdir())))
    serves = []
    for dir in dirs:
        port = base_port + (increment_number * dirs.index(dir))
        logging.info(f"{dir.name} served at http://127.0.0.1:{port}")
        serves.append((str(dir), port))
    with multiprocessing.Pool(len(serves)) as pool:
        pool.starmap(_run_webserver, serves)
