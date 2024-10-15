#!/usr/bin/env python3

import argparse
import http.server
import multiprocessing
import os
import socketserver


def run_webserver(path, PORT):
    os.chdir(path)
    Handler = http.server.SimpleHTTPRequestHandler
    httpd = socketserver.TCPServer(("0.0.0.0", PORT), Handler)

    httpd.serve_forever()

    return


def main():
    # Change dir to dir of script
    abspath = os.path.abspath(__file__)
    dname = os.path.dirname(abspath)
    os.chdir(dname)
    # Arguments:
    parser = argparse.ArgumentParser(
        description="Serve all directories in a folder over http"
    )
    parser.add_argument(
        "--serve-dir",
        dest="serve_dir",
        help="Directory to serve webpages from",
        type=str,
        default="./output/final",
    )
    parser.add_argument(
        "--base-port",
        dest="base_port",
        help="Initial value of http port",
        type=int,
        default=2000,
    )
    parser.add_argument(
        "--increment-number",
        dest="increment_number",
        help="Number to increment port num by per webpage",
        type=int,
        default=100,
    )
    args = parser.parse_args()

    dirs = list(
        filter(
            lambda item: os.path.isdir(item),
            map(lambda item: args.serve_dir + "/" + item, os.listdir(args.serve_dir)),
        )
    )
    servers = []
    for dir in dirs:
        port = args.base_port + (args.increment_number * dirs.index(dir))
        print(f"{dir} will be served on http://127.0.0.1:{port}")
        p = multiprocessing.Process(
            target=run_webserver,
            args=(dir, port),
        )

        servers.append(p)

    for server in servers:
        server.start()

    for server in servers:
        server.join()


if __name__ == "__main__":
    main()
